#ifndef SIM_H
#define SIM_H

#include <Arduino.h>
#include <functional>
#include <string>
#include <ArduinoJson.h>

class Sim {
  public:
    Sim();
    void connect();
    void read();
    bool connected;
    JsonDocument data;

    void setWriteCallback(std::function<void(String)> cb);

  private:
    std::function<void(String)> writeCallback;
};

#endif
