-- EXERCÍCIO 05 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

USE LBD_EX
GO

--1. Faça uma lista de imóveis do mesmo bairro do imóvel 2. Exclua o imóvel 2 da sua busca.

SELECT *
FROM Imovel i
WHERE i.cd_Imovel <> 2 AND i.cd_Bairro = (
	SELECT cd_Bairro 
	FROM Imovel 
	WHERE cd_Imovel = 2
		AND i.cd_Cidade = cd_Cidade
		AND i.sg_Estado = sg_Estado
);

--2. Faça uma lista que mostre todos os imóveis que custam mais que a média de preço dos imóveis.

SELECT *
FROM Imovel
WHERE vl_preco > (SELECT AVG(vl_preco) FROM Imovel);

--3. Faça uma lista com todos os compradores que tenham ofertas cadastradas com o valor superior a 70 mil.

SELECT DISTINCT 
	c.cd_Comprador AS 'Código comprador', 
	c.nm_Comprador AS 'Nome comprador'
FROM Oferta o
LEFT JOIN Comprador c ON o.cd_Comprador = c.cd_Comprador
WHERE c.cd_Comprador IN (SELECT cd_Comprador FROM Oferta WHERE vl_Oferta > 70000);

--4. Faça uma lista com todos os imóveis com oferta superior à média do valor das Ofertas.

SELECT 
	i.cd_Imovel AS Código, 
	i.ds_Endereco AS Endereço, 
	b.nm_Bairro AS Bairro, 
	c.nm_Cidade AS Cidade, 
	i.sg_Estado AS Estado,
	STRING_AGG(CAST(o.vl_Oferta AS VARCHAR), '; ') AS Ofertas	--mostra todos os valores na mesma linha
FROM Imovel i
INNER JOIN Oferta o ON i.cd_Imovel = o.cd_Imovel
INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro
	AND i.cd_Cidade = b.cd_Cidade
	AND i.sg_Estado = b.sg_Estado
INNER JOIN Cidade c ON i.cd_Cidade = c.cd_Cidade
	AND i.sg_Estado = c.sg_Estado
WHERE o.vl_Oferta > (SELECT AVG(vl_Oferta) FROM Oferta)
GROUP BY i.cd_Imovel, i.ds_Endereco, b.nm_Bairro, c.nm_Cidade, i.sg_Estado;

--5. Faça uma lista com todos os imóveis com preço superior à média de preço dos imóveis do mesmo bairro.

SELECT 
	i.cd_Imovel AS Código, 
	ds_Endereco AS Endereço, 
	b.nm_Bairro AS Bairro, 
	c.nm_Cidade AS Cidade, 
	i.sg_Estado AS Estado, 
	CONCAT('R$ ', i.vl_preco) AS Preço
FROM Imovel i
INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro
	AND i.cd_Cidade = b.cd_Cidade
	AND i.sg_Estado = b.sg_Estado
INNER JOIN Cidade c ON i.cd_Cidade = c.cd_Cidade
	AND i.sg_Estado = c.sg_Estado
WHERE vl_preco > (
	SELECT AVG(vl_preco) 
	FROM Imovel 
	WHERE i.cd_Bairro = cd_Bairro
		AND i.cd_Cidade = cd_Cidade
		AND i.sg_Estado = sg_Estado)
ORDER BY cd_Imovel;

--6. Faça uma lista dos imóveis com o maior preço agrupado por bairro, cujo maior
--preço seja superior à média de preços dos imóveis.

SELECT
	b.nm_Bairro AS Bairro, 
	i.ds_Endereco AS Endereço, 
	c.nm_Cidade AS Cidade, 
	i.sg_Estado, i.cd_Imovel AS Código, 
	MAX(i.vl_Preco) AS Preço
FROM Imovel i
INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro
	AND i.cd_Cidade = b.cd_Cidade
	AND i.sg_Estado = b.sg_Estado
INNER JOIN Cidade c ON i.cd_Cidade = c.cd_Cidade
	AND i.sg_Estado = c.sg_Estado
GROUP BY i.cd_Imovel, i.ds_Endereco, b.nm_Bairro, c.nm_Cidade, i.sg_Estado
HAVING MAX(i.vl_Preco) > (SELECT AVG(vl_preco) FROM Imovel)
ORDER BY b.nm_Bairro;

--7. Faça uma lista com os imóveis que tem o preço igual ao menor preço de cada vendedor.

SELECT
	i.cd_Imovel AS Código, 
	v.nm_Vendedor, 
	i.ds_Endereco AS Endereço, 
	b.nm_Bairro AS Bairro, 
	c.nm_Cidade AS Cidade, 
	i.sg_Estado AS Estado, 
	i.vl_preco AS Preço
FROM Imovel i
INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro
	AND i.cd_Cidade = b.cd_Cidade
	AND i.sg_Estado = b.sg_Estado
INNER JOIN Cidade c ON i.cd_Cidade = c.cd_Cidade
	AND i.sg_Estado = c.sg_Estado
INNER JOIN Vendedor v ON i.cd_Vendedor = v.cd_Vendedor
WHERE i.vl_preco = ANY (SELECT MIN(vl_preco) FROM Imovel GROUP BY cd_Vendedor);

--8. Faça uma lista com as ofertas menores que todas as ofertas do comprador 2,
--exceto os imóveis do próprio comparador.

SELECT *
FROM Oferta
WHERE cd_Comprador <> 2 AND vl_Oferta < ALL (SELECT vl_Oferta FROM Oferta WHERE cd_Comprador = 2);

--9. Faça uma lista de todos os imóveis cujo Estado e Cidade sejam os mesmos do
--vendedor 3, exceto os imóveis do vendedor 3.

SELECT
	i. cd_Imovel AS Código, 
	i.ds_Endereco AS Endereço, 
	b.nm_Bairro AS Bairro, 
	c.nm_Cidade AS Cidade, 
	i.sg_Estado AS Estado
FROM Imovel i
INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro
	AND i.cd_Cidade = b.cd_Cidade
	AND i.sg_Estado = b.sg_Estado
INNER JOIN Cidade c ON i.cd_Cidade = c.cd_Cidade
	AND i.sg_Estado = c.sg_Estado
WHERE cd_Vendedor <> 3 AND EXISTS (
	SELECT * 
	FROM Imovel 
	WHERE cd_Vendedor = 3
		AND i.sg_Estado = sg_Estado
		AND i.cd_Cidade = cd_Cidade
);

--10. Faça uma lista com todos os nomes de bairro cujos imóveis sejam do mesmo
--Estado, cidade e bairro do imóvel código 5.

SELECT 
	i.cd_Bairro AS Código, 
	b.nm_Bairro AS 'Nome do bairro'
FROM Imovel i
INNER JOIN Bairro b ON i.cd_Bairro = b.cd_Bairro
	AND i.cd_Cidade = b.cd_Cidade
	AND i.sg_Estado = b.sg_Estado
WHERE i.cd_Bairro IN (
	SELECT cd_Bairro
	FROM Imovel
	WHERE cd_Imovel = 5
		AND i.cd_Cidade = cd_Cidade
		AND i.sg_Estado = sg_Estado
);