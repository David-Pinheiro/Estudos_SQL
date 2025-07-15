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
LEFT JOIN Cliente_Processo cp ON cp.cd_Cliente = c.cd_Cliente
LEFT JOIN Processo p ON cp.cd_Processo = p.cd_Processo
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
FROM Cliente c
LEFT JOIN Cliente_Processo cp ON c.cd_Cliente = cp.cd_Cliente
LEFT JOIN Processo p ON p.cd_Processo = cp.cd_Processo
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

-- 1.6 Listar tarefas com status específico

-- Exemplo de status para teste
SET @status = 'Em andamento';

SELECT *
FROM Tarefa t
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
WHERE st.nm_StatusTarefa = @status;

-- 1.7 Listar tarefas com fase específica

-- Exemplo de fase para teste
SET @fase = 'Conhecimento';

SELECT
    p.cd_Processo AS 'Código',
    p.cd_NumeroProcesso AS 'Processo',
    CASE WHEN cp.cd_PosicaoAcao = 1 THEN CONCAT(p.nm_Autor, ' (cliente)') ELSE p.nm_Autor END AS 'Autor',
    CASE WHEN cp.cd_PosicaoAcao = 2 THEN CONCAT(p.nm_Reu, ' (cliente)') ELSE p.nm_Reu END AS 'Réu',
    p.ds_Acao AS 'Ação',
    p.ds_Juizo AS 'Juízo',
    p.nm_Cidade AS 'Cidade',
    p.sg_Tribunal AS 'Tribunal',
    p.vl_Causa AS 'Valor da causa'
FROM Processo p
INNER JOIN FaseProcesso fp ON fp.cd_FaseProcesso = p.cd_FaseProcesso
INNER JOIN Cliente_Processo cp ON cp.cd_Processo = p.cd_Processo
WHERE fp.nm_FaseProcesso = @fase;

-- 1.8 Buscar intimações pendentes de providências atribuídas (ou seja, intimações sem tarefa associada).

SELECT *
FROM Intimacao i
LEFT JOIN Tarefa t ON t.cd_Intimacao = i.cd_Intimacao
WHERE i.cd_Intimacao NOT IN (SELECT cd_Intimacao FROM Tarefa);

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

-- 3.3 Consultas as informações sobre as atividades de um colaborador

-- Exemplo de colaborador para teste
SET @colaborador = 'Ana Paula';

SELECT
    c.nm_Colaborador AS 'Colaborador',
    COUNT(t.cd_Tarefa) AS 'Quant. Tarefas',
    COUNT(CASE WHEN t.cd_StatusTarefa = 1 THEN t.cd_Tarefa END) AS 'Quant. Tarefas - aguardando',
    COUNT(CASE WHEN t.cd_StatusTarefa = 2 THEN t.cd_Tarefa END) AS 'Quant. Tarefas - em andamento',
    COUNT(CASE WHEN t.cd_StatusTarefa = 3 THEN t.cd_Tarefa END) AS 'Quant. Tarefas - concluída',
    COUNT(i.cd_Intimacao) AS 'Quant. Intimações',
    GROUP_CONCAT(p.cd_NumeroProcesso SEPARATOR '\n') AS 'Processo(s)'
FROM Colaborador c
INNER JOIN Tarefa t ON c.cd_Colaborador = c.cd_Colaborador AND t.cd_Colaborador = c.cd_Colaborador
INNER JOIN Intimacao i ON i.cd_Intimacao = t.cd_Intimacao
INNER Join Processo p ON p.cd_Processo = i.cd_Processo
WHERE c.nm_Colaborador = @colaborador
GROUP BY c.nm_Colaborador;

-- 3.4 Listar a quantidade de tarefas cumpridas por colaborador, em mês e ano específicos

-- Exemplo de mês e ano para teste
SET @mes = 5;
SET @ano = 2025;

SELECT
    c.nm_Colaborador AS 'Colaborador',
    t.cd_Tarefa AS 'Cod. Tarefa',
    t.dt_Registro AS 'Data cadastro',
    t.dt_Prazo AS 'Prazo',
    t.nm_TipoTarefa AS 'Tarefa',
    t.ds_Tarefa AS 'Providência',
    st.nm_StatusTarefa AS 'Status'
FROM Tarefa t
INNER JOIN Colaborador c ON c.cd_Colaborador = t.cd_Colaborador
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
WHERE MONTH(t.dt_Registro) = @mes AND YEAR(t.dt_Registro) = @ano AND t.cd_StatusTarefa = 3;

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

-- Calcular a quantidade de processos em cada fase

SELECT
    COUNT(p.cd_Processo) AS 'Total de processos',
    COUNT(CASE WHEN p.cd_FaseProcesso = 1 THEN p.cd_Processo END) AS 'Fase de conhecimento',
    COUNT(CASE WHEN p.cd_FaseProcesso = 2 THEN p.cd_Processo END) AS 'Fase recursal',
    COUNT(CASE WHEN p.cd_FaseProcesso = 3 THEN p.cd_Processo END) AS 'Fase de execução',
    COUNT(CASE WHEN p.cd_FaseProcesso = 4 THEN p.cd_Processo END) AS 'Finalizado'
FROM Processo p
INNER JOIN FaseProcesso fp ON fp.cd_FaseProcesso = p.cd_FaseProcesso;

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

-- 5.6 Relatório mensal de produtividade por colaborador (quantidade de tarefas concluídas no mês).

-- Exemplo de mês e ano para teste
SET @mes = 5;
SET @ano = 2025;

SELECT
    c.nm_Colaborador AS 'Colaborador',
    COUNT(*) AS 'Quantidade'
FROM Tarefa t
INNER JOIN Colaborador c ON c.cd_Colaborador = t.cd_Colaborador
INNER JOIN StatusTarefa st ON st.cd_StatusTarefa = t.cd_StatusTarefa
WHERE MONTH(t.dt_Registro) = @mes AND YEAR(t.dt_Registro) = @ano AND t.cd_StatusTarefa = 3
GROUP BY c.nm_Colaborador;

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