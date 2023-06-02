var express = require("express");
var router = express.Router();

var medidaController = require("../controllers/medidaController");

router.get("/ultimas/:idSensor", function (req, res) {
    medidaController.buscarUltimasMedidas(req, res);
});

router.get("/ultimas-locais", function (req, res) {
    medidaController.buscarUltimasMedidasLocais(req, res);
});

router.get("/semanal", function (req, res) {
    medidaController.buscarInfoSemanal(req, res);
});

router.get("/diario", function (req, res) {
    medidaController.buscarInfoDiario(req, res);
});

router.get("/listar", function (req, res) {
    medidaController.listar(req, res);
});

router.get("/tempo-real/:idSensor", function (req, res) {
    medidaController.buscarMedidasEmTempoReal(req, res);
})

module.exports = router;