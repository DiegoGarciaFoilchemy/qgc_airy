#include "NightLightController.h"

#include <QtCore/QProcess>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QProcessEnvironment>
#include <QtCore/QFileInfo>
#include <unistd.h>

static const QString kGsettings = QStringLiteral("/usr/bin/gsettings");
static const QString kSchema    = QStringLiteral("org.gnome.settings-daemon.plugins.color");
static const QString kKey       = QStringLiteral("night-light-temperature");

NightLightController::NightLightController(QObject *parent)
    : QObject(parent)
{
    _temperature = _readCurrentTemperature();
    if (!_supported) {
        // D-Bus / gsettings may not be ready yet (early launch). Retry periodically.
        connect(&_retryTimer, &QTimer::timeout, this, &NightLightController::_retryDetect);
        _retryTimer.start(3000);
    }
}

static QProcessEnvironment _dbusEnv()
{
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    // When launched at boot by a system service, DBUS_SESSION_BUS_ADDRESS is often
    // missing. Probe the well-known socket path for the current user.
    if (!env.contains(QStringLiteral("DBUS_SESSION_BUS_ADDRESS"))) {
        const QString socketPath = QStringLiteral("/run/user/%1/bus").arg(::getuid());
        if (QFileInfo::exists(socketPath)) {
            env.insert(QStringLiteral("DBUS_SESSION_BUS_ADDRESS"),
                       QStringLiteral("unix:path=") + socketPath);
        }
    }
    // AppImages prepend their bundled libs to LD_LIBRARY_PATH. If gsettings inherits
    // that, it loads incompatible glib/gio from the AppImage and fails silently.
    // Remove it so the subprocess uses the system libraries.
    env.remove(QStringLiteral("LD_LIBRARY_PATH"));
    return env;
}

int NightLightController::_readCurrentTemperature()
{
    QProcess proc;
    proc.setProcessEnvironment(_dbusEnv());
    proc.start(kGsettings, {QStringLiteral("get"), kSchema, kKey});
    if (!proc.waitForFinished(2000)) {
        return 4000;
    }
    // gsettings outputs "uint32 4500" — strip the type prefix if present
    QString output = QString::fromUtf8(proc.readAllStandardOutput()).trimmed();
    const int spaceIdx = output.lastIndexOf(QLatin1Char(' '));
    if (spaceIdx != -1) {
        output = output.mid(spaceIdx + 1);
    }
    bool ok = false;
    const int val = output.toInt(&ok);
    if (!ok || val < kMinTemp || val > kMaxTemp) {
        return 4000;
    }
    _supported = true;
    return val;
}

int NightLightController::_brightnessForTemperature(int temp) const
{
    // Linear map: kMinTemp → kMinBrightness(30%), kMaxTemp → kMaxBrightness(100%)
    const double ratio = static_cast<double>(temp - kMinTemp) / (kMaxTemp - kMinTemp);
    return kMinBrightness + static_cast<int>(ratio * (kMaxBrightness - kMinBrightness));
}

void NightLightController::_applyBrightness(int percent)
{
    percent = qBound(kMinBrightness, percent, kMaxBrightness);

    QProcess p;
    p.start(QStringLiteral("brightnessctl"),
            {QStringLiteral("-d"), QStringLiteral("acpi_video0"),
             QStringLiteral("set"), QString::number(percent) + QLatin1Char('%')});
    p.waitForFinished(2000);

    if (p.exitCode() == 0) {
        _brightness = percent;
        emit brightnessChanged(_brightness);
    }
}

void NightLightController::_applyTemperature(int value)
{
    value = qBound(kMinTemp, value, kMaxTemp);

    {
        QProcess p;
        p.setProcessEnvironment(_dbusEnv());
        p.start(kGsettings, {QStringLiteral("set"), kSchema,
                             QStringLiteral("night-light-enabled"),
                             QStringLiteral("true")});
        p.waitForFinished(2000);
    }

    QProcess p2;
    p2.setProcessEnvironment(_dbusEnv());
    p2.start(kGsettings, {QStringLiteral("set"), kSchema, kKey, QString::number(value)});
    p2.waitForFinished(2000);
    const int rc = p2.exitCode();

    if (rc == 0) {
        _temperature = value;
        emit temperatureChanged(_temperature);
        _applyBrightness(_brightnessForTemperature(_temperature));
    }
}

void NightLightController::_retryDetect()
{
    _temperature = _readCurrentTemperature();
    if (_supported) {
        _retryTimer.stop();
        emit isSupportedChanged(true);
        emit temperatureChanged(_temperature);
    } else if (++_retryCount >= kMaxRetries) {
        _retryTimer.stop();
    }
}

void NightLightController::increase(int step)
{
    _applyTemperature(_temperature + step);
}

void NightLightController::decrease(int step)
{
    _applyTemperature(_temperature - step);
}
