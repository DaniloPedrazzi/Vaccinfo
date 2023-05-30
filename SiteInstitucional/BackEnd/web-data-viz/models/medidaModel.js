var database = require("../database/config");

function buscarUltimasMedidas(idSensor, limite_linhas) {
    var instrucao = `select 
    temperatura as temperatura,
    dataHoraRegistro,
                DATE_FORMAT(dataHoraRegistro,'%H:%i:%s') as momento_grafico
                from registro
                where fkLocal = ${idSensor}
                order by idRegistro desc limit ${limite_linhas}`;

    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function buscarInfoSemanal() {
    var instrucao = `
    SELECT 
        ls.idLocal, 
        DAYNAME(r.dataHoraRegistro) AS diaSemana,
    CASE
        WHEN MIN(r.temperatura) < 2 OR MAX(r.temperatura) > 8 THEN 'Crítico'
        WHEN MAX(r.temperatura) > 4.4 AND MIN(r.temperatura) < 6.6 THEN 'Alerta'
        ELSE 'Ideal'
    END AS mensagem
    FROM
        registro r
    JOIN 
        localSensor ls ON r.fkLocal = ls.idLocal
    WHERE
        WEEKDAY(r.dataHoraRegistro) >= 0 AND WEEKDAY(r.dataHoraRegistro) <= 4
    GROUP BY
        ls.idLocal,
        DAYNAME(r.dataHoraRegistro);
    `;

    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function buscarInfoDiario() {
    var instrucao = `
    SELECT
        ls.idLocal,
        DAYNAME(r.dataHoraRegistro) AS diaSemana,
    CASE
        WHEN MIN(r.temperatura) < 2 OR MAX(r.temperatura) > 8 THEN 'Crítico'
        WHEN MAX(r.temperatura) > 4.4 AND MIN(r.temperatura) < 6.6 THEN 'Alerta'
        ELSE 'Ideal'
    END AS mensagem
    FROM
        registro r
    JOIN localSensor ls ON r.fkLocal = ls.idLocal
    WHERE
        DATE(r.dataHoraRegistro) = CURDATE()
    GROUP BY
        ls.idLocal, 
        DAYNAME(r.dataHoraRegistro);
    `;
    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function buscarMedidasEmTempoReal(idSensor) {
    var instrucao = `select 
    temperatura as temperatura,
                    DATE_FORMAT(dataHoraRegistro,'%H:%i:%s') as momento_grafico, 
                    fkLocal 
                    from registro where fkLocal = ${idSensor} 
                order by idRegistro desc limit 1`;

    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function listar() {
    var instrucao = `
    select localSensor.idLocal, localSensor.nome, sensor.tipoInstalacao , registro.temperatura, DATE_FORMAT(registro.dataHoraRegistro,'%Y%m%d%H%i%s') as dataHoraRegistro
        from localSensor
    join sensor on localSensor.fkSensor = sensor.idSensor
    join registro on localSensor.idLocal = registro.fkLocal
    order by localSensor.idLocal limit 1;
    `
    return database.executar(instrucao);
}


module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal,
    buscarInfoSemanal,
    buscarInfoDiario,
    listar
}
