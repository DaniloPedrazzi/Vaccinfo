var express = require("express");
var router = express.Router();

var cargasController = require("../controllers/cargasController");

router.get("/listar", function (req, res) {
    cargasController.listar(req, res);
});

router.post("/cadastrar", function (req, res) {
    cargasController.cadastrar(req, res);
});

router.post("/retornarFks", function (req, res) {
    cargasController.retornarFks(req, res);
});

router.post("/cadastrarEndereco", function (req, res) {
    cargasController.cadastrarEndereco(req, res);
});

module.exports = router;