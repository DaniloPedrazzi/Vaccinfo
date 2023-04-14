int lm35_pin = A0, leitura_lm35 = 0;
float temperaturaReal, temperaturaSimulada;
float sensor2, sensor3, sensor4;
void setup()
{
Serial.begin(9600);
}
void loop()
{
leitura_lm35 = analogRead(lm35_pin);
temperaturaReal = leitura_lm35 * (5.0/1023) * 100;
temperaturaSimulada = (temperaturaReal * 0.584) - 8.845;
sensor2 = temperaturaSimulada * 1.05;
sensor3 = temperaturaSimulada * 1.10;
sensor4 = temperaturaSimulada * 0.90;
Serial.print(temperaturaSimulada);
Serial.print(";");
Serial.print(sensor2);
Serial.print(";");
Serial.print(sensor3);
Serial.print(";");
Serial.print(sensor4);
Serial.println(";");
delay(700);
}
