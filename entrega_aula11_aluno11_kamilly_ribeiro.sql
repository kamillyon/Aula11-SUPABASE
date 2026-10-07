-- ====================================================================
-- CURSO TÉCNICO EM DESENVOLVIMENTO DE SISTEMAS
-- DISCIPLINA: BANCO DE DADOS - AULA 11
-- TEMA: Funções Nativas, Agregações, GROUP BY e HAVING (PostgreSQL / Supabase)
-- ====================================================================
-- ALUNO(A): Kamilly Ribeiro
-- MATRÍCULA: MATRICULA_000
-- TURMA: TDS-2026.2
-- DATA DA ENTREGA: 07/10/2026
-- DESAFIO ESCOLHIDO: Aluno 11 - Hotelaria & Resort All-Inclusive
-- EMPRESA / CONTEXTO: GrandHotel Paradisus (Turismo & Hospitalidade)
-- TABELA DO BANCO: reservas_hotel
-- ====================================================================

-- ORIENTAÇÕES PARA AVALIAÇÃO:
-- 1. Este script pode ser executado integralmente no SQL Editor do Supabase.
-- 2. Cada tarefa abaixo contém o enunciado oficial do desafio.
-- 3. Escreva sua resolução SQL logo abaixo do comentário de cada tarefa.
-- ====================================================================

-- [PARTE 1] AMBIENTE: SCRIPT DDL E DML INICIAL
-- Execute esta parte primeiro para recriar e popular a tabela caso necessário.

DROP TABLE IF EXISTS reservas_hotel CASCADE;

CREATE TABLE reservas_hotel (
    id SERIAL PRIMARY KEY,
    titular VARCHAR(80) NOT NULL,
    tipo_quarto VARCHAR(40) NOT NULL,
    diaria NUMERIC(8,2) NOT NULL,
    noites INT NOT NULL,
    adultos INT NOT NULL,
    servico_quarto_valor NUMERIC(8,2) NOT NULL,
    data_checkin DATE NOT NULL
);

INSERT INTO reservas_hotel (titular, tipo_quarto, diaria, noites, adultos, servico_quarto_valor, data_checkin) VALUES
('Rodrigo Neves', 'Suíte Presidencial', 1500.0, 3, 2, 450.0, '2024-02-10'),
('Carla Mendez', 'Standard', 320.0, 4, 1, 80.0, '2024-02-12'),
('Marcelo Rossi', 'Luxo Vista Mar', 680.0, 5, 2, 290.0, '2024-02-14'),
('Amanda Rios', 'Standard', 320.0, 2, 2, 50.0, '2024-02-15'),
('Fábio Guimarães', 'Luxo Vista Mar', 680.0, 7, 3, 620.0, '2024-02-18'),
('Patrícia Leão', 'Bangalô Praia', 1100.0, 4, 2, 380.0, '2024-02-20'),
('Lucas Antunes', 'Standard', 320.0, 3, 1, 95.0, '2024-02-22'),
('Juliana Paes', 'Bangalô Praia', 1100.0, 5, 2, 510.0, '2024-02-25'),
('Eduardo Paiva', 'Suíte Presidencial', 1500.0, 4, 2, 890.0, '2024-02-28'),
('Beatriz Costa', 'Luxo Vista Mar', 680.0, 3, 2, 180.0, '2024-03-01'),
('Gabriel Sampaio', 'Standard', 320.0, 5, 2, 140.0, '2024-03-03'),
('Vanessa Toledo', 'Bangalô Praia', 1100.0, 6, 4, 750.0, '2024-03-05');

-- ====================================================================
-- [PARTE 2] RESOLUÇÃO DAS TAREFAS INDIVIDUAIS
-- ====================================================================

-- --------------------------------------------------------------------
-- TAREFA 1: Padronização e Formatação de Texto (titular)
-- Enunciado: Exiba a coluna titular em maiúsculas com UPPER(), a coluna tipo_quarto em minúsculas com LOWER() e a contagem de caracteres da coluna titular com LENGTH().
-- Dica: Use UPPER(titular), LOWER(tipo_quarto) e LENGTH(titular).
-- --------------------------------------------------------------------
-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT
    UPPER(titular) AS titular_maisculo,
    LOWER(tipo_quarto) AS tipo_quarto_minusculo,
    LENGTH(titular) AS qtd_caracteres_titular
FROM reservas_hotel;


-- --------------------------------------------------------------------
-- TAREFA 2: Cálculo Numérico e Simulação Promocional
-- Enunciado: Selecione titular, diaria e calcule uma simulação com 15% de desconto usando ROUND(diaria * 0.85, 2), além de arredondar o valor para cima com CEIL(diaria).
-- Dica: Use ROUND(diaria * 0.85, 2) AS valor_desconto e CEIL(diaria) AS valor_arredondado.
-- --------------------------------------------------------------------
-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT 
    titular,
    diaria AS diaria_original,
    ROUND(diaria*0.85,2) AS valor_desconto,
    CEIL(diaria) AS valor_arredondado
FROM reservas_hotel;


-- --------------------------------------------------------------------
-- TAREFA 3: Métricas Globais do Negócio (GrandHotel Paradisus)
-- Enunciado: Calcule o total de registros cadastrados, a soma do indicador ((diaria * noites)), o valor médio de diaria (arredondado para 2 casas) e o valor máximo encontrado.
-- Dica: Use COUNT(id), SUM((diaria * noites)), ROUND(AVG(diaria), 2) e MAX(diaria).
-- --------------------------------------------------------------------
-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT
    COUNT(id) AS total_clientes_cadastrados,
    SUM(diaria*noites) AS preco_a_pagar,
    ROUND(AVG(diaria),2) AS valor_medio_diaria,
    MAX(diaria) AS maior_diaria
FROM reservas_hotel;


-- --------------------------------------------------------------------
-- TAREFA 4: Relatório Gerencial Agrupado por Tipo_Quarto
-- Enunciado: Agrupe os dados por tipo_quarto exibindo: o nome do(a) tipo_quarto, a quantidade de itens desse grupo, o valor médio de diaria e o total somado ((diaria * noites)).
-- Dica: Use GROUP BY tipo_quarto com COUNT(id), ROUND(AVG(diaria), 2) e ROUND(SUM((diaria * noites)), 2).
-- --------------------------------------------------------------------
-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT 
    tipo_quarto,
    COUNT(id) AS qtd_clientes,
    ROUND(AVG(diaria), 2) AS preco_medio_diaria,
    ROUND(SUM(diaria*noites), 2) AS valor_total_somado
FROM reservas_hotel
GROUP BY tipo_quarto
ORDER BY valor_total_somado DESC;


-- --------------------------------------------------------------------
-- TAREFA 5: Filtro Gerencial de Alto Impacto com HAVING
-- Enunciado: Filtre o relatório agrupado por tipo_quarto para mostrar APENAS os grupos cujo valor total somado de ((diaria * noites)) seja superior a R$ 5,000.00.
-- Dica: Adicione HAVING SUM((diaria * noites)) > 5000.0 após o GROUP BY tipo_quarto.
-- --------------------------------------------------------------------
-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT 
    tipo_quarto,
    COUNT(id) AS qtd_cliente,
    ROUND(SUM(diaria*noites), 2) AS valor_total_a_receber
FROM reservas_hotel
WHERE diaria > 500 --filtra >500 (BRUTA)
GROUP BY tipo_quarto
HAVING SUM(diaria*noites) > 5000.00 --filtra que somam mais de 5000 (CONDIÇÃO)
ORDER BY valor_total_a_receber DESC;

-- --------------------------------------------------------------------
-- TAREFA 6: Ranking e Ordenação Estratégica
-- Enunciado: Agrupe por tipo_quarto, exiba a métrica de total somado com o alias 'faturamento_total' e ordene do maior para o menor resultado (decrescente).
-- Dica: Agrupe por tipo_quarto, declare SUM((diaria * noites)) AS faturamento_total e adicione ORDER BY faturamento_total DESC.
-- --------------------------------------------------------------------
-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT 
    tipo_quarto,
    COUNT(id) AS qtd_cliente,
    ROUND(SUM(diaria*noites), 2) AS faturamento_total
FROM reservas_hotel
GROUP BY tipo_quarto
ORDER BY faturamento_total DESC;


-- ====================================================================
-- FIM DA ENTREGA - VERIFIQUE SE TODAS AS 6 TAREFAS FORAM TESTADAS!
-- ====================================================================
