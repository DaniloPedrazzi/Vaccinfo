CREATE DATABASE Vaccinfo; -- Criar banco de dados Vaccinfo
USE Vaccinfo; -- Usar banco de dados Vaccinfo

-- Criando a tabela empresa para armazenar dados da empresa contratante.
-- O campo EMAIL tem uma constraint para verificar se o valor inserido é um email, ou seja, se possui um '@'

CREATE TABLE empresa (
	idEmpresa INT primary key auto_increment,
    nome VARCHAR(45),
    CNPJ CHAR(14),
    email VARCHAR(45),
		constraint chk_email check (email like'%@%'),
	telefone VARCHAR(16));

-- Criar tabela usuario para armazenar dados dos usuarios registrados pelo site
-- O campo EMAIL tem uma constraint para verificar se o valor inserido é um email, ou seja, se possui um '@'
-- A tabela usuario tem um campo com uma chave estrangeira para armazenar de qual empresa aquele usuário pertence

CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
	NomeCompleto VARCHAR(45) not null,
    email VARCHAR(45),
		constraint chk_email_user check (email like'%@%'),
    telefone CHAR(14),
    tipoDocumento VARCHAR(10),
		constraint chk_tipo_documento check (tipoDocumento in('cpf', 'passaporte')),
    documento VARCHAR(45),
    dataNascimento DATE,
    fkEmpresa INT,
		constraint usuarioEmpresa foreign key (fkEmpresa) references empresa (idEmpresa)
);

-- tabela login para armazenar os dados inserindos na tela de login e validar se o usuario é administrador

CREATE TABLE login (
	idLoginAdm INT PRIMARY KEY AUTO_INCREMENT,
    login VARCHAR(45),
    senha VARCHAR(45),
    administrador TINYINT,
    fkUsuario INT,
		constraint loginUsuario foreign key (fkUsuario) references usuario (idUsuario),
        constraint chkAdm check (administrador in(0,1))
	);

-- Criar tabela endereço para armazenar os dados da localização da empresa

CREATE TABLE endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(45),
    complemento VARCHAR(45),
    bairro VARCHAR(45),
    cidade VARCHAR(45),
    estado CHAR(2)
    );
        
-- Criar tabela local para armazenar os dados da localização a ser monitorada dentro do endereço da empresa

create table localSensor(
	idLocal int auto_increment,
	nome varchar(45),
	fkEmpresa int,
		constraint fkLocalEmpresa foreign key (fkEmpresa) references empresa(idEmpresa),
		constraint pkLocal primary key (idLocal, fkEmpresa),
	fkEndereco int,
		constraint fkLocalEndereco foreign key (fkEndereco) references endereco(idEndereco)
);
    
    

-- Criação da tabela SENSOR para registrar os sensores usados no nosso projeto
-- A tabela deve conter uma chave primária, o nome do sensor utilizado e o tipo de instalação (geladeira ou caminhão)
-- O campo INSTALACAO tem uma constraint para verificar se o valor inserido é um 'geladeira' ou 'caminhão'

CREATE TABLE sensor (
	idSensor int PRIMARY KEY AUTO_INCREMENT,
   	nomeSensor VARCHAR(45),
	tipoInstalacao VARCHAR(45),
		constraint chk_instalacao CHECK (tipoInstalacao IN('geladeira','caminhao')),
	fkLocalSensor INT,
		constraint local_sensor foreign key (fkLocalSensor) references localSensor(idLocal),
	fkEmpresa int,
		constraint fkSensorEmpresa foreign key (fkEmpresa) references localSensor(fkEmpresa)
);

-- Criação da tabela LOTE para registrar os lotes de vacina registrados no nosso site
-- A tabela deve conter uma chave primária, o código do lote registrado e uma variavel INT para ser foreign key
-- O campo IDSensor(int) é uma foreign key que referencia o IDSensor na tabela SENSOR

CREATE TABLE lote (
	idLote int primary key auto_increment,
	descricao varchar(45),
	fkSensor int,
	constraint lotesensor foreign key (fkSensor) references sensor(idSensor)
   );
   
-- Criação da tabela registro para registrar a temperatura atual registrada no sensor
-- No campo DtAtual, este, é configurado como 'datetime default current-timestamp' para capturar o a data e horario exato da captação
CREATE TABLE registro (
	idRegistro INT PRIMARY KEY AUTO_INCREMENT,
	dataHoraRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
	temperatura FLOAT,
	fkSensor int,
		CONSTRAINT registroSensor FOREIGN KEY (fkSensor) REFERENCES sensor(idSensor)
);

-- Inserir dados de empresas na tabela
	INSERT INTO empresa VALUES
		(null,'pfizer','46070868003699','contato@pfizer.com','+5511977424570'),
		(null,'janssen','51780468000187','contato@janssen.com','+5511939479330');
    
-- Inserir dados dos usuarios
	INSERT INTO usuario VALUES
		(null,'Gustavo ribeiro','gustavo.ribeiro@sptech.school','+5511963122168','cpf','53183297809','2005-04-30',1),
		(null,'Vitor Maciel','vitor.mramos@sptech.school','+5511992951528','cpf','53183297809','2000-08-16',2);
    
-- Inserir dados do usuario na tabela login
	insert into login values
		(null, 'gustavo.ribeiro@sptech.school', '#VaccInfo', '1','1'),
		(null, 'vitor.mramos@sptech.school', '#VaccInfo', '0','2');
	
-- Inserir dados de endereço das empresas
	insert into endereco values
		(null, 'rua haddock lobo', 'travessa da avenida paulista', 'Jardins', 'São Paulo', 'SP'),
		(null, 'rua cabral', 'travessa da avenida dom pedro', 'Pindorama', 'Rio de Janeiro', 'RJ');
    
-- Inserir dados do local aonde o sensor está
	insert into localSensor values
		(null,'Geladeira001',1,1),
		(null,'Caminhão001',2,null);

-- Inserir o sensor LM35 tanto na geladeira quanto no Caminhão
	insert into sensor values
		(null, 'LM35', 'geladeira',1,1),
		(null, 'LM35', 'caminhao',2,2);
        
	select * from localSensor;
    
-- Inserir dados sobre um lote
	insert into lote values
		(null, 'VI1', 1),
		(null, 'VI2', 2);
    
-- Inserir dados sobre o registro de temperatuda do sensor
	insert into registro (temperatura, fkSensor) values
		('6', 1),
		('7', 2);

-- Caso hipotético, no qual o lote que estava no caminhão, vá para a geladeira, necessário um update
update lote set fkSensor = 1 where idLote = 2;

-- -- Select dados do sensor
select empresa.nome as 'Nome da Empresa',
	empresa.email as 'Email da empresa',
    localSensor.nome as 'Local do sensor',
    concat('Endereço: ', ifnull(endereco.logradouro,'Não possui rua'), ',  ', ifnull(endereco.complemento, 'Não possui complemento'), ', ', ifnull(endereco.cidade, 'Não possui cidade'), '.' ) as 'Endereço do local',
    sensor.idSensor as 'ID do sensor',
    registro.dataHoraRegistro as 'Momento do registro',
    registro.temperatura as Temperatura
		from localSensor join empresa on localSensor.fkEmpresa = empresa.idEmpresa
        left join endereco on localSensor.fkEndereco = endereco.idEndereco
        join sensor on localSensor.idLocal = sensor.fkLocalSensor
        join registro on sensor.idSensor = registro.fkSensor;
   
-- drop database vaccinfo;
