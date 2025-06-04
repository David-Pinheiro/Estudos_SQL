-- EXERCÍCIO 03 - LABORATÓRIO DE BANCO DE DADOS (SQL SERVER)

USE LBD_EX
GO

--1. Liste todas as linhas e os campos cd_Comprador, nm_Comprador e ds_Email da tabela COMPRADOR

SELECT 
	cd_Comprador AS 'Código do comprador', 
	nm_Comprador AS Nome, 
	ds_Email AS Email
FROM Comprador;

--2. Liste todas as linhas e os campos cd_Vendedor, nm_Vendedor e ds_Email da tabela VENDEDOR
--em ordem alfabética decrescente.

SELECT 
	cd_Vendedor AS 'Código do vendedor', 
	nm_Vendedor AS Nome, 
	ds_Email AS Email
FROM Vendedor
ORDER BY nm_Vendedor DESC;

--3. Liste as colunas cd_Imovel, cd_Vendedor e vl_Preco de todos os imóveis do vendedor 2.

SELECT 
	cd_Imovel AS 'Código do imóvel', 
	cd_Vendedor AS 'Código do vendedor', 
	vl_Preco AS 'Preço do imóvel'
FROM Imovel
WHERE cd_Vendedor = 2;

--4. Liste as colunas cd_Imovel, cd_Vendedor, vl_Preco e sg_Estado dos imóveis cujo preço de venda
--seja inferior a 150 mil e sejam do Estado do RJ.

SELECT 
	cd_Imovel AS 'Código do imóvel', 
	cd_Vendedor AS 'Código do Vendedor', 
	vl_Preco AS 'Preço do imóvel', 
	sg_Estado AS Estado
FROM Imovel
WHERE vl_Preco < 150000 AND sg_Estado = 'RJ';

--5. Liste as colunas cd_Imovel, cd_Vendedor, vl_Preco e sg_Estado dos imóveis cujo preço de venda 
--seja inferior a 150 mil e o vendedor não seja 2.

SELECT 
	cd_Imovel AS 'Código do imóvel', 
	cd_Vendedor AS 'Código do vendedor', 
	vl_Preco AS 'Preço do imóvel', 
	sg_Estado AS Estado
FROM Imovel
WHERE vl_Preco < 150000 AND cd_Vendedor <> 2;

--6. Liste as colunas cd_Comprador, nm_Comprador, ds_Endereco e sg_Estado da tabela COMPRADOR 
--em que o Estado seja nulo.

SELECT 
	cd_Comprador AS 'Código do comprador', 
	nm_Comprador AS Nome, 
	ds_Endereco AS Endereço, 
	sg_Estado AS Estado
FROM Comprador
WHERE sg_Estado IS NULL;

--7. Liste todas as ofertas cujo valor esteja entre 100 mil e 150 mil.

SELECT *
FROM Oferta
WHERE vl_Oferta BETWEEN 100000 AND 150000;

--8. Liste todas as ofertas cuja data da oferta esteja entre 01/01/2009 e 01/03/2009.

SELECT *
FROM Oferta
WHERE dt_Oferta BETWEEN '2009-01-01' AND '2009-03-01';

--9. Liste todos os vendedores que comecem com a letra M.

SELECT nm_Vendedor AS 'Nome dos vendedores com a letra M'
FROM Vendedor
WHERE nm_Vendedor LIKE 'M%';

--10. Liste todos vendedores que tenham a letra A na segunda posição do nome

SELECT nm_Vendedor AS 'Vendedores com a letra A na segunda posição do nome'
FROM Vendedor
WHERE nm_Vendedor LIKE '_a%';

--11. Liste todos os compradores que tenham a letra U em qualquer posição do endereço

SELECT *
FROM Comprador
WHERE ds_Endereco LIKE '%u%';

--12. Liste todos os imóveis cujo código seja 2 ou 3 em ordem alfabética de endereço.

SELECT *
FROM Imovel
WHERE cd_Imovel IN (2, 3)
ORDER BY ds_Endereco ASC;

--13. Liste todas as ofertas cujo imóvel seja 2 ou 3 e o valor da oferta seja maior que 140 mil, 
--em ordem decrescente de data.

SELECT *
FROM Oferta
WHERE cd_Imovel IN (2, 3) AND vl_Oferta > 140000
ORDER BY dt_Oferta DESC;

--14. Liste todos os imóveis cujo preço de venda esteja entre 110 mil e 200 mil ou seja do vendedor 4 
--em ordem crescente de área útil.

SELECT *
FROM Imovel
WHERE (vl_Preco BETWEEN 110000 AND 200000) OR cd_Vendedor = 4
ORDER BY qt_AreaUtil ASC;

--15. Verifique a maior, a menor e o valor médio das ofertas desta tabela.

SELECT 
	MAX(vl_Oferta) AS 'Maior valor das ofertas', 
	MIN(vl_Oferta) AS 'Menor valor', 
	AVG(vl_Oferta) AS 'Valor médio'
FROM Oferta;

--16. Mostre o maior, o menor, o total e a média de preço de venda dos imóveis.

SELECT 
	MAX(vl_Preco) AS 'Maior valor', 
	MIN(vl_Preco) AS 'Menor valor', 
	SUM(vl_Preco) AS 'Valor total', 
	AVG(vl_Preco) AS 'Média de preço de venda'
FROM Imovel;

--17. Faça uma busca que retorne o total de ofertas realizadas nos anos de 2008, 2009 e 2010.

SELECT COUNT(*) AS 'Total de ofertas realizadas entre 2008 e 2010'
FROM OFERTA
WHERE YEAR(dt_Oferta) IN (2008, 2009, 2010);