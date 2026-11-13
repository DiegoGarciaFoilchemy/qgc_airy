/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QtCore/QLoggingCategory>
#include <QtCore/QObject>
#include <QtQmlIntegration/QtQmlIntegration>

class APMMavlinkStreamRateSettings;
class AppSettings;
class AutoConnectSettings;
class BatteryIndicatorSettings;
class BrandImageSettings;
class MavlinkActionsSettings;
class FirmwareUpgradeSettings;
class FlightModeSettings;
class FlyViewSettings;
class PlanViewSettings;
class RTKSettings;
class UnitsSettings;
class Viewer3DSettings;
class MavlinkSettings;

Q_DECLARE_LOGGING_CATEGORY(SettingsManagerLog)

/// Provides access to all app settings
class SettingsManager : public QObject
{
    Q_OBJECT
    // QML_ELEMENT
    // QML_UNCREATABLE("")
#ifndef QGC_NO_ARDUPILOT_DIALECT
    Q_MOC_INCLUDE("APMMavlinkStreamRateSettings.h")
#endif
    Q_MOC_INCLUDE("AppSettings.h")
    Q_MOC_INCLUDE("AutoConnectSettings.h")
    Q_MOC_INCLUDE("BatteryIndicatorSettings.h")
    Q_MOC_INCLUDE("BrandImageSettings.h")
    Q_MOC_INCLUDE("MavlinkActionsSettings.h")
    Q_MOC_INCLUDE("FirmwareUpgradeSettings.h")
    Q_MOC_INCLUDE("FlightModeSettings.h")
    Q_MOC_INCLUDE("FlyViewSettings.h")
    Q_MOC_INCLUDE("PlanViewSettings.h")
    Q_MOC_INCLUDE("RTKSettings.h")
    Q_MOC_INCLUDE("UnitsSettings.h")
    Q_MOC_INCLUDE("MavlinkSettings.h")
#ifdef QGC_VIEWER3D
    Q_MOC_INCLUDE("Viewer3DSettings.h")
#endif
#ifndef QGC_NO_ARDUPILOT_DIALECT
    Q_PROPERTY(QObject *apmMavlinkStreamRateSettings    READ apmMavlinkStreamRateSettings   CONSTANT)
#endif
    Q_PROPERTY(QObject *appSettings                     READ appSettings                    CONSTANT)
    Q_PROPERTY(QObject *autoConnectSettings             READ autoConnectSettings            CONSTANT)
    Q_PROPERTY(QObject *batteryIndicatorSettings        READ batteryIndicatorSettings       CONSTANT)
    Q_PROPERTY(QObject *brandImageSettings              READ brandImageSettings             CONSTANT)
    Q_PROPERTY(QObject *mavlinkActionsSettings    READ mavlinkActionsSettings   CONSTANT)
    Q_PROPERTY(QObject *firmwareUpgradeSettings         READ firmwareUpgradeSettings        CONSTANT)
    Q_PROPERTY(QObject *flightModeSettings              READ flightModeSettings             CONSTANT)
    Q_PROPERTY(QObject *flyViewSettings                 READ flyViewSettings                CONSTANT)
    Q_PROPERTY(QObject *planViewSettings                READ planViewSettings               CONSTANT)
    Q_PROPERTY(QObject *rtkSettings                     READ rtkSettings                    CONSTANT)
    Q_PROPERTY(QObject *unitsSettings                   READ unitsSettings                  CONSTANT)
    Q_PROPERTY(QObject *mavlinkSettings                 READ mavlinkSettings                CONSTANT)
#ifdef QGC_VIEWER3D
    Q_PROPERTY(QObject *viewer3DSettings                READ viewer3DSettings               CONSTANT)
#endif
public:
    SettingsManager(QObject *parent = nullptr);
    ~SettingsManager();

    static SettingsManager *instance();
    static void registerQmlTypes();

    void init();

#ifndef QGC_NO_ARDUPILOT_DIALECT
    APMMavlinkStreamRateSettings *apmMavlinkStreamRateSettings() const;
#endif
    AppSettings *appSettings() const;
    AutoConnectSettings *autoConnectSettings() const;
    BatteryIndicatorSettings *batteryIndicatorSettings() const;
    BrandImageSettings *brandImageSettings() const;
    MavlinkActionsSettings *mavlinkActionsSettings() const;
    FirmwareUpgradeSettings *firmwareUpgradeSettings() const;
    FlightModeSettings *flightModeSettings() const;
    FlyViewSettings *flyViewSettings() const;
    PlanViewSettings *planViewSettings() const;
    RTKSettings *rtkSettings() const;
    UnitsSettings *unitsSettings() const;
    MavlinkSettings *mavlinkSettings() const;
#ifdef QGC_VIEWER3D
    Viewer3DSettings *viewer3DSettings() const;
#endif

private:
#ifndef QGC_NO_ARDUPILOT_DIALECT
    APMMavlinkStreamRateSettings *_apmMavlinkStreamRateSettings = nullptr;
#endif
    AppSettings *_appSettings = nullptr;
    AutoConnectSettings *_autoConnectSettings = nullptr;
    BatteryIndicatorSettings *_batteryIndicatorSettings = nullptr;
    BrandImageSettings *_brandImageSettings = nullptr;
    MavlinkActionsSettings *_mavlinkActionsSettings = nullptr;
    FirmwareUpgradeSettings *_firmwareUpgradeSettings = nullptr;
    FlightModeSettings *_flightModeSettings = nullptr;
    FlyViewSettings *_flyViewSettings = nullptr;
    PlanViewSettings *_planViewSettings = nullptr;
    RTKSettings *_rtkSettings = nullptr;
    UnitsSettings *_unitsSettings = nullptr;
    MavlinkSettings *_mavlinkSettings = nullptr;
#ifdef QGC_VIEWER3D
    Viewer3DSettings *_viewer3DSettings = nullptr;
#endif
};
