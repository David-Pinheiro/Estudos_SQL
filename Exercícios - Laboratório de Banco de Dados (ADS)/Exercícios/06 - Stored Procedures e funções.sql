-- EXERCÍCIO 06 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

USE LBD_EX
GO

--1. Escreva uma procedure que receba o nome do bairro e um valor percentual como
--parâmetro, aplique este percentual de acréscimo nos imóveis deste bairro.

CREATE PROCEDURE Acrescimo01
@bairro varchar(20),		--recebida via parâmetro
@numPercentual decimal(3,2)	--recebida via parâmetro
AS
BEGIN
	UPDATE Imovel
	SET Imovel.vl_preco = i.vl_preco + (i.vl_preco * @numPercentual)/100
	FROM Imovel i INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro	-- objetivo: buscar Bairro pelo nome
	WHERE b.nm_Bairro LIKE @bairro
		AND i.cd_Cidade = b.cd_Cidade	-- previne Bairro com mesmo código, de outra cidade
		AND i.sg_Estado = b.sg_Estado	-- previne Bairro e Cidade com mesmo código, de outro Estado
END
GO

--Teste:
EXEC Acrescimo01 'Jardins', 5
GO

--2. Escreva uma procedure que receba o código do comprador e um valor percentual como parâmetro, 
--aplique este percentual de acréscimo na última oferta com o maior valor que esse comprador fez,
--se o valor desta oferta representar um valor inferior a 10% de acréscimo do valor do Imóvel,
--desconsiderar o reajuste.

CREATE PROCEDURE AtualizaMaiorOfertaComprador
    @cd_Comprador INT,
    @percentual DECIMAL(5,2)
AS
BEGIN
    -- Variáveis para armazenar a oferta a ser atualizada
    DECLARE @cd_Imovel INT;
    DECLARE @vl_Oferta MONEY;
    DECLARE @novo_Valor MONEY;
    DECLARE @vl_Imovel MONEY;
    DECLARE @dt_Oferta DATE;

    -- Buscar a maior oferta feita pelo comprador, com a data mais recente
    SELECT TOP 1 
        @cd_Imovel = cd_Imovel,
        @vl_Oferta = vl_Oferta,
        @dt_Oferta = dt_Oferta
    FROM Oferta
    WHERE cd_Comprador = @cd_Comprador
    ORDER BY vl_Oferta DESC, dt_Oferta DESC;

    -- Calcular o novo valor com acréscimo
    SET @novo_Valor = @vl_Oferta * (1 + @percentual / 100.0);

    -- Buscar o valor do imóvel correspondente
    SELECT @vl_Imovel = vl_Preco
    FROM Imovel
    WHERE cd_Imovel = @cd_Imovel;
	
    -- Verificar se o novo valor continua abaixo do preço do imóvel
    IF @novo_Valor >= @vl_Imovel * 1.10
    BEGIN
        UPDATE Oferta
        SET vl_Oferta = @novo_Valor
        WHERE cd_Comprador = @cd_Comprador
          AND cd_Imovel = @cd_Imovel
          AND dt_Oferta = @dt_Oferta;

        PRINT 'Oferta atualizada com sucesso.';
    END
    ELSE
    BEGIN
        PRINT 'Novo valor da oferta ultrapassa o valor do imóvel. Nenhuma alteração foi feita.';
    END
END
GO

--Teste:
EXEC AtualizaMaiorOfertaComprador 1, 2;

--3. Escreva uma procedure que calcule a média dos valores das ofertas de cada
--imóvel e salve esta média no registro do imóvel.

ALTER TABLE Imovel						--Inclusão necessária para salvar a média no registro do imóvel
ADD	vl_MediaOfertas money;
GO

CREATE PROCEDURE MediaOfertas
AS
BEGIN
	
	--Tabela virtual para obter os dados da média das ofertas
	WITH MediaPorImovel AS (
        SELECT 
            cd_Imovel,
            AVG(vl_Oferta) AS media
        FROM Oferta
        GROUP BY cd_Imovel
    )
	
	--Atualizar o valor da média de todo os imóveis
	UPDATE i
    SET i.vl_MediaOfertas = m.media
    FROM Imovel i
    INNER JOIN MediaPorImovel m 
		ON i.cd_Imovel = m.cd_Imovel
END
GO

--Teste:
EXEC MediaOfertas
GO

--4. Faça uma procedure que aplique um aumento no valor do Imóvel (cujo valor deve
--ser recebido como parâmetro), somente para os imóveis que estão com um índice
--de “BAIXO” na faixa de imóveis.

CREATE PROCEDURE Acrescimo03
@numPercentual decimal(5,2)

AS
	UPDATE i
	SET vl_preco = i.vl_preco + (1 + (@numPercentual/100))	--Atualiza de acordo com o percentual informado
	FROM Imovel i 
	INNER JOIN Faixa_Imovel f ON i.vl_Preco 
		BETWEEN f.vl_Minimo AND f.vl_Maximo					--Estabelece como parâmetro as faixas dos imóveis
	WHERE f.nm_Faixa = 'BAIXO'
GO

--Teste:
EXEC Acrescimo03 5
GO

--5. Escreva uma procedure que receba um valor percentual como parâmetro e
--aplique um desconto no valor do Imóvel somente nos Imóveis do estado de São
--Paulo.

CREATE PROCEDURE Acrescimo04
@numPercentual decimal(5,2)

AS
	UPDATE i
	SET vl_preco = i.vl_preco * (1 - (@numPercentual/100))	--Atualiza segundo o percentual informado
	FROM Imovel i
	WHERE i.sg_Estado = 'SP'
GO

--Teste:
EXEC Acrescimo04 5
GO

--6. Escreva uma procedure que receba como parâmetro o número do Imóvel e
--um número que represente a quatidade de parcelas em que o valor do imóvel será dividido.
--A procedure deve obter o valor total deste pedido, calcular o valor de
--cada parcela e gravar cada parcela na tabela Parcelas. 
--Se a quantidade de parcelas for maior que 3, acrescente 10% ao valor total do pedido, 
--divida-o na quantidade de parcelas recebida como parâmetro e grave-as na tabela Parcelas.
--Se a quantidade de parcelas for 1, retorne a mensagem: pedido à vista e interrompa o
--processamento. 
--Não deixe que o número de parcelas ultrapasse a 10. Se ultrapassar, retorne a mensagem:
--Quantidade de parcelas inválida.
--Antes de executar esta procedure, criar a tabela Parcelas e fazer o relacionamento
--com Imóvel e Comprador.

CREATE TABLE Parcelas(
	cd_Parcelas int IDENTITY NOT NULL,
	cd_Imovel int,
	cd_Comprador int,
	qt_Parcelas int,
	vl_Parcelas money
)
GO

--Criação da Chave Primária
ALTER TABLE Parcelas
ADD	CONSTRAINT PK_Parcelas
	PRIMARY KEY (cd_Parcelas)
GO

--Relacionamento com as tabelas Imóvel e Comprador
ALTER TABLE Parcelas
ADD	CONSTRAINT FK_Parcelas_Imovel
	FOREIGN KEY (cd_Imovel) REFERENCES Imovel (cd_Imovel)
GO

ALTER TABLE Parcelas
ADD	CONSTRAINT FK_Parcelas_Comprador
	FOREIGN KEY (cd_Comprador) REFERENCES Comprador (cd_Comprador)
GO

--Criação da Stored Procedure
CREATE PROCEDURE EX06
@cd_Imovel int,
@qt_Parcelas int
AS
BEGIN
    DECLARE @vlTotal_Imovel money
    DECLARE @vl_Parcelas money
    
	--Validação da quantidade de parcelas
    IF @qt_Parcelas < 1 OR @qt_Parcelas > 10
    BEGIN
        PRINT 'Quantidade de parcelas inválida'
		RETURN
    END

    ELSE
    BEGIN
        IF @qt_Parcelas = 1
        BEGIN
            PRINT 'Pedido à vista'
			RETURN
        END

        ELSE
        BEGIN
            -- Obtém o valor total do imóvel
            SELECT @vlTotal_Imovel = vl_preco
            FROM Imovel
            WHERE cd_Imovel = @cd_Imovel

			--Fluxo para parcelas menores ou iguais a 3
            IF @qt_Parcelas <= 3
            BEGIN
                SET @vl_Parcelas = ROUND(@vlTotal_Imovel / @qt_Parcelas, 2)
                
                INSERT INTO Parcelas(cd_Imovel, qt_Parcelas, vl_Parcelas)
                VALUES (@cd_Imovel, @qt_Parcelas, @vl_Parcelas)
            END

			--Fluxo para parcelas maiores que 3
            ELSE
            BEGIN
                SET @vlTotal_Imovel = @vlTotal_Imovel * 1.10
                SET @vl_Parcelas = ROUND(@vlTotal_Imovel / @qt_Parcelas, 2)
                
                INSERT INTO Parcelas(cd_Imovel, qt_Parcelas, vl_Parcelas)
                VALUES (@cd_Imovel, @qt_Parcelas, @vl_Parcelas)
            END
        END
    END
END
GO

--Teste:
EXEC EX06 1, 2;
GO

-- FUNCTIONS

--1. Escreva uma função que receba o código do Imóvel como parâmetro e retorne a
--quantidade de ofertas recebidas de todos os imóveis mesmo que não tenha oferta
--cadastrada, mostrando zero na quantidade.

CREATE FUNCTION Contador_Ofertas (@cd_Imovel int)
RETURNS INT AS
BEGIN
	DECLARE @qt_Ofertas INT
	
	SELECT @qt_Ofertas= COUNT(*)	--Contagem de ofertas
	FROM Oferta
	WHERE cd_Imovel = @cd_Imovel	--Estabelece a comparação com a variável
		
	RETURN @qt_Ofertas
END
GO

--Teste:
SELECT dbo.Contador_Ofertas(1) AS resultado
GO

--2. Escreva uma função que receba o código do Imóvel como parâmetro e mostre o
--nome do comprador que fez a última oferta.

CREATE FUNCTION Comprador_ultima_oferta (@cd_Imovel int)
RETURNS VARCHAR(40) AS
BEGIN
	DECLARE @nm_Comprador VARCHAR(40)
	
	SELECT TOP 1 @nm_Comprador = c.nm_Comprador					--Retorna apenas o primeiro registro
    FROM Oferta o
    INNER JOIN Comprador c ON o.cd_Comprador = c.cd_Comprador
    WHERE o.cd_Imovel = @cd_Imovel
    ORDER BY o.dt_Oferta DESC									--Ordena para estabelecer a última oferta no topo
	
	RETURN ISNULL(@nm_Comprador, 'Nenhuma oferta encontrada')	--Tratamento para null
END
GO

--Teste:
SELECT dbo.Comprador_ultima_oferta(1) AS resultado
GO