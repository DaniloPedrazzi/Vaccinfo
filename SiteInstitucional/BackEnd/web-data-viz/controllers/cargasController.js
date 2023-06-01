var cargasModel = require("../models/cargasModel");

function cadastrar(req, res) {
    // CAMPOS DO CADASTRO
    var nome = req.body.nomeServer;
    var fkEndereco = req.body.fkEnderecoServer

    // VALIDAÇÕES
    if (nome == undefined) {
        res.status(400).send("Seu nome está undefined!");
    } else {
        
        // Passe os valores como parâmetro e vá para o arquivo usuarioModel.js
        cargasModel.cadastrar(nome, fkEndereco)
                .then(
                function (resultado) {
                    res.json(resultado);
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log(
                        "\nHouve um erro ao realizar o cadastro! Erro: ",
                        erro.sqlMessage
                    );
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
}

function retornarFks(req, res){
    var endereco = req.body.enderecoServer;
    var numero = req.body.numeroServer;

    cargasModel.retornarFks(endereco, numero)
        .then(
            function (resultado) {
                res.json(resultado);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}

function cadastrarEndereco(req, res){
    var endereco = req.body.enderecoServer;
    var numero = req.body.numeroServer;

    cargasModel.cadastrarEndereco(endereco, numero)
        .then(
            function (resultado) {
                res.json(resultado);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}

module.exports = {
    cadastrar,
    cadastrarEndereco,
    retornarFks
}