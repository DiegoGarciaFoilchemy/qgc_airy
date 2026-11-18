/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QtCore/QDateTime>
#include <QtCore/QObject>

#include <atomic>

/// Wall clock for the application.
///
/// The personal computer clock is used by default. When the operator enables the
/// "use vehicle time" setting and a vehicle reports a valid GPS time, the clock
/// follows the vehicle instead. This matters on units without internet access,
/// where the personal computer clock is far from UTC.
class QGCClock : public QObject
{
    Q_OBJECT

public:
    explicit QGCClock(QObject *parent = nullptr);

    static QGCClock *instance();

    /// Call once at startup after SettingsManager exists.
    void init();

    /// Milliseconds since the UNIX epoch, UTC.
    static qint64 currentMSecsSinceEpoch();

    /// Clock time in the local time zone.
    static QDateTime currentDateTime();

    /// True when the clock follows a vehicle GPS time.
    bool usingVehicleTime() const;

    /// Feed the vehicle UTC time in milliseconds.
    /// A GPS time always wins. A vehicle clock message is ignored once a GPS time arrived.
    void setVehicleTime(qint64 utcMsecs, bool fromGps);

private slots:
    void _settingChanged();

private:
    void _applySetting();

    /// 2022-01-01 00:00 UTC. An earlier time is certainly wrong.
    static constexpr qint64 kEarliestPlausibleMsecs = 1640995200000LL;

    std::atomic<qint64> _offsetMsecs{0};
    std::atomic<bool> _vehicleTimeValid{false};
    std::atomic<bool> _gpsTimeValid{false};
    std::atomic<bool> _enabled{false};
};
