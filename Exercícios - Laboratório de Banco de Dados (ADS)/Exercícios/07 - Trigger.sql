-- EXERCÍCIO 07 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

USE LBD_EX
GO

--1. Escreva um trigger que realize a atualização do campo valor médio do Imóvel a
--cada nova oferta cadastrada, alterada ou excluída.

CREATE TRIGGER TrAtualiza_vlMedio 
ON Oferta
FOR INSERT, UPDATE, DELETE 
AS
BEGIN
	
	-- Teste se o comando é um DELETE, hipótese na qual será buscado o cd_Imovel da tabela Deleted
	IF EXISTS (SELECT 1 FROM Deleted) AND NOT EXISTS (SELECT 1 FROM Inserted)
	BEGIN
		UPDATE i							
		SET i.vl_MediaOfertas = (
			SELECT AVG(o.vl_Oferta)
			FROM Oferta o, Inserted i
			WHERE o.cd_Imovel = i.cd_Imovel
		)
		FROM Imovel i, Deleted
		WHERE i.cd_Imovel = Deleted.cd_Imovel
	END

	-- Se o teste falha, será buscado o cd_Imovel da tabela Inserted
	ELSE
	BEGIN
		UPDATE i							
		SET i.vl_MediaOfertas = (
			SELECT AVG(o.vl_Oferta)
			FROM Oferta o, Inserted i
			WHERE o.cd_Imovel = i.cd_Imovel
		)
		FROM Imovel i, Inserted
		WHERE i.cd_Imovel = Inserted.cd_Imovel
	END

END
GO

--Teste:
UPDATE Oferta
SET vl_Oferta = 200000
WHERE cd_Imovel = 3
GO

--2. Escreva um trigger que não permita a alteração de dados na tabela Estado e a sua
--exclusão.

CREATE TRIGGER Tr_Bloqueio_tbEstado 
ON Estado
INSTEAD OF UPDATE, DELETE
AS
BEGIN
	RAISERROR('Aviso: não é possível alterar os dados da tabela Estado', 16, 1);
END
GO

--Teste:
INSERT INTO Estado (sg_Estado, nm_Estado)
VALUES ('SC', 'Santa Catarina')
GO

--3. Escreva um trigger que não permita a alteração de dados na tabela Faixa Imóvel a
--sua exclusão.

CREATE TRIGGER Tr_Bloqueio_tbFaixaImovel
ON Faixa_Imovel
INSTEAD OF UPDATE, DELETE
AS
BEGIN
	-- RAISERROR: mensagem de Erro/aviso
	-- primeiro campo: mensagem que será exibida
	-- segundo campo: Severidade (nível de gravidade), 16 -> erro padrão
	-- terceiro campo: Estado (número de localização), 1 -> valor padrão
	RAISERROR('Aviso: não é possível alterar os dados da tabela Faixa_Imóvel', 16, 1);
END
GO

--Teste:
UPDATE Faixa_Imovel
SET nm_Faixa = 'MÉDIO'
WHERE cd_Faixa = 2
GO