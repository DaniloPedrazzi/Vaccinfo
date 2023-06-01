var database = require("../database/config")


function cadastrar(nome, fkEndereco){
    var instrucao = `
        INSERT INTO localSensor (nome, fkEmpresa, fkEndereco, fkSensor) VALUES ('${nome}', 1, ${fkEndereco}, 1);
    `;
    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function cadastrarEndereco(endereco, numero){
    var instrucao = `
        INSERT INTO endereco (logradouro, complemento) VALUES ('${endereco}', '${numero}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function retornarFks(endereco, numero){
    var instrucao = `
        SELECT idEndereco FROM endereco
        WHERE logradouro = '${endereco}'
        AND complemento = '${numero}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

module.exports = {
    cadastrar,
    cadastrarEndereco,
    retornarFks
};