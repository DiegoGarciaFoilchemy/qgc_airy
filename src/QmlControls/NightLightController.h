#pragma once

#include <QtCore/QObject>

/// Controller for adjusting Ubuntu GNOME night light color temperature.
/// Exposes increase() / decrease() to QML.
/// Temperature range: 1000K (very warm) – 6500K (cool).
class NightLightController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int  temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(bool isSupported  READ isSupported  CONSTANT)

public:
    explicit NightLightController(QObject *parent = nullptr);

    int  temperature() const { return _temperature; }
    bool isSupported()  const { return _supported; }

    Q_INVOKABLE void increase(int step = 500);
    Q_INVOKABLE void decrease(int step = 500);

signals:
    void temperatureChanged(int temperature);

private:
    void _applyTemperature(int value);
    int  _readCurrentTemperature();

    int  _temperature = 4000;
    bool _supported    = false;

    static constexpr int kMinTemp = 1000;
    static constexpr int kMaxTemp = 6500;
};
