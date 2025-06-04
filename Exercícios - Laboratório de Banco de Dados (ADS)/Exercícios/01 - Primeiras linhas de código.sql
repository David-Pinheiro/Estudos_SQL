-- EXERCÍCIO 01 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

-- Criação do Banco de Dados
CREATE DATABASE LBD_EX;

-- Definição do uso do Banco de Dados
USE LBD_EX;

-- Criação das tabelas
DROP TABLE IF EXISTS Vendedor;

CREATE TABLE Vendedor(
	cd_Vendedor int NOT NULL,
    nm_Vendedor varchar(40) DEFAULT NULL,
	ds_Endereco varchar(40) DEFAULT NULL,
    cd_CPF decimal(11) DEFAULT NULL,
    nm_Cidade varchar(20) DEFAULT NULL,
    nm_Bairro varchar(20) DEFAULT NULL,
    sg_Estado char(2) DEFAULT NULL,
    cd_Telefone varchar(20) DEFAULT NULL,
    ds_Email varchar(80) DEFAULT NULL
    );

DROP TABLE IF EXISTS Comprador;

CREATE TABLE Comprador(
	cd_Comprador int NOT NULL,
    nm_Comprador varchar(40) DEFAULT NULL,
    ds_Endereco varchar(40) DEFAULT NULL,
    cd_CPF decimal(11) DEFAULT NULL,
    nm_Cidade varchar(20) DEFAULT NULL,
    nm_Bairro varchar(20) DEFAULT NULL,
    sg_Estado varchar(2) DEFAULT NULL,
    cd_Telefone varchar(20) DEFAULT NULL,
    ds_Email varchar(80) DEFAULT NULL
    );
    
DROP TABLE IF EXISTS Imovel;

CREATE TABLE Imovel(
	cd_Imovel int NOT NULL,
    cd_Vendedor int NOT NULL,
    cd_Bairro int NOT NULL,
    cd_Cidade int NOT NULL,
    sg_Estado char(2) NOT NULL,
    ds_Endereco varchar(40) DEFAULT NULL,
    qt_AreaUtil decimal(10,2) DEFAULT NULL,
    qt_AreaTotal decimal(10,2) DEFAULT NULL,
    ds_Imovel varchar(300) DEFAULT NULL,
    vl_preco money DEFAULT NULL,
    qt_Ofertas int DEFAULT NULL,
    ic_Vendido char(1) DEFAULT NULL,
    dt_Lancto date DEFAULT NULL,
    qt_ImovelIndicado int DEFAULT NULL
    );
    
DROP TABLE IF EXISTS Oferta;

CREATE TABLE Oferta(
	cd_Comprador int NOT NULL,
    cd_Imovel int NOT NULL,
    vl_Oferta money  DEFAULT NULL,
    dt_Oferta date DEFAULT NULL
    );

DROP TABLE IF EXISTS Estado;

CREATE TABLE Estado(
	sg_Estado char(2) NOT NULL,
    nm_Estado varchar(20) DEFAULT NULL
    );

DROP TABLE IF EXISTS Cidade;

CREATE TABLE Cidade(
	cd_Cidade int NOT NULL,
    sg_Estado char(2) NOT NULL,
    nm_Cidade varchar(20) DEFAULT NULL
    );

DROP TABLE IF EXISTS Bairro;

CREATE TABLE Bairro(
	cd_Bairro int NOT NULL,
    cd_Cidade int NOT NULL,
    sg_Estado char(2) NOT NULL,
    nm_Bairro varchar(20) DEFAULT NULL
    );

DROP TABLE IF EXISTS Faixa_Imovel;

CREATE TABLE Faixa_Imovel(
	cd_Faixa int NOT NULL,
    nm_Faixa varchar(30) DEFAULT NULL,
    vl_Maximo money DEFAULT NULL,
    vl_Minimo money DEFAULT NULL
    );

-- Criação de chaves primárias
ALTER TABLE Vendedor 
ADD	CONSTRAINT PK_Vendedor 
	Primary Key (cd_Vendedor);

ALTER TABLE Comprador 
ADD CONSTRAINT PK_Comprador
	Primary Key (cd_Comprador);

ALTER TABLE Imovel 
ADD CONSTRAINT PK_Imovel
	Primary Key (cd_Imovel);

ALTER TABLE Oferta 
ADD CONSTRAINT PK_Oferta
	Primary Key (cd_Comprador, cd_Imovel);

ALTER TABLE Estado 
ADD CONSTRAINT PK_Estado
	Primary Key (sg_Estado);

ALTER TABLE Cidade 
ADD CONSTRAINT PK_Cidade
	Primary Key (cd_Cidade, sg_Estado);

ALTER TABLE Bairro 
ADD CONSTRAINT PK_Bairro
	Primary Key (cd_Bairro, cd_Cidade, sg_Estado);

ALTER TABLE Faixa_Imovel 
ADD CONSTRAINT PK_Faixa_Imovel
	Primary Key (cd_Faixa);

-- Criação de chaves secundárias
ALTER TABLE Imovel 
ADD CONSTRAINT FK_Imovel_Vendedor
	FOREIGN KEY (cd_Vendedor) REFERENCES Vendedor (cd_Vendedor);

ALTER TABLE Imovel 
ADD CONSTRAINT FK_Imovel_Bairro
	FOREIGN KEY (cd_Bairro, cd_Cidade, SG_Estado) REFERENCES Bairro (cd_Bairro, cd_Cidade, SG_Estado);

ALTER TABLE Oferta 
ADD CONSTRAINT FK_Oferta_Comprador
	FOREIGN KEY (cd_Comprador) REFERENCES Comprador (cd_Comprador);

ALTER TABLE Oferta 
ADD CONSTRAINT FK_Oferta_Imovel
	FOREIGN KEY (cd_Imovel) REFERENCES Imovel (cd_Imovel);

ALTER TABLE Cidade 
ADD CONSTRAINT FK_Cidade_Estado
	FOREIGN KEY (sg_Estado) REFERENCES Estado (sg_Estado);

ALTER TABLE Bairro 
ADD CONSTRAINT FK_Bairro_Cidade
	FOREIGN KEY (cd_Cidade, sg_Estado) REFERENCES Cidade (cd_Cidade, sg_Estado);