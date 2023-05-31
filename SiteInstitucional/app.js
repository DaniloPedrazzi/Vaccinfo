var express = require("express");
var cors = require("cors");
var path = require("path");
var PORTA = 3333;

var app = express();

var indexRouter = require("./BackEnd/web-data-viz/routes/index");
var usuarioRouter = require("./BackEnd/web-data-viz/routes/usuarios");
var avisosRouter = require("./BackEnd/web-data-viz/routes/avisos");
var medidasRouter = require("./BackEnd/web-data-viz/routes/medidas");

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "FrontEnd")));

app.use(cors());

app.use("/", indexRouter);
app.use("/usuarios", usuarioRouter);
app.use("/avisos", avisosRouter);
app.use("/medidas", medidasRouter)

app.listen(PORTA, function () {
    console.log(`Servidor do seu site já está rodando! Acesse o caminho a seguir para visualizar: http://localhost:${PORTA}`);
});
