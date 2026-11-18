/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "QGCClock.h"
#include "QGCLoggingCategory.h"
#include "MavlinkSettings.h"
#include "SettingsManager.h"

#include "Fact.h"

#include <QtCore/QGlobalStatic>

QGC_LOGGING_CATEGORY(QGCClockLog, "qgc.utilities.qgcclock")

Q_GLOBAL_STATIC(QGCClock, _qgcClockInstance)

QGCClock::QGCClock(QObject *parent)
    : QObject(parent)
{
}

QGCClock *QGCClock::instance()
{
    return _qgcClockInstance();
}

void QGCClock::init()
{
    _applySetting();

    Fact *const fact = SettingsManager::instance()->mavlinkSettings()->useVehicleTimeForClock();
    if (fact) {
        (void) connect(fact, &Fact::rawValueChanged, this, &QGCClock::_settingChanged);
    }
}

void QGCClock::_settingChanged()
{
    _applySetting();
}

void QGCClock::_applySetting()
{
    SettingsManager *const settingsManager = SettingsManager::instance();
    if (!settingsManager || !settingsManager->mavlinkSettings()) {
        return;
    }

    Fact *const fact = settingsManager->mavlinkSettings()->useVehicleTimeForClock();
    if (!fact) {
        return;
    }

    const bool enabled = fact->rawValue().toBool();
    qCDebug(QGCClockLog) << "Use vehicle time" << enabled;
    _enabled = enabled;

    if (!enabled) {
        _vehicleTimeValid = false;
        _gpsTimeValid = false;
        _offsetMsecs = 0;
    }
}

bool QGCClock::usingVehicleTime() const
{
    return _enabled && _vehicleTimeValid;
}

void QGCClock::setVehicleTime(qint64 utcMsecs, bool fromGps)
{
    if (!_enabled) {
        return;
    }

    if (utcMsecs < kEarliestPlausibleMsecs) {
        return;
    }

    if (!fromGps && _gpsTimeValid) {
        // The vehicle clock may be wrong, the GPS time is not.
        return;
    }

    const qint64 previousOffset = _offsetMsecs;
    const bool wasValid = _vehicleTimeValid;

    _offsetMsecs = utcMsecs - QDateTime::currentMSecsSinceEpoch();
    _vehicleTimeValid = true;
    if (fromGps) {
        _gpsTimeValid = true;
    }

    if (!wasValid || (qAbs(_offsetMsecs - previousOffset) > 1000)) {
        qCDebug(QGCClockLog) << "Vehicle time adopted" << QDateTime::fromMSecsSinceEpoch(utcMsecs).toString(Qt::ISODate)
                             << "offsetMsecs" << _offsetMsecs.load() << "fromGps" << fromGps;
    }
}

qint64 QGCClock::currentMSecsSinceEpoch()
{
    const qint64 localMsecs = QDateTime::currentMSecsSinceEpoch();
    const QGCClock *const clock = instance();
    if (!clock->_enabled || !clock->_vehicleTimeValid) {
        return localMsecs;
    }

    return localMsecs + clock->_offsetMsecs;
}

QDateTime QGCClock::currentDateTime()
{
    return QDateTime::fromMSecsSinceEpoch(currentMSecsSinceEpoch());
}
