// não altere!
const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');

// não altere!
const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

// configure a linha abaixo caso queira que os dados capturados sejam inseridos no banco de dados.
// false -> nao insere
// true -> insere
const HABILITAR_OPERACAO_INSERIR = true;

const serial = async (
    valoresLm35Temperatura
) => {
    let poolBancoDados = mysql.createPool({
        // altere!
        // CREDENCIAIS DO BANCO LOCAL - MYSQL WORKBENCH
        host: 'bl2qkel9phuwcy25r4ya-mysql.services.clever-cloud.com',
        user: 'ugsqw3rvnisnorpc',
        password: 'XM1qp5C4l8poBUmw3bmN',
        database: 'bl2qkel9phuwcy25r4ya'
    }).promise();

    // *Lu* - achar arduíno (porta)
    const portas = await serialport.SerialPort.list();
    const portaArduino = portas.find((porta) => porta.vendorId == 2341 && porta.productId == 43);
    if (!portaArduino) {
        throw new Error('O arduino não foi encontrado em nenhuma porta serial');
    }
    const arduino = new serialport.SerialPort(
        {
            path: portaArduino.path,
            baudRate: SERIAL_BAUD_RATE
        }
    );
    arduino.on('open', () => {
        console.log(`A leitura do arduino foi iniciada na porta ${portaArduino.path} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });

    // *Lu* - recebe string e transforma em valores que poderão ser utilizados
    // alteração: deixar apenas LM35
    
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        console.log(data);
        
        const lm35Temperatura1 = parseFloat(data);
        const lm35Temperatura2 = lm35Temperatura1 * 1.10;
        const lm35Temperatura3 = lm35Temperatura1 * 1.25;
        const lm35Temperatura4 = lm35Temperatura1 * 0.97;
        const lm35Temperatura5 = lm35Temperatura1 * 0.70;

        valoresLm35Temperatura.push(lm35Temperatura1, lm35Temperatura2, lm35Temperatura3, lm35Temperatura4, lm35Temperatura5);

        // *Lu* - usar apenas para quando for inserir
        if (HABILITAR_OPERACAO_INSERIR) {
            for (let i = 1; i <= valoresLm35Temperatura.length; i++) {
                await poolBancoDados.execute(
                    `INSERT INTO registro (dataHoraRegistro, temperatura, fkLocal, fkEmpresa) VALUES (now(), ${valoresLm35Temperatura[i]}, ${i}, 1)`
                );
                console.log("valores inseridos no banco: ", valoresLm35Temperatura[i])
            }
        }
    });

    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

// *Lu* - funções serial / servidor

(async () => {
    const valoresLm35Temperatura = [];
    await serial(
        valoresLm35Temperatura
    );
})();