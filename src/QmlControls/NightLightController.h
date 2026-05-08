#pragma once

#include <QtCore/QObject>
#include <QtCore/QTimer>

/// Controller for adjusting Ubuntu GNOME night light color temperature and
/// screen brightness.  Exposes increase() / decrease() to QML.
/// Temperature range: 1000K (very warm) – 6500K (cool).
/// Brightness follows temperature: 100 % at max temp, 30 % at min temp.
/// Brightness is applied via brightnessctl -d acpi_video0.
class NightLightController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int  temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(int  brightness  READ brightness  NOTIFY brightnessChanged)
    Q_PROPERTY(bool isSupported  READ isSupported  NOTIFY isSupportedChanged)

public:
    explicit NightLightController(QObject *parent = nullptr);

    int  temperature() const { return _temperature; }
    int  brightness()  const { return _brightness; }
    bool isSupported()  const { return _supported; }

    Q_INVOKABLE void increase(int step = 500);
    Q_INVOKABLE void decrease(int step = 500);

signals:
    void temperatureChanged(int temperature);
    void brightnessChanged(int brightness);
    void isSupportedChanged(bool isSupported);

private:
    void _applyTemperature(int value);
    int  _readCurrentTemperature();
    void _applyBrightness(int percent);
    int  _brightnessForTemperature(int temp) const;
    void _retryDetect();

    int    _temperature   = 4000;
    int    _brightness    = 100;
    bool   _supported     = false;
    int    _retryCount    = 0;
    QTimer _retryTimer;

    static constexpr int kMinTemp       = 1000;
    static constexpr int kMaxTemp       = 6500;
    static constexpr int kMinBrightness = 30;
    static constexpr int kMaxBrightness = 100;
    static constexpr int kMaxRetries    = 10;
};
