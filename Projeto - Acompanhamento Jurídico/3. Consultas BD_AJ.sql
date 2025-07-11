-- Consultas ao Banco de Dados - Sistema Acompanhamento Jurídico

-- 1 CONSULTAS BÁSICAS DE APOIO AO SISTEMA
-- 1.1 Listar todos os clientes, com todos os dados e números de processos

SELECT 
	c.nm_Cliente AS 'Cliente',
    CASE 
		WHEN c.cd_CPF IS NOT NULL THEN c.cd_CPF
        ELSE  c.cd_CNPJ
	END AS 'CPF/CNPJ',
--  CONCAT(c.nm_Logradouro, ', ', c.cd_NumeroEndereco, ', ', c.nm_Bairro, ', ', c.nm_Cidade, ', ', c.sg_Estado, ', CEP ', c.cd_CEP) AS 'Endereço',
    c.nm_Logradouro AS 'Logradouro',
    c.cd_NumeroEndereco AS 'Número',
    c.nm_Bairro AS 'Bairro',
    c.nm_Cidade AS 'Cidade',
    c.sg_Estado AS 'Estado', 
    c.cd_CEP AS 'CEP',
    c.cd_Telefone AS 'Telefone',
    c.ds_Email AS 'E-mail',
    GROUP_CONCAT(p.cd_NumeroProcesso SEPARATOR ' - ') AS 'Processo(s)'
FROM Cliente c
INNER JOIN Cliente_Processo cp ON cp.cd_Cliente = c.cd_Cliente
INNER JOIN Processo p ON cp.cd_Processo = p.cd_Processo
GROUP BY
	c.nm_Cliente, 
    c.cd_CPF, 
    c.cd_CNPJ,
    c.nm_Logradouro,
    c.cd_NumeroEndereco,
    c.nm_Bairro,
    c.nm_Cidade,
    c.sg_Estado,
    c.cd_CEP,
    c.cd_Telefone,
    c.ds_Email;

-- 1.2 Listar clientes e os respectivos processos em que atuam.

SELECT 
	c.nm_Cliente AS 'Cliente',
    GROUP_CONCAT(p.cd_NumeroProcesso SEPARATOR '\n') AS 'Processo'
FROM Cliente_Processo cp
INNER JOIN Cliente c ON c.cd_Cliente = cp.cd_Cliente
INNER JOIN Processo p ON p.cd_Processo = cp.cd_Processo
GROUP BY c.nm_Cliente;

-- 1.3 Exibir todas as intimações de um determinado processo, em ordem de recebimento.

-- Exemplo de processo para teste
SET @processo = '0001111-20.2023.8.26.0001';

SELECT
	p.cd_NumeroProcesso AS 'Processo',
    i.cd_Intimacao AS 'Código Intimação',
    i.dt_Recebimento AS 'Data recebimento',
    i.ds_Intimacao AS 'Teor da Intimação'
FROM Intimacao i
INNER JOIN Processo p ON i.cd_Processo = p.cd_Processo
WHERE p.cd_NumeroProcesso = @processo
ORDER BY i.dt_Recebimento ASC;

-- 1.4 Listar tarefas por status (aguardando, em andamento, concluído).

SELECT
	t.cd_Tarefa AS 'Tarefa',
    t.dt_Registro AS 'Data de registro',
    t.dt_Prazo AS 'Prazo para cumprimento',
    st.nm_StatusTarefa AS 'Status',
    p.cd_NumeroProcesso AS 'Processo',
    t.ds_Tarefa AS 'Descrição da tarefa'
FROM Tarefa t
INNER JOIN Intimacao i ON i.cd_Intimacao = t.cd_Intimacao
INNER JOIN Processo p ON p.cd_Processo = i.cd_Processo
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
ORDER BY st.nm_StatusTarefa;

-- 1.5 Listar colaboradores e o número de tarefas atribuídas.

SELECT 
	c.nm_Colaborador AS 'Colaborador',
    tc.nm_TipoColaborador AS 'Tipo',
    COUNT(t.cd_Tarefa) AS 'Quantidade de tarefas'
FROM Colaborador c
INNER JOIN Tarefa t ON c.cd_Colaborador = t.cd_Colaborador
INNER JOIN TipoColaborador tc ON tc.cd_TipoColaborador = c.cd_TipoColaborador
WHERE t.cd_StatusTarefa <> 3 -- código para Status "Concluída"
GROUP BY c.nm_Colaborador, tc.nm_TipoColaborador;

-- 1.6 Lista tarefas com status específico

-- Exemplo de status para teste
SET @status = 'Em andamento';

SELECT *
FROM Tarefa t
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
WHERE st.nm_StatusTarefa = @status;

-- 2 CONSUTLAS BASEADAS EM DATAS
-- 2.1 Listar tarefas com prazo vencido.

SELECT *
FROM Tarefa
WHERE (dt_Prazo < CURDATE()) AND cd_StatusTarefa <> 3;

-- 2.2 Listar tarefas a vencer nos próximos 7 dias.

SELECT *
FROM Tarefa
WHERE 
	(dt_Prazo BETWEEN CURDATE() AND (DATE_ADD(CURDATE(), INTERVAL 7 DAY))) AND
    cd_StatusTarefa <> 3;

-- 2.3 Buscar intimações recebidas em um determinado mês/ano.

-- Exemplos de mês e ano para teste
SET @mes = 3;
SET @ano = 2024;

SELECT *
FROM Intimacao
WHERE MONTH(dt_Recebimento) = @mes AND YEAR(dt_Recebimento) = @ano;

-- 2.4 Listar tarefas criadas entre duas datas específicas.

-- Exemplos de datas para teste
SET @data1 = '2025-06-01';
SET @data2 = '2025-06-20';

SELECT *
FROM Tarefa
WHERE dt_Prazo BETWEEN @data1 AND @data2;

-- 3 CONSULTAS POR RESPONSÁVEL
-- 3.1 Listar todas as tarefas de um colaborador específico.

-- Exemplo de colaborador para teste
SET @colaborador = 'Ana Paula';

SELECT 
	t.cd_Tarefa AS 'Código tarefa',
    t.dt_Registro AS 'Data de registro',
    t.dt_Prazo AS 'Prazo',
    t.nm_TipoTarefa AS 'Tarefa',
    t.ds_Tarefa AS 'Providência',
    p.cd_NumeroProcesso AS 'Processo',
    st.nm_StatusTarefa AS 'Status',
    c.nm_Colaborador AS 'Colaborador'
FROM Tarefa t
INNER JOIN Colaborador c ON t.cd_Colaborador = c.cd_Colaborador
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
INNER JOIN Intimacao i ON i.cd_Intimacao = t.cd_Intimacao
INNER JOIN Processo p ON p.cd_Processo = i.cd_Processo
WHERE c.nm_Colaborador = @colaborador
ORDER BY t.dt_Prazo, t.cd_StatusTarefa;

-- 3.2 Exibir os processos acompanhados por um determinado colaborador.

-- Exemplo de colaborador para teste
SET @colaborador = 'João Mendes';

SELECT 
	p.cd_NumeroProcesso AS 'Número do Processo',
    t.nm_TipoTarefa AS 'Tarefa',
    t.ds_Tarefa AS 'Providência',
    t.dt_Prazo AS 'Prazo',
    st.nm_StatusTarefa AS 'Status',
    c.nm_Colaborador AS 'Colaborador'
FROM Tarefa t
INNER JOIN Intimacao i ON i.cd_Intimacao = t.cd_Intimacao
INNER JOIN Processo p ON p.cd_Processo = i.cd_Processo
INNER JOIN Colaborador c ON c.cd_Colaborador = t.cd_Colaborador
INNER JOIN StatusTarefa st ON t.cd_StatusTarefa = st.cd_StatusTarefa
WHERE 
	c.nm_Colaborador = @colaborador AND
	t.cd_StatusTarefa <> 3;

-- 4 CONSULTAS POR TRIBUNAL OU CIDADE
-- 4.1 Agrupar processos por tribunal.

SELECT 
	p.cd_NumeroProcesso AS 'Processo',
    p.ds_Acao AS 'Ação',
    p.nm_Autor AS 'Autor',
    p.nm_Reu AS 'Reu',
    p.ds_Juizo AS 'Juízo',
    p.vl_Causa AS 'Valor da Causa',
    t.nm_Tribunal AS 'Tribunal'
FROM Processo p
INNER JOIN Tribunal t ON t.sg_Tribunal = p.sg_Tribunal
ORDER BY t.nm_Tribunal;

-- 4.2 Listar processos que tramitam em determinada cidade.

SELECT 
	cd_NumeroProcesso AS 'Processo',
    ds_Acao AS 'Ação',
    nm_Autor AS 'Autor',
    nm_Reu AS 'Reu',
    ds_Juizo AS 'Juízo',
    vl_Causa AS 'Valor da Causa',
    nm_Cidade AS 'Cidade'
FROM Processo
ORDER BY nm_Cidade;


-- 5 CONSULTAS ANALÍTICAS
-- 5.1 Contar quantos processos cada cliente possui.

SELECT 
	c.nm_Cliente AS 'Cliente',
    COUNT(cp.cd_Cliente) AS 'Quantidade de processos'
FROM Cliente_Processo cp
INNER JOIN Cliente c ON c.cd_Cliente = cp.cd_Cliente
GROUP BY cp.cd_Cliente;

-- 5.2 Calcular o valor total das causas por cliente.

SELECT 
	c.nm_Cliente AS 'Cliente',
    SUM(p.vl_Causa) AS 'Soma - valor das causas'
FROM Cliente_Processo cp
INNER JOIN Cliente c ON c.cd_Cliente = cp.cd_Cliente
INNER JOIN Processo p ON p.cd_Processo = cp.cd_Processo
GROUP BY cp.cd_Cliente;

-- 5.3 Calcular a quantidade de intimações recebidas por cada processo

SELECT
	p.cd_NumeroProcesso AS 'Processo',
    c.nm_Cliente AS 'Cliente',
    COUNT(i.cd_Processo) As 'Quantidade de intimações'
FROM Intimacao i
INNER JOIN Processo p ON p.cd_Processo = i.cd_Processo
INNER JOIN Cliente_Processo cp ON cp.cd_Processo = p.cd_Processo
INNER JOIN Cliente c ON c.cd_Cliente = cp.cd_Cliente
GROUP BY p.cd_NumeroProcesso, c.nm_Cliente;

-- 5.4 Calcular a quantidade de tarefas, agrupadas por Status

SELECT
	st.nm_StatusTarefa AS 'Status da tarefa',
    COUNT(t.cd_StatusTarefa) AS 'Quantidade de tarefas'
FROM Tarefa t
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
GROUP BY st.nm_StatusTarefa;

-- 5.5 Identificar processos com mais de n intimações

-- Exemplo de quantidade de intimações para teste
SET @quant_intimacoes = 2;

SELECT
	p.cd_NumeroProcesso AS 'Processo',
    p.ds_Acao AS 'Ação',
    c.nm_Cliente AS 'Cliente',
    COUNT(i.cd_Processo) AS 'Quantidade de intimações'
FROM Intimacao i
INNER JOIN Processo p ON i.cd_Processo = p.cd_Processo
INNER JOIN Cliente_Processo cp ON cp.cd_Processo = p.cd_Processo
INNER JOIN Cliente c ON c.cd_Cliente = cp.cd_Cliente
GROUP BY p.cd_NumeroProcesso, p.ds_Acao, c.cd_Cliente
HAVING COUNT(i.cd_Processo) >= @quant_intimacoes;

-- 6 OBJETOS PROGRAMÁVEIS DO BANCO DE DADOS (Views, Procedures e Triggers)

-- 6.1 View para consultas sobre tarefas

CREATE VIEW vw_Tarefas AS
SELECT
	t.cd_Tarefa AS Cod_Tarefa,
    t.nm_TipoTarefa AS Tarefa,
    t.ds_Tarefa AS Providência,
    t.dt_Prazo AS Prazo,
    st.nm_StatusTarefa AS Status,
    i.ds_Intimacao AS Intimação,
    p.cd_NumeroProcesso AS Processo,
    c.nm_Cliente AS Cliente
FROM Tarefa t
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
INNER JOIN Intimacao i ON i.cd_Intimacao = t.cd_Intimacao
INNER JOIN Processo p ON p.cd_Processo = i.cd_Processo
INNER JOIN Cliente_Processo cp ON cp.cd_Processo = p.cd_Processo
INNER JOIN Cliente c ON c.cd_Cliente = cp.cd_Cliente;

-- Exemplo de consulta para teste
SELECT
	Tarefa,
    Providência,
    Prazo
FROM vw_Tarefas
WHERE Prazo < CURDATE();