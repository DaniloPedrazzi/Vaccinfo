-- DROP database VACCINFO;
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
    dataNascimento VARCHAR(45),
	senha VARCHAR(45)
);

select * from usuario;