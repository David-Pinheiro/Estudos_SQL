-- EXERCÍCIO 04 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

USE LBD_EX
GO

--1. Faça uma busca que mostre cd_Imovel, cd_Vendedor, nm_Vendedor e sg_Estado.

SELECT 
	i.cd_Imovel AS 'Código imóvel', 
	i.cd_Vendedor AS 'Código vendedor', 
	v.nm_Vendedor AS 'Nome vendedor', 
	i.sg_Estado AS 'Estado'
FROM Imovel AS i 
LEFT JOIN Vendedor AS v ON i.cd_Vendedor = v.cd_Vendedor;

--2. Faça uma busca que mostre cd_Comprador, nm_Comprador, cd_Imovel e vl_Oferta.

SELECT 
	c.cd_Comprador AS 'Código comprador', 
	c.nm_Comprador AS 'Nome comprador', 
	o.cd_Imovel AS 'Código imóvel', 
	o.vl_Oferta AS 'Valor da oferta'
FROM Comprador AS c 
LEFT JOIN Oferta AS o ON c.cd_Comprador = o.cd_Comprador;

--3. Faça uma busca que mostre cd_Imovel, vl_Imovel e nm_Bairro, cujo código do vendedor seja 3.

SELECT 
	i.cd_Imovel AS 'Código imóvel', 
	i.vl_Preco AS 'Preço imóvel', 
	b.nm_Bairro AS 'Bairro'
FROM Imovel AS i 
INNER JOIN Bairro AS b
	ON (i.cd_Bairro = b.cd_Bairro) 
	AND (i.cd_Cidade = b.cd_Cidade)		--previne duplicidade, de Bairros com mesma Cidade
	AND (i.sg_Estado = b.sg_Estado)		--previne duplicidade, com Cidades com mesmo Estado
WHERE i.cd_Vendedor = 3
ORDER BY cd_Imovel ASC;

--4. Faça uma busca que mostre todos os imóveis que tenham ofertas cadastradas.

SELECT DISTINCT i.cd_Imovel AS 'Código Imóvel'		--DISTINCT para eliminar duplicidade no resultado
FROM Imovel AS i 
INNER JOIN Oferta AS o ON i.cd_Imovel = o.cd_Imovel
ORDER BY i.cd_Imovel ASC;

--5. Faça uma busca que mostre todos os imóveis e ofertas mesmo que não haja ofertas cadastradas para o imóvel.

SELECT 
	i.cd_Imovel AS 'Código imovel', 
	o.cd_Comprador AS 'Código comprador', 
	o.vl_Oferta AS 'Valor oferta', 
	o.dt_Oferta AS 'Data oferta'
FROM Imovel AS i 
LEFT JOIN Oferta AS o ON i.cd_Imovel = o.cd_Imovel	--LEFT JOIN: garante que todos os imóveis seja mostrados
ORDER BY i.cd_Imovel ASC;

--6. Faça uma busca que mostre os compradores e as respectivas ofertas realizadas por eles.

SELECT 
	c.nm_Comprador AS 'Nome comprador', 
	c.cd_Comprador AS 'Código comprador', 
	o.vl_Oferta 'Valor oferta', 
	o.cd_Imovel AS 'Código imóvel', 
	o.dt_Oferta AS 'Data oferta'
FROM Comprador AS c 
INNER JOIN Oferta AS o ON c.cd_Comprador = o.cd_Comprador
ORDER BY c.nm_Comprador ASC;

--7. Faça a mesma busca, porém acrescentando os compradores que ainda não fizeram ofertas para os imóveis.

SELECT 
	c.nm_Comprador AS 'Nome comprador', 
	c.cd_Comprador AS 'Código comprador', 
	o.vl_Oferta 'Valor oferta', 
	o.cd_Imovel AS 'Código imóvel', 
	o.dt_Oferta AS 'Data oferta'
FROM Comprador AS c 
LEFT JOIN Oferta AS o ON c.cd_Comprador = o.cd_Comprador
ORDER BY c.nm_Comprador ASC;

--8. Faça uma busca que mostre o endereço do imóvel, o bairro e nível de preço do imóvel.

SELECT 
	i.ds_Endereco AS 'Endereço', 
	b.cd_Bairro AS 'Código cidade', 
	b.nm_Bairro AS 'Bairro', 
	f.nm_Faixa AS 'Nível de preço'
FROM Imovel AS i 
INNER JOIN Bairro AS b 
	ON (i.cd_Bairro = b.cd_Bairro) AND (i.sg_Estado = b.sg_Estado)
INNER JOIN Faixa_Imovel AS f 
	ON i.vl_Preco BETWEEN f.vl_Minimo AND f.vl_Maximo;

--9. Faça uma busca que retorne o total de imóveis por nome de vendedor. Apresente em ordem de total de imóveis.

SELECT 
	v.nm_Vendedor AS 'Nome vendedor', 
	COUNT(*) AS 'Total de imóveis'
FROM Vendedor AS v 
LEFT JOIN Imovel AS i ON v.cd_Vendedor = i.cd_Vendedor
GROUP BY nm_Vendedor
ORDER BY COUNT(*);

--10. Verifique a diferença de preços entre o maior e o menor imóvel da tabela.

-- opção 1, para consulta à diferença de preços, comparando maior e menor preço
SELECT 
	(MAX(vl_Preco) - MIN(vl_Preco)) AS 'Diferença de preço entre o mais caro e mais barato'
FROM Imovel;

-- opção 2, para consulta à diferença de preços, considerando o imóvel com
-- maior área total e o imóvel com menor

WITH MaiorPreco AS (
	SELECT TOP 1(vl_Preco) AS valor
	FROM Imovel
	ORDER BY qt_AreaTotal DESC),

	MenorPreco AS (
	SELECT TOP 1(vl_Preco) AS valor
	FROM Imovel
	ORDER BY qt_AreaTotal ASC)

SELECT maior.valor - menor.valor AS 'Diferença entre o valor do maior e do menor imóvel'
FROM MaiorPreco AS maior, MenorPreco menor;

--ou

SELECT (
	SELECT TOP 1(vl_Preco) 
	FROM Imovel
	ORDER BY qt_AreaTotal DESC
) - (
	SELECT TOP 1(vl_Preco) 
	FROM Imovel
	ORDER BY qt_AreaTotal ASC
) AS 'Diferença entre o valor do maior e do menor imóvel';

--11. Mostre o código do vendedor e o menor preço de imóvel dele no cadastro. 
--Exclua da busca os valores de imóveis inferiores a 10 mil.

SELECT 
	v.cd_Vendedor AS 'Código vendedor', 
	MIN(i.vl_Preco) AS 'Menor preço de imóvel no cadastro'
FROM Vendedor AS v 
LEFT JOIN Imovel AS i 
	ON (v.cd_Vendedor = i.cd_Vendedor) 
	AND i.vl_Preco >= 10000
GROUP BY v.cd_Vendedor;

--12. Mostre o código e o nome do comprador e a média do valor das ofertas e o número de ofertas deste comprador.

SELECT 
	c.cd_Comprador AS 'Código comprador', 
	c.nm_Comprador, AVG(o.vl_Oferta) AS 'Média do valor das ofertas', 
	COUNT(*) AS 'Número de ofertas'
FROM Oferta AS o 
RIGHT JOIN Comprador AS c ON o.cd_Comprador = c.cd_Comprador
GROUP BY c.cd_Comprador, c.nm_Comprador;