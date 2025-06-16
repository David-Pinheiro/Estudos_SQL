-- Desenvolvido em SQL Server
-- DESAFIO 02 - LABORATÓRIO DE BANCO DE DADOS

-- CRIAÇÃO DO BANCO DE DADOS

Create database TR_aluno
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

alter table empregado
add CONSTRAINT PK_Empregado
	primary key (empr_cd_empregado);

alter table dependente
add CONSTRAINT PK_Dependente
	primary key (empr_cd_empregado,depe_cd_dependente);

alter table parentesco
add CONSTRAINT PK_Parentesco
primary key (pare_cd_parentesco);

-- CRIAÇÃO DAS CHAVES ESTRANGEIRAS

alter table dependente
add CONSTRAINT FK_Dependente_Empregado
	foreign key (empr_cd_empregado) references empregado (empr_cd_empregado);

alter table dependente
add CONSTRAINT FK_Dependente_Parentesco
foreign key (pare_cd_parentesco) references parentesco (pare_cd_parentesco);

-- INSERÇÃO DE DADOS

insert into parentesco values (99, 'Esposa');
insert into parentesco values (1, 'Filho');
insert into parentesco values (2, 'Filha');

insert into empregado values (1,'Empregado 1','1966-01-01','Rua 1','Cidade 1','sp','33642735');
insert into empregado values (2,'Empregado 2','1966-01-01','Rua 2','Cidade 2','rj','33257896');
insert into empregado values (3,'Empregado 3','1966-01-01','Rua 3','Cidade 3','sp','33754127');

insert into empregado values (4,'Empregado 4','1976-01-01','Rua 4','Cidade 4','rj','33675896');
insert into empregado values (5,'Empregado 5','1976-01-01','Rua 5','Cidade 5','sp','33641258');
insert into empregado values (6,'Empregado 6','1976-01-01','Rua 6','Cidade 6','rj','33634185');

insert into empregado values (7,'Empregado 7','1991-01-01','Rua 7','Cidade 7','sp','33675896');
insert into empregado values (8,'Empregado 8','1991-01-01','Rua 8','Cidade 8','rj','33641258');
insert into empregado values (9,'Empregado 9','1991-01-01','Rua 9','Cidade 9','sp','33634185');

insert into dependente values (1,1,'Filho 1','2007-01-01',1);
insert into dependente values (1,2,'Filha 1','2002-01-01',2);
insert into dependente values (1,3,'Esposa 1','1971-01-01',99);

insert into dependente values (2,1,'Filho 2','2007-01-01',1);
insert into dependente values (2,2,'Filha 2','2002-01-01',2);
insert into dependente values (2,3,'Esposa 2','1971-01-01',99);

insert into dependente values (3,1,'Filho 3','2007-01-01',1);
insert into dependente values (3,2,'Filha 3','2002-01-01',2);
insert into dependente values (3,3,'Esposa 3','1971-01-01',99);

insert into dependente values (4,1,'Filho 4','2012-01-01',1);
insert into dependente values (4,2,'Filha 4','2008-01-01',2);
insert into dependente values (4,3,'Esposa 4','1980-01-01',99);

insert into dependente values (5,1,'Filho 5','2012-01-01',1);
insert into dependente values (5,2,'Filha 5','2008-01-01',2);
insert into dependente values (5,3,'Esposa 5','1980-01-01',99);

insert into dependente values (6,1,'Filho 6','2012-01-01',1);
insert into dependente values (6,2,'Filha 6','2008-01-01',2);
insert into dependente values (6,3,'Esposa 6','1980-01-01',99);

insert into dependente values (7,1,'Filho 7','2018-01-01',1);
insert into dependente values (7,2,'Filha 7','2014-01-01',2);
insert into dependente values (7,3,'Esposa 7','1998-01-01',99);

insert into dependente values (8,1,'Filho 8','2018-01-01',1);
insert into dependente values (8,2,'Filha 8','2014-01-01',2);
insert into dependente values (8,3,'Esposa 8','1998-01-01',99);

insert into dependente values (9,1,'Filho 9','2018-01-01',1);
insert into dependente values (9,2,'Filha 9','2014-01-01',2);
insert into dependente values (9,3,'Esposa 9','1998-01-01',99);

-- CONSULTAS

--1 - Escreva uma query para mostrar a mãe com idade > 50 anos e 
--seus filhos/filhas com idade > 17 anos.
--colunas -> nome e data nascimento esposa, nome e data nascimento filho, 
--nome e data nascimento filha e cidade

SELECT
	es.Depe_nm_Dependente	AS 'Nome da esposa',
	es.Depe_dt_Nascimento	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente	AS 'Nome do filho',
	fo.Depe_dt_Nascimento	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente	AS 'Nome da filha',
	fa.Depe_dt_Nascimento	AS 'Data de nascimento da filha', 
	e.Empr_nm_Cidade		AS 'Cidade'
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
	es.Depe_nm_Dependente	AS 'Nome da esposa',
	es.Depe_dt_Nascimento	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente	AS 'Nome do filho',
	fo.Depe_dt_Nascimento	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente	AS 'Nome da filha',
	fa.Depe_dt_Nascimento	AS 'Data de nascimento da filha', 
	e.Empr_ds_Endereco		AS 'Endereço'
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
	es.Depe_nm_Dependente	AS 'Nome da esposa',
	es.Depe_dt_Nascimento	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente	AS 'Nome do filho',
	fo.Depe_dt_Nascimento	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente	AS 'Nome da filha',
	fa.Depe_dt_Nascimento	AS 'Data de nascimento da filha', 
	e.Empr_nm_Estado		AS 'Estado'
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
	e.Empr_nm_Empregado		AS 'Nome do empregado',
	e.Empr_dt_Nascimento	AS 'Data de nascimento do empregado',
	es.Depe_nm_Dependente	AS 'Nome da esposa',
	es.Depe_dt_Nascimento	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente	AS 'Nome do filho',
	fo.Depe_dt_Nascimento	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente	AS 'Nome da filha',
	fa.Depe_dt_Nascimento	AS 'Data de nascimento da filha', 
	e.Empr_cd_Empregado		AS 'Código do empregado'
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
	e.Empr_nm_Empregado		AS 'Nome do empregado',
	e.Empr_dt_Nascimento	AS 'Data de nascimento do empregado',
	es.Depe_nm_Dependente	AS 'Nome da esposa',
	es.Depe_dt_Nascimento	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente	AS 'Nome do filho',
	fo.Depe_dt_Nascimento	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente	AS 'Nome da filha',
	fa.Depe_dt_Nascimento	AS 'Data de nascimento da filha', 
	e.Empr_nm_Cidade		AS 'Cidade'
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
	e.Empr_nm_Empregado		AS 'Nome do empregado',
	e.Empr_dt_Nascimento	AS 'Data de nascimento do empregado',
	es.Depe_nm_Dependente	AS 'Nome da esposa',
	es.Depe_dt_Nascimento	AS 'Data de nascimento esposa', 
	fo.Depe_nm_Dependente	AS 'Nome do filho',
	fo.Depe_dt_Nascimento	AS 'Data de nascimento do filho', 
	fa.Depe_nm_Dependente	AS 'Nome da filha',
	fa.Depe_dt_Nascimento	AS 'Data de nascimento da filha', 
	e.Empr_nm_Cidade		AS 'Cidade'
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

CREATE PROCEDURE Atualizar_AnoNascimento_tabEmpregado

-- código do empregado e ano recebidos via parâmetro
@codigoEmpregado CHAR(8),
@novoAno INT

AS
BEGIN
  
  -- Retorna erro se o código de empregado informado não existir na tabela Empregado

  IF @codigoEmpregado NOT IN (SELECT Empr_cd_Empregado FROM Empregado)
  BEGIN
	RAISERROR('Código de empregado inexistente.', 16, 1);
  END

	-- DATEFROMPARTS: permite a atualização de um campo DATE, separando por ano, mês e dia
	-- O ano é alterado para o informado, enquanto mês e dia permanecem na mesma data.
  
	UPDATE Empregado
	SET Empr_dt_Nascimento = DATEFROMPARTS(
		@novoAno,
		MONTH(Empr_dt_Nascimento),
		DAY(Empr_dt_Nascimento) )
	WHERE Empr_cd_Empregado = @codigoEmpregado;

  PRINT('Atualização finalizada');
END
GO

--Execução
EXEC Atualizar_AnoNascimento_tabEmpregado '1', 1992;
EXEC Atualizar_AnoNascimento_tabEmpregado '2', 1987;
EXEC Atualizar_AnoNascimento_tabEmpregado '3', 1982;
EXEC Atualizar_AnoNascimento_tabEmpregado '4', 1977;
EXEC Atualizar_AnoNascimento_tabEmpregado '5', 1972;
EXEC Atualizar_AnoNascimento_tabEmpregado '6', 1967;
EXEC Atualizar_AnoNascimento_tabEmpregado '7', 1962;
EXEC Atualizar_AnoNascimento_tabEmpregado '8', 1957;
EXEC Atualizar_AnoNascimento_tabEmpregado '9', 1952;
GO

--8 – na tabela de dependentes altere o ano das esposas para 
--1953,1956,1959,1973,1976,1979,1983,1986,1989 mantendo o dia e mês original.

CREATE PROCEDURE Atualizar_AnoEsposa_tabDependente
@codigoEmpregado CHAR(8),
@novoAno INT

AS
BEGIN
	
	IF @codigoEmpregado NOT IN (SELECT Empr_cd_Empregado FROM Empregado)
	BEGIN
		RAISERROR('Código de empregado inexistente.', 16, 1);
	END

	UPDATE Dependente
	SET Depe_dt_Nascimento = DATEFROMPARTS(
		@novoAno,
		MONTH(Depe_dt_Nascimento),
		DAY(Depe_dt_Nascimento) )
	WHERE Empr_cd_Empregado = @codigoEmpregado
		AND Pare_cd_Parentesco = 99;

	PRINT('Atualização finalizada');
END
GO

--Execução
EXEC Atualizar_AnoEsposa_tabDependente '1', 1953;
EXEC Atualizar_AnoEsposa_tabDependente '2', 1956;
EXEC Atualizar_AnoEsposa_tabDependente '3', 1959;
EXEC Atualizar_AnoEsposa_tabDependente '4', 1973;
EXEC Atualizar_AnoEsposa_tabDependente '5', 1976;
EXEC Atualizar_AnoEsposa_tabDependente '6', 1979;
EXEC Atualizar_AnoEsposa_tabDependente '7', 1983;
EXEC Atualizar_AnoEsposa_tabDependente '8', 1986;
EXEC Atualizar_AnoEsposa_tabDependente '9', 1989;

--9 - na tabela de dependentes altere o ano dos filhos homens para 
--1993, 1993, 1993, 1995, 1995, 1995, 1997, 1997, 1997 mantendo o dia e mês original

CREATE PROCEDURE Atualizar_AnoFilho_tabDependente
@codigoEmpregado CHAR(8),
@novoAno INT

AS
BEGIN

	IF @codigoEmpregado NOT IN (SELECT Empr_cd_Empregado FROM Empregado)
	BEGIN
		RAISERROR('Código de empregado inexistente.', 16, 1);
	END

	UPDATE Dependente
	SET Depe_dt_Nascimento = DATEFROMPARTS(
		@novoAno,
		MONTH(Depe_dt_Nascimento),
		DAY(Depe_dt_Nascimento) )
	WHERE Empr_cd_Empregado = @codigoEmpregado
		AND Pare_cd_Parentesco = 1;

	PRINT('Atualização finalizada');
END
GO

-- Execução
EXEC Atualizar_AnoFilho_tabDependente '1', 1993;
EXEC Atualizar_AnoFilho_tabDependente '2', 1993;
EXEC Atualizar_AnoFilho_tabDependente '3', 1993;

EXEC Atualizar_AnoFilho_tabDependente '4', 1995;
EXEC Atualizar_AnoFilho_tabDependente '5', 1995;
EXEC Atualizar_AnoFilho_tabDependente '6', 1995;

EXEC Atualizar_AnoFilho_tabDependente '7', 1997;
EXEC Atualizar_AnoFilho_tabDependente '8', 1997;
EXEC Atualizar_AnoFilho_tabDependente '9', 1997;
GO

--10 - na tabela de dependentes altere o ano das filhas mulheres para 
--2010, 2010, 2010, 2012, 2012, 2012, 2016, 2016, 2016 mantendo o dia e mês original

CREATE PROCEDURE Atualizar_AnoFilha_tabDependente
@codigoEmpregado CHAR(8),
@novoAno INT

AS
BEGIN

	IF @codigoEmpregado NOT IN (SELECT Empr_cd_Empregado FROM Empregado)
	BEGIN
		RAISERROR('Código de empregado inexistente.', 16, 1);
	END

	UPDATE Dependente
	SET Depe_dt_Nascimento = DATEFROMPARTS(
		@novoAno,
		MONTH(Depe_dt_Nascimento),
		DAY(Depe_dt_Nascimento) )
	WHERE Empr_cd_Empregado = @codigoEmpregado
		AND Pare_cd_Parentesco = 2;

	PRINT('Atualização finalizada');
END
GO

-- Execução
EXEC Atualizar_AnoFilha_tabDependente '1', 2010;
EXEC Atualizar_AnoFilha_tabDependente '2', 2010;
EXEC Atualizar_AnoFilha_tabDependente '3', 2010;

EXEC Atualizar_AnoFilha_tabDependente '4', 2012;
EXEC Atualizar_AnoFilha_tabDependente '5', 2012;
EXEC Atualizar_AnoFilha_tabDependente '6', 2012;

EXEC Atualizar_AnoFilha_tabDependente '7', 2016;
EXEC Atualizar_AnoFilha_tabDependente '8', 2016;
EXEC Atualizar_AnoFilha_tabDependente '9', 2016;
GO


-- ALTERNATIVA 01: uma procedure para alterar todos os anos dos empregados
-- Pode-se alterar a tabela de Depedentes seguindo a mesma lógica

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

	UPDATE e
	SET e.Empr_dt_Nascimento = DATEFROMPARTS(
		t.ano, 
		MONTH(e.Empr_dt_Nascimento), 
		DAY(e.Empr_dt_Nascimento))
	FROM Empregado e INNER JOIN @tab_Provisoria t ON e.Empr_cd_Empregado = t.cd;

	PRINT('Atualização finalizada');
END
GO

-- Execução:
EXEC AlterarAnos_tabEmpregado 1992,1987,1982,1977,1972,1967,1962, 1957, 1952;
GO


-- ALTERNATIVA 02: uma procedure para alterar um dependente selecionado

CREATE PROCEDURE Atualizar_AnoNascimento_tabDependente
@codigoEmpregado CHAR(8),
@codigoDependente INT,
@novoAno INT

AS
BEGIN
	
	-- Retorna erro se o código de empregado não existir na tabela

	IF @codigoEmpregado NOT IN (SELECT Empr_cd_Empregado FROM Empregado)
	BEGIN
		RAISERROR('Código de empregado inexistente.', 16, 1);
	END

	-- Retorna erro se o código de dependente não existir na tabela
	-- Com a subconsulta, a PROCEDURE continuará funcionando mesmo se novos tipos
	-- de dependente forem adiconados à tabela

	IF @codigoDependente NOT IN (SELECT DISTINCT Pare_cd_Parentesco FROM Parentesco)
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

	UPDATE Dependente
	SET Depe_dt_Nascimento = DATEFROMPARTS(
		@novoAno,
		MONTH(Depe_dt_Nascimento),
		DAY(Depe_dt_Nascimento) )
	WHERE Empr_cd_Empregado = @codigoEmpregado
		AND Pare_cd_Parentesco = @codigoDependente;

	PRINT('Atualização finalizada');
END
GO

EXEC Atualizar_AnoFilha_tabDependente '1', 2000;
EXEC Atualizar_AnoFilha_tabDependente '2', 2000;
EXEC Atualizar_AnoFilha_tabDependente '3', 2000;

EXEC Atualizar_AnoFilha_tabDependente '4', 2000;
EXEC Atualizar_AnoFilha_tabDependente '5', 2000;
EXEC Atualizar_AnoFilha_tabDependente '6', 2000;

EXEC Atualizar_AnoFilha_tabDependente '7', 2000;
EXEC Atualizar_AnoFilha_tabDependente '8', 2000;
EXEC Atualizar_AnoFilha_tabDependente '9', 2000;
GO

EXEC Atualizar_AnoNascimento_tabDependente '1', 2, 2010;
EXEC Atualizar_AnoNascimento_tabDependente '2', 2, 2010;
EXEC Atualizar_AnoNascimento_tabDependente '3', 2, 2010;

EXEC Atualizar_AnoNascimento_tabDependente '4', 2, 2012;
EXEC Atualizar_AnoNascimento_tabDependente '5', 2, 2012;
EXEC Atualizar_AnoNascimento_tabDependente '6', 2, 2012;

EXEC Atualizar_AnoNascimento_tabDependente '7', 2, 2016;
EXEC Atualizar_AnoNascimento_tabDependente '8', 2, 2016;
EXEC Atualizar_AnoNascimento_tabDependente '9', 2, 2016;
GO