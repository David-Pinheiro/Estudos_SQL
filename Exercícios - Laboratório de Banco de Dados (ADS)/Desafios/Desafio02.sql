-- DESAFIO 02 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

-- CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE TR_aluno
GO

-- DEFINE O USO DO BANCO

Use TR_aluno
GO

-- CRIAÇÃO DAS TABELAS

CREATE TABLE Empregado 
 (Empr_cd_Empregado Char(8) NOT NULL, 
 Empr_nm_Empregado Char(30), 
 Empr_dt_Nascimento Date,
 Empr_ds_Endereco Char(50), 
 Empr_nm_Cidade Char(20), 
 Empr_nm_Estado char(2),
 Empr_nm_Telefone char(11)); 

 CREATE TABLE Dependente 
 (Empr_cd_Empregado Char(8) NOT NULL, 
 Depe_cd_Dependente Integer NOT NULL, 
 Depe_nm_Dependente Char(30), 
 Depe_dt_Nascimento Date,
 Pare_cd_Parentesco Integer); 
 
 CREATE TABLE Parentesco 
 (Pare_cd_Parentesco Integer NOT NULL, 
 Pare_ds_Parentesco char(25));

 -- CRIAÇÃO DAS CHAVES PRIMÁRIAS

ALTER TABLE empregado
ADD CONSTRAINT PK_Empregado
	PRIMARY KEY (empr_cd_empregado);

ALTER TABLE dependente
ADD CONSTRAINT PK_Dependente
	PRIMARY KEY (empr_cd_empregado,depe_cd_dependente);

ALTER TABLE parentesco
ADD CONSTRAINT PK_Parentesco
	PRIMARY KEY (pare_cd_parentesco);

-- CRIAÇÃO DAS CHAVES ESTRANGEIRAS

ALTER TABLE dependente
ADD CONSTRAINT FK_Dependente_Empregado
	FOREIGN KEY (empr_cd_empregado) references empregado (empr_cd_empregado);

ALTER TABLE dependente
ADD CONSTRAINT FK_Dependente_Parentesco
	FOREIGN KEY (pare_cd_parentesco) references parentesco (pare_cd_parentesco);

-- INSERÇÃO DE DADOS

INSERT INTO parentesco VALUES (99, 'Esposa');
INSERT INTO parentesco VALUES (1, 'Filho');
INSERT INTO parentesco VALUES (2, 'Filha');

INSERT INTO empregado VALUES (1,'Empregado 1','1966-01-01','Rua 1','Cidade 1','sp','33642735');
INSERT INTO empregado VALUES (2,'Empregado 2','1966-01-01','Rua 2','Cidade 2','rj','33257896');
INSERT INTO empregado VALUES (3,'Empregado 3','1966-01-01','Rua 3','Cidade 3','sp','33754127');

INSERT INTO empregado VALUES (4,'Empregado 4','1976-01-01','Rua 4','Cidade 4','rj','33675896');
INSERT INTO empregado VALUES (5,'Empregado 5','1976-01-01','Rua 5','Cidade 5','sp','33641258');
INSERT INTO empregado VALUES (6,'Empregado 6','1976-01-01','Rua 6','Cidade 6','rj','33634185');

INSERT INTO empregado VALUES (7,'Empregado 7','1991-01-01','Rua 7','Cidade 7','sp','33675896');
INSERT INTO empregado VALUES (8,'Empregado 8','1991-01-01','Rua 8','Cidade 8','rj','33641258');
INSERT INTO empregado VALUES (9,'Empregado 9','1991-01-01','Rua 9','Cidade 9','sp','33634185');

INSERT INTO dependente VALUES (1,1,'Filho 1','2007-01-01',1);
INSERT INTO dependente VALUES (1,2,'Filha 1','2002-01-01',2);
INSERT INTO dependente VALUES (1,3,'Esposa 1','1971-01-01',99);

INSERT INTO dependente VALUES (2,1,'Filho 2','2007-01-01',1);
INSERT INTO dependente VALUES (2,2,'Filha 2','2002-01-01',2);
INSERT INTO dependente VALUES (2,3,'Esposa 2','1971-01-01',99);

INSERT INTO dependente VALUES (3,1,'Filho 3','2007-01-01',1);
INSERT INTO dependente VALUES (3,2,'Filha 3','2002-01-01',2);
INSERT INTO dependente VALUES (3,3,'Esposa 3','1971-01-01',99);

INSERT INTO dependente VALUES (4,1,'Filho 4','2012-01-01',1);
INSERT INTO dependente VALUES (4,2,'Filha 4','2008-01-01',2);
INSERT INTO dependente VALUES (4,3,'Esposa 4','1980-01-01',99);

INSERT INTO dependente VALUES (5,1,'Filho 5','2012-01-01',1);
INSERT INTO dependente VALUES (5,2,'Filha 5','2008-01-01',2);
INSERT INTO dependente VALUES (5,3,'Esposa 5','1980-01-01',99);

INSERT INTO dependente VALUES (6,1,'Filho 6','2012-01-01',1);
INSERT INTO dependente VALUES (6,2,'Filha 6','2008-01-01',2);
INSERT INTO dependente VALUES (6,3,'Esposa 6','1980-01-01',99);

INSERT INTO dependente VALUES (7,1,'Filho 7','2018-01-01',1);
INSERT INTO dependente VALUES (7,2,'Filha 7','2014-01-01',2);
INSERT INTO dependente VALUES (7,3,'Esposa 7','1998-01-01',99);

INSERT INTO dependente VALUES (8,1,'Filho 8','2018-01-01',1);
INSERT INTO dependente VALUES (8,2,'Filha 8','2014-01-01',2);
INSERT INTO dependente VALUES (8,3,'Esposa 8','1998-01-01',99);

INSERT INTO dependente VALUES (9,1,'Filho 9','2018-01-01',1);
INSERT INTO dependente VALUES (9,2,'Filha 9','2014-01-01',2);
INSERT INTO dependente VALUES (9,3,'Esposa 9','1998-01-01',99);

-- CONSULTAS

--1 - Escreva uma query para mostrar a mãe com idade > 50 anos e 
--seus filhos/filhas com idade > 17 anos.
--colunas -> nome e data nascimento esposa, nome e data nascimento filho, 
--nome e data nascimento filha e cidade

SELECT
	es.Depe_nm_Dependente								AS 'Nome da esposa',
	CONVERT(VARCHAR(10), es.Depe_dt_Nascimento, 103)	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente								AS 'Nome do filho',
	CONVERT(VARCHAR(10), fo.Depe_dt_Nascimento, 103)	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente								AS 'Nome da filha',
	CONVERT(VARCHAR(10), fa.Depe_dt_Nascimento, 103)	AS 'Data de nascimento da filha', 
	e.Empr_nm_Cidade									AS 'Cidade'
FROM Empregado e
LEFT JOIN Dependente es ON e.Empr_cd_Empregado = es.Empr_cd_Empregado AND es.Pare_cd_Parentesco = 99
LEFT JOIN Dependente fo ON e.Empr_cd_Empregado = fo.Empr_cd_Empregado AND fo.Pare_cd_Parentesco = 1
LEFT JOIN Dependente fa ON e.Empr_cd_Empregado = fa.Empr_cd_Empregado AND fa.Pare_cd_Parentesco = 2
WHERE es.Depe_dt_Nascimento <= DATEADD(YEAR, -50, GETDATE())
	AND fo.Depe_dt_Nascimento <= DATEADD(YEAR, -17, GETDATE())
	AND fa.Depe_dt_Nascimento <= DATEADD(YEAR, -17, GETDATE())
GO

--2 - Escreva uma query para mostrar a mãe com idade de 20 a 34 anos e 
--seus filhos/filhas com idade < 5 anos.

--colunas -> nome e data nascimento esposa, nome e data nascimento filho, 
--nome e data nascimento filha e endereço

SELECT
	es.Depe_nm_Dependente								AS 'Nome da esposa',
	CONVERT(VARCHAR(10), es.Depe_dt_Nascimento, 103)	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente								AS 'Nome do filho',
	CONVERT(VARCHAR(10), fo.Depe_dt_Nascimento, 103)	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente								AS 'Nome da filha',
	CONVERT(VARCHAR(10), fa.Depe_dt_Nascimento, 103)	AS 'Data de nascimento da filha', 
	e.Empr_ds_Endereco									AS 'Endereço'
FROM Empregado e
LEFT JOIN Dependente es ON e.Empr_cd_Empregado = es.Empr_cd_Empregado AND es.Pare_cd_Parentesco = 99
LEFT JOIN Dependente fo ON e.Empr_cd_Empregado = fo.Empr_cd_Empregado AND fo.Pare_cd_Parentesco = 1
LEFT JOIN Dependente fa ON e.Empr_cd_Empregado = fa.Empr_cd_Empregado AND fa.Pare_cd_Parentesco = 2
WHERE es.Depe_dt_Nascimento BETWEEN 
		DATEADD(YEAR, -34, GETDATE()) AND
		DATEADD(YEAR, -20, GETDATE())
	AND fo.Depe_dt_Nascimento > DATEADD(YEAR, -5, GETDATE())
	AND fa.Depe_dt_Nascimento > DATEADD(YEAR, -5, GETDATE())
GO

--3 – Escreva uma query para mostrar a mãe com idade de 35 a 49 anos, esposas e 
--seus filhos/filhas < de 12 anos.

--colunas -> nome e data nascimento esposa, nome e data de nascimento filho, 
--nome e data nascimento filha e o estado.

SELECT
	es.Depe_nm_Dependente								AS 'Nome da esposa',
	CONVERT(VARCHAR(10), es.Depe_dt_Nascimento, 103)	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente								AS 'Nome do filho',
	CONVERT(VARCHAR(10), fo.Depe_dt_Nascimento, 103)	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente								AS 'Nome da filha',
	CONVERT(VARCHAR(10), fa.Depe_dt_Nascimento, 103)	AS 'Data de nascimento da filha', 
	e.Empr_nm_Estado									AS 'Estado'
FROM Empregado e
LEFT JOIN Dependente es ON e.Empr_cd_Empregado = es.Empr_cd_Empregado AND es.Pare_cd_Parentesco = 99
LEFT JOIN Dependente fo ON e.Empr_cd_Empregado = fo.Empr_cd_Empregado AND fo.Pare_cd_Parentesco = 1
LEFT JOIN Dependente fa ON e.Empr_cd_Empregado = fa.Empr_cd_Empregado AND fa.Pare_cd_Parentesco = 2
WHERE es.Depe_dt_Nascimento BETWEEN 
		DATEADD(YEAR, -49, GETDATE()) AND
		DATEADD(YEAR, -35, GETDATE())
	AND fo.Depe_dt_Nascimento > DATEADD(YEAR, -12, GETDATE())
	AND fa.Depe_dt_Nascimento > DATEADD(YEAR, -12, GETDATE())
GO

--4 - Escreva uma query para mostrar o empregado, esposa com idade de 35 a 49 anos e 
--seus filhos/filhas com idade > 12 anos.

--colunas -> nome e data nascimento empregado, nome e data de nascimento da esposa, 
--nome e data nascimento filho, nome e data nascimento filha e código do empregado

SELECT
	e.Empr_nm_Empregado									AS 'Nome do empregado',
	CONVERT(VARCHAR(10), e.Empr_dt_Nascimento, 103)		AS 'Data de nascimento do empregado',
	es.Depe_nm_Dependente								AS 'Nome da esposa',
	CONVERT(VARCHAR(10), es.Depe_dt_Nascimento, 103)	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente								AS 'Nome do filho',
	CONVERT(VARCHAR(10), fo.Depe_dt_Nascimento, 103)	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente								AS 'Nome da filha',
	CONVERT(VARCHAR(10), fa.Depe_dt_Nascimento, 103)	AS 'Data de nascimento da filha', 
	e.Empr_cd_Empregado									AS 'Código do empregado'
FROM Empregado e
LEFT JOIN Dependente es ON e.Empr_cd_Empregado = es.Empr_cd_Empregado AND es.Pare_cd_Parentesco = 99
LEFT JOIN Dependente fo ON e.Empr_cd_Empregado = fo.Empr_cd_Empregado AND fo.Pare_cd_Parentesco = 1
LEFT JOIN Dependente fa ON e.Empr_cd_Empregado = fa.Empr_cd_Empregado AND fa.Pare_cd_Parentesco = 2
WHERE es.Depe_dt_Nascimento BETWEEN
		DATEADD(YEAR, -49, GETDATE()) AND
		DATEADD(YEAR, -35, GETDATE())
	AND fo.Depe_dt_Nascimento <= DATEADD(YEAR, -12, GETDATE())
	AND fa.Depe_dt_Nascimento <= DATEADD(YEAR, -12, GETDATE())
GO

--5 - Escreva uma query para mostrar o empregado com idade > 50 anos, esposa e 
--seus filhos/filhas com idade < 17 anos.

--colunas -> nome e data nascimento empregado, nome e data de nascimento da esposa, 
--nome e data nascimento filho, nome e data nascimento filha e cidade 

SELECT
	e.Empr_nm_Empregado									AS 'Nome do empregado',
	CONVERT(VARCHAR(10), e.Empr_dt_Nascimento, 103)		AS 'Data de nascimento do empregado',
	es.Depe_nm_Dependente								AS 'Nome da esposa',
	CONVERT(VARCHAR(10), es.Depe_dt_Nascimento, 103)	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente								AS 'Nome do filho',
	CONVERT(VARCHAR(10), fo.Depe_dt_Nascimento, 103)	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente								AS 'Nome da filha',
	CONVERT(VARCHAR(10), fa.Depe_dt_Nascimento, 103)	AS 'Data de nascimento da filha', 
	e.Empr_nm_Cidade									AS 'Cidade'
FROM Empregado e
LEFT JOIN Dependente es ON e.Empr_cd_Empregado = es.Empr_cd_Empregado AND es.Pare_cd_Parentesco = 99
LEFT JOIN Dependente fo ON e.Empr_cd_Empregado = fo.Empr_cd_Empregado AND fo.Pare_cd_Parentesco = 1
LEFT JOIN Dependente fa ON e.Empr_cd_Empregado = fa.Empr_cd_Empregado AND fa.Pare_cd_Parentesco = 2
WHERE e.Empr_dt_Nascimento <= DATEADD(YEAR, -50, GETDATE())
	AND fo.Depe_dt_Nascimento > DATEADD(YEAR, -17, GETDATE())
	AND fa.Depe_dt_Nascimento > DATEADD(YEAR, -17, GETDATE())
GO

--6 – Escreva uma query para mostrar os empregados com idade de 20 a 34 anos, 
--esposas e os filhos/filhas > de 5 anos.

--colunas -> nome empregado, nome e data nascimento esposa, nome e data nascimento filhos, 
--nome e data nascimento filha.

SELECT
	e.Empr_nm_Empregado									AS 'Nome do empregado',
	CONVERT(VARCHAR(10), e.Empr_dt_Nascimento, 103)		AS 'Data de nascimento do empregado',
	es.Depe_nm_Dependente								AS 'Nome da esposa',
	CONVERT(VARCHAR(10), es.Depe_dt_Nascimento, 103)	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente								AS 'Nome do filho',
	CONVERT(VARCHAR(10), fo.Depe_dt_Nascimento, 103)	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente								AS 'Nome da filha',
	CONVERT(VARCHAR(10), fa.Depe_dt_Nascimento, 103)	AS 'Data de nascimento da filha', 
	e.Empr_nm_Cidade									AS 'Cidade'
FROM Empregado e
LEFT JOIN Dependente es ON e.Empr_cd_Empregado = es.Empr_cd_Empregado AND es.Pare_cd_Parentesco = 99
LEFT JOIN Dependente fo ON e.Empr_cd_Empregado = fo.Empr_cd_Empregado AND fo.Pare_cd_Parentesco = 1
LEFT JOIN Dependente fa ON e.Empr_cd_Empregado = fa.Empr_cd_Empregado AND fa.Pare_cd_Parentesco = 2
WHERE e.Empr_dt_Nascimento BETWEEN
		DATEADD(YEAR, -34, GETDATE()) AND
		DATEADD(YEAR, -20, GETDATE())
	AND fo.Depe_dt_Nascimento <= DATEADD(YEAR, -5, GETDATE())
	AND fa.Depe_dt_Nascimento <= DATEADD(YEAR, -5, GETDATE())
GO

-- PROCEDURES

--7 – na tabela de empregados altere o ano para 1992,1987,1982,1977,1972,1967,1962, 1957, 1952 
--mantendo o dia e mês original.

CREATE PROCEDURE AlterarAnos_tabEmpregado
-- Anos recebidos via parâmetro

@ano1 INT, @ano2 INT, @ano3 INT,
@ano4 INT, @ano5 INT, @ano6 INT,
@ano7 INT, @ano8 INT, @ano9 INT

AS
BEGIN
	DECLARE @tab_Provisoria TABLE (cd INT identity, ano INT); 

	-- Tabela temporária para receber os anos informados

	INSERT INTO @tab_Provisoria (ano)
	VALUES	(@ano1),(@ano2),(@ano3),
			(@ano4),(@ano5),(@ano6),
			(@ano7),(@ano8),(@ano9);

	-- Referenciando a tabela provisória, atualiza o ano de nascimento para os anos informados
	-- DATEFROMPARTS: permite a atualização de um campo DATE, separando por ano, mês e dia
	-- O ano é alterado para informado, enquanto mês e dia permanecem na mesma data.

	UPDATE e
	SET e.Empr_dt_Nascimento = DATEFROMPARTS(
		t.ano, 
		MONTH(e.Empr_dt_Nascimento), 
		DAY(e.Empr_dt_Nascimento))
	FROM Empregado e INNER JOIN @tab_Provisoria t ON e.Empr_cd_Empregado = t.cd

	PRINT('Atualização finalizada');
END
GO

EXEC AlterarAnos_tabEmpregado 1992,1987,1982,1977,1972,1967,1962, 1957, 1952;
GO

-- UMA PROCEDURE FOI CRIADA PARA OS ÚLTIMOS TRÊS EXERCÍCIOS

CREATE PROCEDURE AlterarAnos_tabDependente
-- Recebido como parâmetro o código do dependente cujos dados serão alterados
-- Anos também recebidos via parâmetro

@cd_dependente INT,
@ano1 INT, @ano2 INT, @ano3 INT,
@ano4 INT, @ano5 INT, @ano6 INT,
@ano7 INT, @ano8 INT, @ano9 INT

AS
BEGIN
	-- O IF verifica se foi passado como parâmetro um valor válido como código do dependente

	-- Com a subconsulta, a PROCEDURE continuará funcionando mesmo se novos tipos
	-- de dependente forem adiconados à tabela
	
	IF @cd_dependente NOT IN (SELECT DISTINCT Pare_cd_Parentesco FROM Parentesco)
	BEGIN
		DECLARE @parentescos VARCHAR(100)
		DECLARE @mensagem VARCHAR(200)

		-- STRING_AGG: organiza os dados na mesma linha, separada por '-'
		-- CONCAT_WS: concatena os dados das colunas Pare_cd_Parentesco e Pare_ds_Parentesco, separadas por ', '
		-- RTRIM: elimina os espaços em branco de Pare_ds_Parentesco, por se tratar de CHAR(25)

		SELECT @parentescos= STRING_AGG(CONCAT_WS('-', RTRIM(Pare_cd_Parentesco), RTRIM(Pare_ds_Parentesco)), ', ')
		FROM Parentesco;

		-- Atribui todas as informações à variável @mensagem, para exibição no RAISERROR

		SET @mensagem = 'Código de dependente inválido. Valores válidos: ' + @parentescos
		
		RAISERROR(@mensagem, 16, 1);
	END

	ELSE
	BEGIN

	-- Criada uma tabela provisória para guardar os anos

	DECLARE @tab_Provisoria TABLE (cd INT identity, ano INT);

	INSERT INTO @tab_Provisoria (ano)
	VALUES	(@ano1),(@ano2),(@ano3),
			(@ano4),(@ano5),(@ano6),
			(@ano7),(@ano8),(@ano9);

	-- Referenciando a tabela provisória, atualiza o ano de nascimento para os anos informados
	-- DATEFROMPARTS: permite a atualização de um campo DATE, separando por ano, mês e dia
	-- O ano é alterado para informado, enquanto mês e dia permanecem na mesma data.

	UPDATE d
	SET d.Depe_dt_Nascimento = DATEFROMPARTS(
		t.ano,
		MONTH(d.Depe_dt_Nascimento), 
		DAY(d.Depe_dt_Nascimento))
	FROM Dependente d INNER JOIN @tab_Provisoria t ON d.Empr_cd_Empregado = t.cd
	WHERE d.Pare_cd_Parentesco = @cd_dependente;

	PRINT('Atualização finalidade');

	END
END
GO

--8 – na tabela de dependentes altere o ano das esposas para 
--1953,1956,1959,1973,1976,1979,1983,1986,1989 mantendo o dia e mês original.

EXEC AlterarAnos_tabDependente 99, 1953, 1956, 1959, 1973, 1976, 1979, 1983, 1986, 1989;
GO

--9 - na tabela de dependentes altere o ano dos filhos homens para 
--1993, 1993, 1993, 1995, 1995, 1995, 1997, 1997, 1997 mantendo o dia e mês original

EXEC AlterarAnos_tabDependente 1, 1993, 1993, 1993, 1995, 1995, 1995, 1997, 1997, 1997;
GO

--10 - na tabela de dependentes altere o ano das filhas mulheres para 
--2010, 2010, 2010, 2012, 2012, 2012, 2016, 2016, 2016 mantendo o dia e mês original

EXEC AlterarAnos_tabDependente 2, 2010, 2010, 2010, 2012, 2012, 2012, 2016, 2016, 2016;
GO