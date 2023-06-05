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

function buscarUltimasMedidasLocais() {
    var instrucao = `SELECT 
    localSensor.nome AS nome_local,
    temperatura,
    DATE_FORMAT(dataHoraRegistro, '%H:%i:%s') AS momento_grafico,
    fkLocal 
    FROM 
        registro
    JOIN 
        localSensor 
        ON fkLocal = idLocal
    WHERE
        (fkLocal, dataHoraRegistro) IN (
            SELECT 
                fkLocal, MAX(dataHoraRegistro)
            FROM 
                registro
            GROUP BY 
                fkLocal
        );`;

    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function buscarInfoSemanal() {
    var instrucao = `
    SELECT 
        ls.idLocal, 
        DAYNAME(r.dataHoraRegistro) AS diaSemana,
    CASE
        WHEN MIN(r.temperatura) <= 2 OR MAX(r.temperatura) >= 8 THEN 'Crítico'
        WHEN MAX(r.temperatura) <= 4.4 AND MIN(r.temperatura) >= 6.6 THEN 'Alerta'
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
		WHEN temperatura > 4.4 AND temperatura < 6.6 THEN 'Ideal'
        WHEN temperatura <= 2 OR temperatura >= 8 THEN 'Crítico'
        WHEN temperatura <= 4.4 OR temperatura >= 6.6 THEN 'Alerta'
    END AS mensagem
FROM
    localSensor ls
JOIN
    registro r ON ls.idLocal = r.fkLocal
WHERE
    (ls.idLocal, r.dataHoraRegistro) IN (
        SELECT
            fkLocal,
            MAX(dataHoraRegistro)
        FROM
            registro
        WHERE
            DATE(dataHoraRegistro) = CURDATE()
        GROUP BY
            fkLocal
    );
    `;
    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function buscarMedidasEmTempoReal(idSensor) {
    var instrucao = `select 
    localSensor.nome as nome_local,
    temperatura as temperatura,
                    DATE_FORMAT(dataHoraRegistro,'%H:%i:%s') as momento_grafico, 
                    fkLocal 
                    from registro 
                    join localSensor 
                    on fkLocal = idLocal
                    where fkLocal = ${idSensor} 
                order by idRegistro desc limit 1`;

    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function listar() {
    var instrucao = `
        SELECT
            ls.idLocal,
            ls.nome AS nomeLocal,
            ls.tipoLocal AS tipoInstalacao,
        CASE
            WHEN MIN(r.temperatura) <= 2 OR MAX(r.temperatura) >= 8 THEN 'Crítico'
            WHEN MAX(r.temperatura) <= 4.4 AND MIN(r.temperatura) >= 6.6 THEN 'Alerta'
            ELSE 'Ideal'
        END AS categoria
        FROM
            (
                SELECT
                    r.fkLocal,
                    r.temperatura
                FROM
                    registro r
                ORDER BY
                    r.dataHoraRegistro DESC
                LIMIT
                    7
            ) AS r
        JOIN localSensor ls ON r.fkLocal = ls.idLocal
        GROUP BY
            ls.idLocal,
            ls.nome,
            ls.tipoLocal;
    `;
    return database.executar(instrucao);
}


module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal,
    buscarUltimasMedidasLocais,
    buscarInfoSemanal,
    buscarInfoDiario,
    listar
}
