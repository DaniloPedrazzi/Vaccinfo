var database = require("../database/config")

function listar(){
    var instrucao = `
        SELECT 
            ls.nome, 
            ls.tipoLocal, 
            end.logradouro, 
            end.complemento 
        FROM localSensor AS ls 
        LEFT JOIN endereco AS end 
            ON fkEndereco = idEndereco;`;
    console.log("Executando a instrução SQL: \n" + instrucao);
    return database.executar(instrucao);
}

function cadastrar(nome, fkEndereco, idSensor, tipoLocal){
    var instrucao = `
        INSERT INTO localSensor (nome, fkEmpresa, fkEndereco, fkSensor, tipoLocal) VALUES ('${nome}', 1, ${fkEndereco}, ${idSensor}, '${tipoLocal}');
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
    listar,
    cadastrar,
    cadastrarEndereco,
    retornarFks
};