-- CRIAÇÃO DA TABELA

CREATE TABLE Estado (
idEstado INT IDENTITY(1,1) PRIMARY KEY,
Nome VARCHAR(50),
Sigla CHAR(2),
Populacao INT,
Regiao VARCHAR(50),
Capital VARCHAR(50),
Detrannet BIT
)

-- INSERÇÃO DE DADOS

INSERT INTO Estado (Nome, Sigla, Populacao, Regiao, Capital, Detrannet)
VALUES
('Acre', 'AC', 894470, 'Norte', 'Rio Branco', 0),
('Alagoas', 'AL', 3351543, 'Nordeste', 'Maceió', 0),
('Amapá', 'AP', 861773, 'Norte', 'Macapá', 0),
('Amazonas', 'AM', 4207714, 'Norte', 'Manaus', 0),
('Bahia', 'BA', 14930634, 'Nordeste', 'Salvador', 0),
('Ceará', 'CE', 9132078, 'Nordeste', 'Fortaleza', 0),
('Distrito Federal', 'DF', 3055149, 'Centro-Oeste', 'Brasília', 0),
('Espírito Santo', 'ES', 4064052, 'Sudeste', 'Vitória', 1),
('Goiás', 'GO', 7113540, 'Centro-Oeste', 'Goiânia', 0),
('Maranhão', 'MA', 7075181, 'Nordeste', 'São Luís', 1),
('Mato Grosso', 'MT', 3526220, 'Centro-Oeste', 'Cuiabá', 1),
('Mato Grosso do Sul', 'MS', 2809394, 'Centro-Oeste', 'Campo Grande', 0),
('Minas Gerais', 'MG', 21499339, 'Sudeste', 'Belo Horizonte', 0),
('Pará', 'PA', 8690745, 'Norte', 'Belém', 0),
('Paraíba', 'PB', 4039277, 'Nordeste', 'João Pessoa', 0),
('Paraná', 'PR', 11433957, 'Sul', 'Curitiba', 0),
('Pernambuco', 'PE', 9616621, 'Nordeste', 'Recife', 0),
('Piauí', 'PI', 3273227, 'Nordeste', 'Teresina', 0),
('Rio de Janeiro', 'RJ', 17264943, 'Sudeste', 'Rio de Janeiro', 0),
('Rio Grande do Norte', 'RN', 3534165, 'Nordeste', 'Natal', 1),
('Rio Grande do Sul', 'RS', 11422973, 'Sul', 'Porto Alegre', 0),
('Rondônia', 'RO', 1796460, 'Norte', 'Porto Velho', 1),
('Roraima', 'RR', 631181, 'Norte', 'Boa Vista', 0),
('Santa Catarina', 'SC', 7279632, 'Sul', 'Florianópolis', 1),
('São Paulo', 'SP', 45919049, 'Sudeste', 'São Paulo', 0),
('Sergipe', 'SE', 2318822, 'Nordeste', 'Aracaju', 0),
('Tocantins', 'TO', 1590248, 'Norte', 'Palmas', 1)

-- EXERCÍCIOS

--Selecione os estados da região Nordeste ordenados por população de forma descendente.
SELECT * 
FROM Estado 
WHERE Regiao = 'Nordeste'

--Selecione os três estados mais populosos
SELECT top 3 * 
FROM Estado 
ORDER BY Populacao DESC

--Selecione os estados com população inferior a 1 milhão
SELECT * 
FROM Estado 
WHERE Populacao > 1000000

--Selecione os estados que o nome é o mesmo nome da capital 
SELECT * 
FROM Estado 
WHERE Nome = Capital

--Selecione os estados da região Sul ou Sudeste cuja população seja maior que 5 milhões
SELECT * 
FROM Estado 
WHERE (Regiao = 'Sul' OR Regiao = 'Sudeste') AND Populacao > 5000000

--Selecione os estados cujo nome comece com a letra 'S' e a população seja inferior a 20 milhões
SELECT * 
FROM Estado 
WHERE Nome LIKE 'S%' AND Populacao > 20000000

--Selecione os estados cuja população seja inferior a 5 milhões e a capital comece com a letra 'B'
SELECT * 
FROM Estado 
WHERE Populacao > 5000000 AND Nome LIKE 'B%'

--Selecione os estados cuja sigla seja 'SP', 'RJ' ou 'MG'
SELECT * 
FROM Estado 
WHERE Sigla IN ('SP', 'RJ', 'MG')

--Selecione os estados e as capitais onde o Detrannet está implantado
SELECT * 
FROM Estado 
WHERE Detrannet = 1

--Selecione as regiões do país onde o Detrannet está implantado
SELECT Regiao 
FROM Estado 
WHERE Detrannet = 1

--Selecione os estados cuja capital não contenha a letra 'a'.
SELECT * 
FROM Estado 
WHERE Capital NOT LIKE '%a%'

--Selecione os estados ou as capitais que contenham a palavra 'Rio'
SELECT * 
FROM Estado 
WHERE Nome LIKE '%Rio%' OR Capital LIKE '%Rio%'

--Selecione os estados em que as capitais tenha um 'c' na terceira letra
SELECT * 
FROM Estado 
WHERE Capital LIKE '__c%'

--Selecione os estados cujo nome comece com 'M' e a capital termine com 'E'.
SELECT * 
FROM Estado 
WHERE Nome LIKE 'M%' AND Capital LIKE '%e'

--Selecione os estados com população superior a 15 milhões.
SELECT * 
FROM Estado 
WHERE Populacao > 15000000

--Selecione os estados cuja população esteja entre 10 e 20 milhões.
SELECT * 
FROM Estado 
WHERE Populacao BETWEEN 10000000 AND 20000000

--Selecione os estados que termina com a letra 'á' (acentuado)
SELECT * 
FROM Estado 
WHERE Nome LIKE '%á' COLLATE Latin1_General_CI_AS

--Selecione os estados cujo nome contenha a letra 'e' e a letra 'o'.
SELECT * 
FROM Estado 
WHERE Nome LIKE '%e%' AND Nome LIKE '%o%'

--Selecione os estados da região 'Norte' cuja capital não contenha a letra 'a'
SELECT * 
FROM Estado 
WHERE Regiao = 'Norte' AND Capital NOT LIKE '%a%'

--Quantos estados tem em cada região do país
SELECT 
	Regiao AS Região, 
	COUNT(*) AS "Número de Estados" 
FROM Estado 
GROUP BY Regiao 
ORDER BY Regiao ASC
