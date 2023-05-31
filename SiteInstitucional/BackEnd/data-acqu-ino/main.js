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
        
        const lm35Temperatura = parseFloat(data);
        
        valoresLm35Temperatura.push(lm35Temperatura);

        // *Lu* - usar apenas para quando for inserir
        if (HABILITAR_OPERACAO_INSERIR) {
            await poolBancoDados.execute(
                'INSERT INTO registro (dataHoraRegistro, temperatura, fkLocal, fkEmpresa) VALUES (now(), ?, 3, 1)',
                [lm35Temperatura]
            );
            console.log("valores inseridos no banco: ", lm35Temperatura)
        }
    });

    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

const servidor = (
    valoresLm35Temperatura
) => {
    // *Lu* - criando aplicação express (framework js)
    const app = express();
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });

    // *Lu* - rotas
    app.get('/sensores/lm35/temperatura', (_, response) => {
        return response.json(valoresLm35Temperatura);
    });
    
}

// *Lu* - funções serial / servidor

(async () => {
    const valoresLm35Temperatura = [];
    await serial(
        valoresLm35Temperatura
    );
    servidor(
        valoresLm35Temperatura
    );
})();