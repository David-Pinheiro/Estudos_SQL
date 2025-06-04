-- DESAFIO 01 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

-- CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE LBD_DES1;

-- DEFINE O USO DO BANCO DE DADOS

USE LBD_DES1;

-- CRIAÇÃO DAS TABELAS

DROP TABLE IF EXISTS Empregado;

CREATE TABLE Empregado(
	cd_Empregado char(8) NOT NULL,
	nm_Empregado char(30) DEFAULT NULL,
	dt_Nascimento date DEFAULT NULL,
	ds_Endereco char(50) DEFAULT NULL,
	nm_Cidade char(20) DEFAULT NULL,
	sg_Estado char(2) DEFAULT NULL,
	cd_Telefone char(11) DEFAULT NULL);

DROP TABLE IF EXISTS Dependente;

CREATE TABLE Dependente(
	cd_Empregado char(8) NOT NULL,
	cd_Dependente int NOT NULL,
	nm_Dependente char(30) DEFAULT NULL,
	dt_Nascimento date DEFAULT NULL,
	cd_Parentesco int NOT NULL);

DROP TABLE IF EXISTS Parentesco;

CREATE TABLE Parentesco(
	cd_Parentesco int NOT NULL,
	nm_Parentesco char(25) DEFAULT NULL);

-- CRIAÇÃO DAS CHAVES PRIMÁRIAS

ALTER TABLE Empregado
ADD CONSTRAINT PK_Empregado
	PRIMARY KEY (cd_Empregado);

ALTER TABLE Dependente
ADD CONSTRAINT PK_Dependente
	PRIMARY KEY (cd_Empregado, cd_Dependente);

ALTER TABLE Parentesco
ADD CONSTRAINT PK_Parentesco
	PRIMARY KEY (cd_Parentesco);

-- CRIAÇÃO DE CHAVES ESTRANGEIRAS

ALTER TABLE Dependente
ADD CONSTRAINT FK_DependenteEmpregado
	FOREIGN KEY (cd_Empregado) REFERENCES Empregado (cd_Empregado);

ALTER TABLE Dependente
ADD CONSTRAINT FK_DependenteParentesco
	FOREIGN KEY (cd_Parentesco) REFERENCES Parentesco (cd_Parentesco);

-- INSERÇÃO DE DADOS

INSERT INTO Empregado
	(cd_Empregado, nm_Empregado, dt_Nascimento, ds_Endereco, nm_Cidade, sg_Estado, cd_Telefone)
VALUES
('emp0001', 'empregado1', '1974-01-01', 'avenida1', 'cidade1', 'SP', '12345678901'),
('emp0002', 'empregado2', '1972-01-01', 'avenida2', 'cidade2', 'MG', '12345678902'),
('emp0003', 'empregado3', '1970-01-01', 'avenida3', 'cidade3', 'SP', '12345678903'),
('emp0004', 'empregado4', '1989-01-01', 'avenida4', 'cidade4', 'MG', '12345678904'),
('emp0005', 'empregado5', '1982-01-01', 'avenida5', 'cidade5', 'SP', '12345678905'),
('emp0006', 'empregado6', '1978-01-01', 'avenida6', 'cidade6', 'MG', '12345678906'),
('emp0007', 'empregado7', '2004-01-01', 'avenida7', 'cidade7', 'SP', '12345678907'),
('emp0008', 'empregado8', '1997-01-01', 'avenida8', 'cidade8', 'MG', '12345678908'),
('emp0009', 'empregado9', '1993-01-01', 'avenida9', 'cidade9', 'SP', '12345678909');
	
INSERT INTO Parentesco 
	(cd_Parentesco, nm_Parentesco)
VALUES
	(99, 'Esposa'),
	(1, 'Filha'),
	(2, 'Filho');

INSERT INTO Dependente
	(cd_Empregado, cd_Dependente, nm_Dependente, dt_Nascimento, cd_Parentesco)
VALUES
('emp0001', 1, 'esposa1', '1977-01-01', 99),
('emp0001', 2, 'filho1', '2010-01-01', 2),
('emp0001', 3, 'filha1', '2006-01-01', 1),
('emp0002', 1, 'esposa2', '1975-01-01', 99),
('emp0002', 2, 'filho2', '2011-01-01', 2),
('emp0002', 3, 'filha2', '2005-01-01', 1),
('emp0003', 1, 'esposa3', '1973-01-01', 99),
('emp0003', 2, 'filho3', '2012-01-01', 2),
('emp0003', 3, 'filha3', '2004-01-01', 1),
('emp0004', 1, 'esposa4', '1989-01-01', 99),
('emp0004', 2, 'filho4', '2015-01-01', 2),
('emp0004', 3, 'filha4', '2012-01-01', 1),
('emp0005', 1, 'esposa5', '1982-01-01', 99),
('emp0005', 2, 'filho5', '2017-01-01', 2),
('emp0005', 3, 'filha5', '2010-01-01', 1),
('emp0006', 1, 'esposa6', '1980-01-01', 99),
('emp0006', 2, 'filho6', '2019-01-01', 2),
('emp0006', 3, 'filha6', '2009-01-01', 1),
('emp0007', 1, 'esposa7', '2004-01-01', 99),
('emp0007', 2, 'filho7', '2021-01-01', 2),
('emp0007', 3, 'filha7', '2019-01-01', 1),
('emp0008', 1, 'esposa8', '1998-01-01', 99),
('emp0008', 2, 'filho8', '2023-01-01', 2),
('emp0008', 3, 'filha8', '2017-01-01', 1),
('emp0009', 1, 'esposa9', '1995-01-01', 99),
('emp0009', 2, 'filho9', '2024-01-01', 2),
('emp0009', 3, 'filha9', '2016-01-01', 1);
	
-- CONSULTAS AO BANCO DE DADOS

-- Consulta 01 (item 4 do desafio)
--Escreva uma query para mostrar empregados e seus dependentes com as seguintes colunas:
--colunas -> nome empregado, data de nascimento do empregado, nome da esposa, nome dos filhos e nome das filhas.

SELECT
	e.nm_Empregado AS 'Nome empregado',
	CONVERT(VARCHAR(10), e.dt_Nascimento, 103) AS 'Data de nascimento do empregado',
	d9.nm_Dependente AS 'Nome da esposa',
	d2.nm_Dependente AS 'Nome dos filhos',
	d1.nm_Dependente AS 'Nome das filhas'
FROM Empregado e
LEFT JOIN Dependente d9 ON e.cd_Empregado = d9.cd_Empregado AND d9.cd_Parentesco = 99
LEFT JOIN Dependente d1 ON e.cd_Empregado = d1.cd_Empregado AND d1.cd_Parentesco = 1
LEFT JOIN Dependente d2 ON e.cd_Empregado = d2.cd_Empregado AND d2.cd_Parentesco = 2
ORDER BY e.nm_Empregado;

-- Consulta 02 (item 5)
--Escreva uma query para mostrar empregados e seus dependentes com as seguintes colunas:
--colunas -> nome empregado, nome da esposa, nome dos filhos, data de nascimento, nome das filhas, data de nascimento

SELECT
	e.nm_Empregado AS 'Nome empregado',
	d9.nm_Dependente AS 'Nome da eposa',
	d2.nm_Dependente AS 'Nome dos filhos',
	CONVERT(VARCHAR(10), d2.dt_Nascimento, 103) AS 'Data de nascimento',
	d1.nm_Dependente AS 'Nome das filhas',
	CONVERT(VARCHAR(10), d1.Dt_Nascimento, 103) AS 'Data de nascimento'
FROM Empregado e
LEFT JOIN Dependente d9 ON e.cd_Empregado = d9.cd_Empregado AND d9.cd_Parentesco = 99
LEFT JOIN Dependente d1 ON e.cd_Empregado = d1.cd_Empregado AND d1.cd_Parentesco = 1
LEFT JOIN Dependente d2 ON e.cd_Empregado = d2.cd_Empregado AND d2.cd_Parentesco = 2
ORDER BY e.nm_Empregado;

-- Consulta 03 (item 6)
--Escreva uma query para mostrar os empregados entre 35 e 49 anos e 
--seus filhos/filhas < de 12 anos com as seguintes colunas:

--colunas -> nome empregado, data nascimento empregado, nome do filho, 
--data de nascimento do filho, nome da filha, data nascimento da filha.

SELECT
	e.nm_Empregado AS 'Nome empregado',
	CONVERT(VARCHAR(10), e.dt_Nascimento, 103) AS 'Data nascimento empregado',
	d2.nm_Dependente AS 'Nome do filho',
	CONVERT(VARCHAR(10), d2.dt_Nascimento, 103) AS 'Data de nascimento do filho',
	d1.nm_Dependente AS 'Nome da filha',
	CONVERT(VARCHAR(10), d1.dt_Nascimento, 103) AS 'Data de nascimento da filha'
FROM Empregado e
LEFT JOIN Dependente d1 
	ON e.cd_Empregado = d1.cd_Empregado 
	AND d1.cd_Parentesco = 1
	AND d1.dt_Nascimento <= DATEADD(YEAR, -12, GETDATE())
LEFT JOIN Dependente d2 
	ON e.cd_Empregado = d2.cd_Empregado 
	AND d2.cd_Parentesco = 2
	AND d2.dt_Nascimento <= DATEADD(YEAR, -12, GETDATE())
WHERE e.dt_Nascimento BETWEEN 
	DATEADD(YEAR, -49, GETDATE()) AND
	DATEADD(YEAR, -35, GETDATE())
ORDER BY e.nm_Empregado;

-- Consulta 04 (item 7)
--Escreva uma query para mostrar os empregados com as esposas entre 20 e 32 anos e 
--seus filhos/filhas > 5 anos numa tabela com as seguintes colunas:

--colunas -> nome empregado, nome esposa, data nascimento esposa, nome do filho, data de nascimento do filho, 
--nome da filha, data nascimento da filha.

SELECT
	e.nm_Empregado AS 'Nome empregado',
	d9.nm_Dependente AS 'Nome esposa',
	CONVERT(VARCHAR(10), d9.dt_Nascimento, 103) AS 'Data nascimento esposa',
	d2.nm_Dependente AS 'Nome do filho',
	CONVERT(VARCHAR(10), d2.dt_Nascimento, 103) AS 'Data de nascimento do filho',
	d1.nm_Dependente AS 'Nome da filha',
	CONVERT(VARCHAR(10), d1.dt_Nascimento, 103) AS 'Data de nascimento da filha'
FROM Empregado e
INNER JOIN Dependente d9 
	ON e.cd_Empregado = d9.cd_Empregado 
	AND d9.cd_Parentesco = 99
	AND d9.dt_Nascimento BETWEEN
		DATEADD(YEAR, -32, GETDATE()) AND
		DATEADD(YEAR, -20, GETDATE())
LEFT JOIN Dependente d1 
	ON e.cd_Empregado = d1.cd_Empregado 
	AND d1.cd_Parentesco = 1
	AND d1.dt_Nascimento > DATEADD(YEAR, -5, GETDATE())
LEFT JOIN Dependente d2 
	ON e.cd_Empregado = d2.cd_Empregado 
	AND d2.cd_Parentesco = 2
	AND d2.dt_Nascimento > DATEADD(YEAR, -5, GETDATE())
ORDER BY e.nm_Empregado;

-- Consulta 05 (item 8)
--Escreva uma query para mostrar os empregados com as esposas > 47 anos e 
--seus filhos/ filhas > 17 numa tabela com as seguintes colunas:

--colunas -> nome empregado, nome esposa, data nascimento esposa, nome do filho, 
--data de nascimento do filho, nome da filha, data nascimento da filha.

SELECT
	e.nm_Empregado AS 'Nome empregado',
	d9.nm_Dependente AS 'Nome esposa',
	CONVERT(VARCHAR(10), d9.dt_Nascimento, 103) AS 'Data nascimento esposa',
	d2.nm_Dependente AS 'Nome do filho',
	CONVERT(VARCHAR(10), d2.dt_Nascimento, 103) AS 'Data de nascimento do filho',
	d1.nm_Dependente AS 'Nome da filha',
	CONVERT(VARCHAR(10), d1.dt_Nascimento, 103) AS 'Data de nascimento da filha'
FROM Empregado e
INNER JOIN Dependente d9 
	ON e.cd_Empregado = d9.cd_Empregado 
	AND d9.cd_Parentesco = 99
	AND d9.dt_Nascimento <= DATEADD(YEAR, -47, GETDATE())
LEFT JOIN Dependente d1 
	ON e.cd_Empregado = d1.cd_Empregado 
	AND d1.cd_Parentesco = 1
	AND d1.dt_Nascimento <= DATEADD(YEAR, -17, GETDATE())
LEFT JOIN Dependente d2 
	ON e.cd_Empregado = d2.cd_Empregado 
	AND d2.cd_Parentesco = 2
	AND d2.dt_Nascimento <= DATEADD(YEAR, -17, GETDATE())
ORDER BY e.nm_Empregado;

-- Consulta 06 (item 9)
--Escreva uma query para mostras os filhos que moram no estado de ‘SP’ com as seguintes colunas:

--colunas -> nome empregado, nome da esposa, nome do filho e data de nascimento do filho, 
--nome da filha, data de nascimento da filha e estado

SELECT
	e.nm_Empregado AS 'Nome empregado',
	d9.nm_Dependente AS 'Nome esposa',
	d2.nm_Dependente AS 'Nome do filho',
	CONVERT(VARCHAR(10), d2.dt_Nascimento, 103) AS 'Data de nascimento do filho',
	d1.nm_Dependente AS 'Nome da filha',
	CONVERT(VARCHAR(10), d1.dt_Nascimento, 103) AS 'Data de nascimento da filha',
	e.sg_Estado AS 'Estado'
FROM Empregado e
LEFT JOIN Dependente d9 
	ON e.cd_Empregado = d9.cd_Empregado AND d9.cd_Parentesco = 99
LEFT JOIN Dependente d1 
	ON e.cd_Empregado = d1.cd_Empregado AND d1.cd_Parentesco = 1
LEFT JOIN Dependente d2 
	ON e.cd_Empregado = d2.cd_Empregado AND d2.cd_Parentesco = 2
WHERE e.sg_Estado LIKE 'SP'
ORDER BY e.nm_Empregado;

-- Consulta 07 (item 10)
--Escreva uma query para mostrar as cidades do estado de ‘MG’ com as seguintes colunas:
--colunas -> nome empregado, nome da esposa, nome do filho, data de nascimento do filho nome da filha, data de nascimento da filha e cidade.

SELECT
	e.nm_Empregado AS 'Nome empregado',
	d9.nm_Dependente AS 'Nome esposa',
	d2.nm_Dependente AS 'Nome do filho',
	CONVERT(VARCHAR(10), d2.dt_Nascimento, 103) AS 'Data de nascimento do filho',
	d1.nm_Dependente AS 'Nome da filha',
	CONVERT(VARCHAR(10), d1.dt_Nascimento, 103) AS 'Data de nascimento da filha',
	e.nm_Cidade AS 'Cidade'
FROM Empregado e
LEFT JOIN Dependente d9 
	ON e.cd_Empregado = d9.cd_Empregado AND d9.cd_Parentesco = 99
LEFT JOIN Dependente d1 
	ON e.cd_Empregado = d1.cd_Empregado AND d1.cd_Parentesco = 1
LEFT JOIN Dependente d2 
	ON e.cd_Empregado = d2.cd_Empregado AND d2.cd_Parentesco = 2
WHERE e.sg_Estado LIKE 'MG'
ORDER BY e.nm_Empregado;