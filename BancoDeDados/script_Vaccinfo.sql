CREATE DATABASE Vaccinfo;
USE Vaccinfo;

CREATE TABLE empresa (
	idEmpresa INT primary key auto_increment,
    nome VARCHAR(45),
    CNPJ CHAR(14),
    email VARCHAR(45),
		constraint chk_email check (email like'%@%'),
	telefone VARCHAR(16)
);


CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
	nomeCompleto VARCHAR(45) not null,
    email VARCHAR(45),
		constraint chk_email_user check (email like'%@%'),
    telefone CHAR(14),
    tipoDocumento VARCHAR(10),
		constraint chk_tipo_documento check (tipoDocumento in('cpf', 'passaporte')),
    documento VARCHAR(45),
    dataNascimento DATE,
	senha VARCHAR(45),
    administrador TINYINT,
		constraint chk_administrador check (administrador in(0,1)),
    fkEmpresa INT,
		constraint usuarioEmpresa foreign key (fkEmpresa) references Empresa(idEmpresa)
);

CREATE TABLE endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(45),
    complemento VARCHAR(45),
    bairro VARCHAR(45),
    cidade VARCHAR(45),
    estado CHAR(2)
);

CREATE TABLE sensor (
	idSensor int PRIMARY KEY AUTO_INCREMENT,
   	nomeSensor VARCHAR(45)
);

create table localSensor(
	idLocal int auto_increment,
	nome varchar(45),
	tipolocal VARCHAR(45),
		constraint chk_instalacao CHECK (tipolocal IN('geladeira','caminhao')),
	fkEmpresa int,
		constraint fkLocalEmpresa foreign key (fkEmpresa) references empresa(idEmpresa),
		constraint pkLocal primary key (idLocal, fkEmpresa),
	fkEndereco int,
		constraint fkLocalEndereco foreign key (fkEndereco) references endereco(idEndereco),
	fkSensor int,
		constraint fkSensor foreign key (fkSensor) references sensor(idSensor)
);

CREATE TABLE lote (
	idLote int primary key auto_increment,
	descricao varchar(45),
	fkLocal int,
		constraint loteLocal foreign key (fkLocal) references LocalSensor(idLocal),
	fkEmpresa int,
		constraint loteEmpresa foreign key (fkEmpresa) references Empresa(idEmpresa)
);

CREATE TABLE registro (
	idRegistro INT PRIMARY KEY AUTO_INCREMENT,
	dataHoraRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
	temperatura FLOAT,
	fkLocal int,
		CONSTRAINT registroLocal FOREIGN KEY (fkLocal) REFERENCES LocalSensor(idLocal),
	fkEmpresa int,
		CONSTRAINT fkEmpresa foreign key (fkEmpresa) references empresa(idEmpresa)
);

-- Inserir dados de empresas na tabela
	INSERT INTO empresa VALUES
		(null,'pfizer','46070868003699','contato@pfizer.com','+5511977424570'),
		(null,'janssen','51780468000187','contato@janssen.com','+5511939479330');
    
-- Inserir dados de endereço das empresas
	insert into endereco values
		(null, 'rua haddock lobo', 'travessa da avenida paulista', 'Jardins', 'São Paulo', 'SP'),
		(null, 'rua cabral', 'travessa da avenida dom pedro', 'Pindorama', 'Rio de Janeiro', 'RJ');

-- Inserir dados dos usuarios
	INSERT INTO usuario VALUES
		(null,'Gustavo ribeiro','gustavo.ribeiro@sptech.school','+5511963122168','cpf','53183297809','2005-04-30', '#Vaccinfo', 1, 1),
		(null,'Vitor Maciel','vitor.mramos@sptech.school','+5511992951528','cpf','53183297809','2000-08-16', '#Vaccinfo', 1, 2);

-- Inserir o sensor LM35 tanto na geladeira quanto no Caminhão
	insert into sensor values
		(null, 'LM35'),
		(null, 'LM35');
    
-- Inserir dados do local aonde o sensor está
	insert into localSensor values
		(null,'Geladeira001', 'geladeira', 1, 1, 1),
		(null,'Caminhão001', 'caminhao', 1, null, 2);

select * from registro;
    
-- Inserir dados sobre um lote
	insert into lote values
		(null, 'VI1', 1, 1),
		(null, 'VI2', 2, 1);
    
-- Inserir dados sobre o registro de temperatuda do sensor
	insert into registro (temperatura, fkLocal) values
		(6, 1),
		(7, 2);

-- Caso hipotético, no qual o lote que estava no caminhão, vá para a geladeira, necessário um update
	update lote set fkLocal = 1 where idLote = 2;

-- -- Select dados do sensor
select empresa.nome as 'Nome da Empresa',
	empresa.email as 'Email da empresa',
    localSensor.nome as 'Local do sensor',
    concat('Endereço: ', ifnull(endereco.logradouro,'Não possui rua. '), ', ', ifnull(endereco.complemento, 'Não possui complemento. '), ', ', ifnull(endereco.cidade, 'Não possui cidade. '), '.' ) as 'Endereço do local',
    sensor.idSensor as 'ID do sensor',
    registro.dataHoraRegistro as 'Momento do registro',
    registro.temperatura as Temperatura
		from localSensor join empresa on localSensor.fkEmpresa = empresa.idEmpresa
        join endereco on localSensor.fkEndereco = endereco.idEndereco
        join sensor on localSensor.idLocal = sensor.fkLocalSensor
        join registro on localSensor.idLocal = registro.fkLocal;
        
-- possível select para o gráfico de dias da semana (testar)
SELECT fkLocal, 
		DATE(dataHoraRegistro) AS dataRegistro,
        temperatura AS temperatura
FROM registro
	WHERE DAYOFWEEK(dataHoraRegistro) = 4 -- número do dia da semana
	AND temperatura < 7
	GROUP BY fkLocal, dataRegistro;
    
SELECT 
    CASE
        WHEN temperatura > 7 OR temperatura < 2 THEN 'Crítico'
        WHEN temperatura > 4.4 AND temperatura < 6.6 THEN 'Ideal'
        WHEN temperatura > 2.2 AND temperatura < 4.4 THEN 'Alerta'
        ELSE 'Outro'
    END AS status,
    DAYNAME(dataHoraRegistro) AS dia_semana,
    fkLocal
FROM
    registro
WHERE
    YEARWEEK(dataHoraRegistro) = YEARWEEK(CURDATE())
    group by fkLocal, dia_semana;