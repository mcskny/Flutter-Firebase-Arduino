#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
#include <DHT.h>

#define FIREBASE_HOST "your firebase host link" 
#define FIREBASE_AUTH "your firebase key"
#define WIFI_SSID "your wifi name"
#define WIFI_PASSWORD "your wifi password"
#define DHTPIN D2    
#define DHTTYPE DHT11 

DHT dht(DHTPIN, DHTTYPE);
FirebaseData dataBase;

void setup()
{
  Serial.begin(9600);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected To IP Adress: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  Firebase.reconnectWiFi(true);

  dht.begin(); 
}

void loop()
{
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  Firebase.setFloatAsync(dataBase, "/humidity", humidity);
  Firebase.setFloatAsync(dataBase, "/temperature", temperature);
  Firebase.setBoolAsync(dataBase, "/isConnected", true);
  Firebase.pushAsync(dataBase, "/sensorData", "{\"humidity\": " + String(humidity) + ", \"temperature\": " + String(temperature) + "}");
  
  delay(2000); 
}
