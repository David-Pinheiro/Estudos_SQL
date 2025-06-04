-- EXERCÍCIO 02 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

USE LBD_EX
GO

-- 1. Inclua linhas na tabela ESTADO
INSERT INTO Estado (sg_Estado, nm_Estado)
VALUES  ('SP', 'SÃO PAULO'),
		('RJ', 'RIO DE JANEIRO');

-- 2. Inclua linhas na tabela CIDADE
INSERT INTO Cidade (cd_Cidade, nm_Cidade, sg_Estado)
VALUES  (1, 'SÃO PAULO', 'SP'),
		(2, 'SANTO ANDRÉ', 'SP'),
		(3, 'CAMPINAS', 'SP'),
		(1, 'RIO DE JANEIRO', 'RJ'),
		(2, 'NITEROI', 'RJ');

-- 3. Inclua linhas na tabela BAIRRO
INSERT INTO Bairro (cd_Bairro, nm_Bairro, cd_Cidade, sg_Estado)
VALUES  (1, 'JARDINS', 1, 'SP'),
		(2, 'MORUMBI', 1, 'SP'),
		(3, 'AEROPORTO', 1, 'SP'),
		(1, 'AEROPORTO', 1, 'RJ'),
		(2, 'NITEROI', 2, 'RJ');

-- 4. Inclua linhas na tabela VENDEDOR
INSERT INTO Vendedor (cd_Vendedor, nm_Vendedor, ds_Endereco, ds_Email)
VALUES  (1, 'MARIA DA SILVA', 'RUA DO GRITO, 45', 'msilva@nova.com'),
		(2, 'MARCO ANDRADE', 'AV. DA SAUDADE, 325', 'mandrade@nova.com'),
		(3, 'ANDRÉ CARDOSO', 'AV. BRASIL, 401', 'acardoso@nova.com'),
		(4, 'TATIANA SOUZA', 'RUA DO IMPERADOR, 778', 'tsouza@nova.com');

-- 5. Inclua linhas na tabela IMOVEL
INSERT INTO Imovel (cd_Imovel, cd_Vendedor, cd_Bairro, cd_Cidade, sg_Estado, ds_Endereco, qt_AreaUtil, qt_AreaTotal, vl_Preco)
VALUES  (1, 1, 1, 1, 'SP', 'AL. TIETE, 3304/101', 250, 400, 180000),
		(2, 1, 2, 1, 'SP', 'AV. MORUMBI, 2230', 150, 250, 135000),
		(3, 2, 1, 1, 'RJ', 'R. GAL. OSORIO, 445/34', 250, 400, 185000),
		(4, 2, 2, 2, 'RJ', 'R. D. PEDRO I, 882', 120, 200, 110000),
		(5, 3, 3, 1, 'SP', 'AV. RUBEN BERTA, 2355', 110, 200, 95000),
		(6, 4, 1, 1, 'RJ', 'R. GETULIO VARGAS, 552', 200, 300, 99000);

-- 6. Inclua linhas na tabela COMPRADOR
INSERT INTO Comprador (cd_Comprador, nm_Comprador, ds_Endereco, ds_Email)
VALUES  (1, 'EMMANUEL ANTUNES', 'R. SARAIVA, 452', 'eantunes@nova.com'),
		(2, 'JOANA PEREIRA', 'AV PORTUGAL, 52', 'jpereira@nova.com'),
		(3, 'RONALDO CAMPELO', 'R. ESTADOS UNIDOS, 13', 'rcampelo@nova.com'),
		(4, 'MANFRED AUGUSTO', 'AV. BRASIL, 351', 'maugusto@nova.com');

-- 7. Inclua linhas na tabela OFERTA
INSERT INTO Oferta (cd_Comprador, cd_Imovel, vl_Oferta, dt_Oferta)
VALUES  (1, 1, 170000, '10/01/2009'),
		(1, 3, 180000, '10/01/2009'),
		(2, 2, 135000, '15/01/2009'),
		(2, 4, 100000, '15/02/2009'),
		(3, 1, 160000, '05/01/2009'),
		(3, 2, 140000, '20/02/2009');

-- 8. Aumente o preço de vendas dos imóveis em 10%
UPDATE Imovel
SET vl_Preco = (vl_Preco * 1.10)

--9. Abaixe o preço de venda dos imóveis do vendedor 1 em 5%
UPDATE Imovel
SET vl_Preco = (vl_Preco * 0.95)
WHERE cd_Vendedor = 1

--10. Aumente em 5% o valor das ofertas do comprador 2
UPDATE Oferta
SET vl_Oferta = (vl_Oferta * 1.05)
WHERE cd_Comprador = 2

--11. Altere o endereço do comprador 3 para R. ANANÁS, 45 e o estado para RJ
UPDATE Comprador
SET ds_Endereco = 'R. ANANÁS, 45', sg_Estado = 'RJ'
WHERE cd_Comprador = 3

--12. Altere a oferta do comprador 2 no imóvel 4 para 101.000
UPDATE Oferta
SET vl_Oferta = 101000
WHERE cd_Comprador = 2 AND cd_Imovel = 4

--13. Exclua a oferta do comprador 3 no imóvel 1
DELETE FROM Oferta
WHERE cd_Comprador = 3 AND cd_Imovel = 1

--14. Exclua a cidade 3 do estado SP
DELETE FROM Cidade
WHERE cd_Cidade = 3 AND sg_Estado = 'SP'

--15. Inclua linhas na tabela FAIXA_IMOVEL:
INSERT INTO Faixa_Imovel (cd_Faixa, nm_Faixa, vl_Minimo, vl_Maximo)
VALUES  (1, 'BAIXO', 0, 105000),
		(2, 'MÉDIO', 105001, 180000),
		(3, 'ALTO', 180001, 999999);