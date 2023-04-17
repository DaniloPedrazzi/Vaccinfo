CREATE DATABASE Vaccinfo; -- Criar banco de dados Vaccinfo
USE Vaccinfo; -- Usar banco de dados Vaccinfo

-- Criar tabela usuario para armazenar dados dos usuarios registrados pelo site
-- A tabela deve conter uma chave primária, email, nome da empresa e senha.
-- Os campos citados acima são not null, ou seja, devem ser inseridas alguma informação para ser válido
-- O campo EMAIL tem uma constraint para verificar se o valor inserido é um email, ou seja, se possui um '@'
CREATE TABLE empresa (
	idEmpresa INT primary key auto_increment,
    nome VARCHAR(45),
    CNPJ CHAR(14),
    email VARCHAR(45),
		constraint chk_email check (email like'%@%'));
        
CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
	NomeCompleto VARCHAR(45) not null,
    email VARCHAR(45),
		constraint chk_email check (email like'%@%'),
    telefone CHAR(14),
    documento VARCHAR(45),
    dataNascimento DATE,
    fkEmpresa INT,
		constraint usuarioEmpresa foreign key (fkEmpresa) references empresa (idEmpresa)
);
CREATE TABLE login (
	idLoginAdm INT PRIMARY KEY AUTO_INCREMENT,
    login VARCHAR(45),
    senha VARCHAR(45),
    adiministrador TINYINT);
    
create table localizacao(
idLocal int auto_increment,
nome varchar(45),
descricao varchar(45),
fkEmpresa int,
	constraint fkLocalEmpresa foreign key (fkEmpresa) references empresa(idEmpresa),
    constraint pkLocal primary key (idLocal, fkEmpresa),
fkEndereco int,
	constraint fkLocalEndereco foreign key (fkEndereco) references endereco(idEndereco)
);
    
    

-- Criação da tabela SENSOR para registrar os sensores usados no nosso projeto
-- A tabela deve conter uma chave primária, o nome do sensor utilizado e o tipo de instalação (geladeira ou caminhão)
-- O campo INSTALACAO tem uma constraint para verificar se o valor inserido é um 'geladeira' ou 'caminhão'
CREATE TABLE SENSOR (
	IDSensor int PRIMARY KEY AUTO_INCREMENT,
   	NomeSensor VARCHAR(10),
	Instalacao VARCHAR(15),
	CONSTRAINT chk_instalacao CHECK (Instalacao IN('geladeira','caminhao'))
);
-- Criação da tabela LOTE para registrar os lotes de vacina registrados no nosso site
-- A tabela deve conter uma chave primária, o código do lote registrado e uma variavel INT para ser foreign key
-- O campo IDSensor(int) é uma foreign key que referencia o IDSensor na tabela SENSOR
CREATE TABLE LOTE (
	LoteReg int primary key auto_increment,
	Lote varchar(100),
	IDSensor int,
	constraint fk_Lsensor foreign key (IDSensor) references SENSOR(IDSensor)
   );
   
-- Criação da tabela TEMP para registrar a temperatura atual registrada no sensor
-- A tabela deve conter uma chave primária, um campo para o registro da data em que a temperatura foi inserida
-- No campo DtAtual, este, é configurado como 'datetime default current-timestamp'
-- A tabela também deve conter duas variaveis INT, que serão configuradas como foreign key
-- O campo IDSensor(int) e o Empresa(int), ambas são foreign key, na qual o primeiro se refere ao IDsensor da tabela Sensor
-- E o segundo, se refere ao UserID da tabela cadastro
CREATE TABLE TEMP (
	IDRegistro INT PRIMARY KEY AUTO_INCREMENT,
	DtAtual DATETIME DEFAULT CURRENT_TIMESTAMP,
	Temperatura VARCHAR(5),
	Empresa int,
	IDSensor int,
	CONSTRAINT fk_sensor FOREIGN KEY (IDSensor) REFERENCES SENSOR(IDSensor),
	CONSTRAINT fk_cadastro FOREIGN KEY(Empresa) REFERENCES CADASTRO(UserID)
);
-- Inserir um cadastro na tabela CADASTRO
insert into cadastro values
	(null, 'thiagogarcia526@gmail.com', 'senha123', 'Vaccinfo'),
	(null, 'vitor.mramos@sptech.school', 'senha123', 'Pfizer');

-- Inserir o sensor LM35 tanto na geladeira quanto no Caminhão
insert into sensor values
	(null, 'LM35', 'Geladeira'),
	(null, 'LM35', 'Caminhao');
    
-- Inserir dados sobre um lote
insert into lote values
	(null, 'BK1', 1),
	(null, 'BK2', 2);
    
-- Inserir dados sobre o registro de temperatuda do sensor
insert into temp (Temperatura, Empresa, IDSensor) values
	('30', 1, 1),
	('26', 2, 2);

-- Caso hipotético, no qual o lote que estava no caminhão, vá para a geladeira, necessário um update
update sensor set instalacao = 'Geladeira' where id = 2;

drop database vaccinfo;
