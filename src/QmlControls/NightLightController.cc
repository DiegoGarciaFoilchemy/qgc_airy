#include "NightLightController.h"

#include <QtCore/QProcess>
#include <QtCore/QString>
#include <QtCore/QStringList>

static const QString kGsettings = QStringLiteral("/usr/bin/gsettings");
static const QString kSchema    = QStringLiteral("org.gnome.settings-daemon.plugins.color");
static const QString kKey       = QStringLiteral("night-light-temperature");

NightLightController::NightLightController(QObject *parent)
    : QObject(parent)
{
    _temperature = _readCurrentTemperature();
}

int NightLightController::_readCurrentTemperature()
{
    QProcess proc;
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

void NightLightController::_applyTemperature(int value)
{
    value = qBound(kMinTemp, value, kMaxTemp);

    QProcess::execute(kGsettings,
                      {QStringLiteral("set"), kSchema,
                       QStringLiteral("night-light-enabled"),
                       QStringLiteral("true")});

    const int rc = QProcess::execute(kGsettings,
                      {QStringLiteral("set"), kSchema, kKey, QString::number(value)});

    if (rc == 0) {
        _temperature = value;
        emit temperatureChanged(_temperature);
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
