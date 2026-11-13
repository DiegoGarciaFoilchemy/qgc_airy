/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "SettingsManager.h"
#include "QGCLoggingCategory.h"
#ifndef QGC_NO_ARDUPILOT_DIALECT
#include "APMMavlinkStreamRateSettings.h"
#endif
#include "AppSettings.h"
#include "AutoConnectSettings.h"
#include "BatteryIndicatorSettings.h"
#include "BrandImageSettings.h"
#include "MavlinkActionsSettings.h"
#include "FirmwareUpgradeSettings.h"
#include "FlightModeSettings.h"
#include "FlyViewSettings.h"
#include "PlanViewSettings.h"
#include "RTKSettings.h"
#include "UnitsSettings.h"
#include "MavlinkSettings.h"
#ifdef QGC_VIEWER3D
#include "Viewer3DSettings.h"
#endif

#include <QtCore/qapplicationstatic.h>
#include <QtQml/qqml.h>

QGC_LOGGING_CATEGORY(SettingsManagerLog, "qgc.settings.settingsmanager")

Q_APPLICATION_STATIC(SettingsManager, _settingsManagerInstance);

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent)
{
    // qCDebug(SettingsManagerLog) << Q_FUNC_INFO << this;
}

SettingsManager::~SettingsManager()
{
    // qCDebug(SettingsManagerLog) << Q_FUNC_INFO << this;
}

SettingsManager *SettingsManager::instance()
{
    return _settingsManagerInstance();
}

void SettingsManager::registerQmlTypes()
{
    (void) qmlRegisterUncreatableType<SettingsManager>("QGroundControl.SettingsManager", 1, 0, "SettingsManager", "Reference only");
}

void SettingsManager::init()
{
    _unitsSettings = new UnitsSettings(this); // Must be first since AppSettings references it

#ifndef QGC_NO_ARDUPILOT_DIALECT
    _apmMavlinkStreamRateSettings = new APMMavlinkStreamRateSettings(this);
#endif
    _appSettings = new AppSettings(this);
    _autoConnectSettings = new AutoConnectSettings(this);
    _batteryIndicatorSettings = new BatteryIndicatorSettings(this);
    _brandImageSettings = new BrandImageSettings(this);
    _mavlinkActionsSettings = new MavlinkActionsSettings(this);
    _firmwareUpgradeSettings = new FirmwareUpgradeSettings(this);
    _flightModeSettings = new FlightModeSettings(this);
    _flyViewSettings = new FlyViewSettings(this);
    _planViewSettings = new PlanViewSettings(this);
    _rtkSettings = new RTKSettings(this);
    _mavlinkSettings = new MavlinkSettings(this);
#ifdef QGC_VIEWER3D
    _viewer3DSettings = new Viewer3DSettings(this);
#endif
}

#ifndef QGC_NO_ARDUPILOT_DIALECT
APMMavlinkStreamRateSettings *SettingsManager::apmMavlinkStreamRateSettings() const { return _apmMavlinkStreamRateSettings; }
#endif
AppSettings *SettingsManager::appSettings() const { return _appSettings; }
AutoConnectSettings *SettingsManager::autoConnectSettings() const { return _autoConnectSettings; }
BatteryIndicatorSettings *SettingsManager::batteryIndicatorSettings() const { return _batteryIndicatorSettings; }
BrandImageSettings *SettingsManager::brandImageSettings() const { return _brandImageSettings; }
MavlinkActionsSettings *SettingsManager::mavlinkActionsSettings() const { return _mavlinkActionsSettings; }
FirmwareUpgradeSettings *SettingsManager::firmwareUpgradeSettings() const { return _firmwareUpgradeSettings; }
FlightModeSettings *SettingsManager::flightModeSettings() const { return _flightModeSettings; }
FlyViewSettings *SettingsManager::flyViewSettings() const { return _flyViewSettings; }
PlanViewSettings *SettingsManager::planViewSettings() const { return _planViewSettings; }
RTKSettings *SettingsManager::rtkSettings() const { return _rtkSettings; }
UnitsSettings *SettingsManager::unitsSettings() const { return _unitsSettings; }
MavlinkSettings *SettingsManager::mavlinkSettings() const { return _mavlinkSettings; }
#ifdef QGC_VIEWER3D
Viewer3DSettings *SettingsManager::viewer3DSettings() const { return _viewer3DSettings; }
#endif
