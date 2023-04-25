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

Serial.println(temperaturaSimulada);

delay(2000);
}
