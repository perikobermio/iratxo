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
    void read(unsigned long last_update);
    bool connected;
    JsonDocument data;
    unsigned long last_update;

    void setWriteCallback(std::function<void(String)> cb);

  private:
    std::function<void(String)> writeCallback;
};

#endif
