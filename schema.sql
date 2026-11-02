-- ============================================================
-- Financas: sistema de finanças pessoais
-- Banco testado no SQLite (sqliteonline.com)
--
-- Como usar: rode as seções NA ORDEM (1 -> 2 -> 3).
-- Rode cada INSERT uma vez só (id repetido dá UNIQUE constraint failed).
-- ============================================================


-- ============================================================
-- 1. TABELAS
-- Primeiro as tabelas de tipos, porque as outras apontam pra elas (FK).
-- ============================================================

-- Tipos de despesa (MERCADO, TRANSPORTE...). Relação 1:N com Despesas.
CREATE TABLE tipo_Despesas
(
    id   INT,
    tipo VARCHAR(50),
    PRIMARY KEY (id)
);

-- Despesa = tudo que sai da conta.
-- paga = false -> ainda não saiu dinheiro da conta (conta pendente).
CREATE TABLE Despesas
(
    id              INT,
    descricao       VARCHAR(100),
    valor           DECIMAL(10, 2),
    data_Vencimento DATE,
    paga            BOOLEAN,
    tipo            INT,                                      -- guarda o id do tipo, não o texto
    PRIMARY KEY (id),
    FOREIGN KEY (tipo) REFERENCES tipo_Despesas (id)
);

-- Tipos de entrada (Salario, Freelance...). Relação 1:N com Entrada.
CREATE TABLE tipo_Entrada
(
    id     INT,
    tipoen VARCHAR(50),
    PRIMARY KEY (id)
);

-- Entrada = dinheiro que entra na conta.
CREATE TABLE Entrada
(
    id        INT,
    descricao VARCHAR(100),
    valor     DECIMAL(10, 2),
    data      DATE,
    tipoen    INT,                                            -- guarda o id do tipo de entrada
    PRIMARY KEY (id),
    FOREIGN KEY (tipoen) REFERENCES tipo_Entrada (id)
);


-- ============================================================
-- 2. DADOS DE TESTE
-- Datas no formato 'AAAA-MM-DD'. Texto com aspas simples.
-- ============================================================

INSERT INTO tipo_Despesas (id, tipo)
VALUES (1, 'MERCADO');
INSERT INTO tipo_Despesas (id, tipo)
VALUES (2, 'TRANSPORTE');
INSERT INTO tipo_Despesas (id, tipo)
VALUES (3, 'E-comerce');
INSERT INTO tipo_Despesas (id, tipo)
VALUES (4, 'Lazer');

INSERT INTO Despesas (id, descricao, valor, data_Vencimento, paga, tipo)
VALUES (1, 'Açougue', 55.72, '2026-11-10', false, 1);
INSERT INTO Despesas (id, descricao, valor, data_Vencimento, paga, tipo)
VALUES (2, 'Uber pra Lapa', 20.22, '2026-11-01', true, 2);
INSERT INTO Despesas (id, descricao, valor, data_Vencimento, paga, tipo)
VALUES (3, 'Shoppe', 30.72, '2026-11-20', false, 3);
INSERT INTO Despesas (id, descricao, valor, data_Vencimento, paga, tipo)
VALUES (4, 'Shoppe', 90.50, '2026-11-20', false, 3);
INSERT INTO Despesas (id, descricao, valor, data_Vencimento, paga, tipo)
VALUES (5, 'Futebol', 25.00, '2026-11-18', false, 4);
INSERT INTO Despesas (id, descricao, valor, data_Vencimento, paga, tipo)
VALUES (6, 'Skin Valorant', 55.00, '2026-11-17', false, 4);

-- UPDATE: marca o Açougue (id 1) como pago.
-- Sempre com WHERE na coluna que identifica só essa linha (o id).
UPDATE Despesas
SET paga = true
WHERE id = 1;

INSERT INTO tipo_Entrada (id, tipoen)
VALUES (1, 'Salario');
INSERT INTO tipo_Entrada (id, tipoen)
VALUES (2, 'Freelance');

INSERT INTO Entrada (id, descricao, valor, data, tipoen)
VALUES (1, 'Salario', 2000.00, '2026-11-01', 1);
INSERT INTO Entrada (id, descricao, valor, data, tipoen)
VALUES (2, 'Freela no UrsoRockBar', 150.00, '2026-11-01', 2);


-- ============================================================
-- 3. CONSULTAS
-- ============================================================

-- Despesas pendentes (ainda não pagas)
SELECT Despesas.descricao, Despesas.valor, Despesas.paga
FROM Despesas
WHERE paga = FALSE;

-- Total pendente (esperado: 201.22)
SELECT SUM(Despesas.valor)
FROM Despesas
WHERE paga = FALSE;

-- Total pago (esperado: 75.94)
SELECT SUM(Despesas.valor)
FROM Despesas
WHERE paga = TRUE;

-- Despesa com o NOME do tipo: JOIN liga a FK (Despesas.tipo) ao id do tipo
SELECT Despesas.descricao, Despesas.valor, tipo_Despesas.tipo
FROM Despesas
JOIN tipo_Despesas ON Despesas.tipo = tipo_Despesas.id;

-- Total de despesas por tipo: JOIN + GROUP BY (agrupa pelo nome do tipo)
SELECT tipo_Despesas.tipo, SUM(Despesas.valor)
FROM Despesas
JOIN tipo_Despesas ON Despesas.tipo = tipo_Despesas.id
GROUP BY tipo_Despesas.tipo;

-- Total de entradas (esperado: 2150)
SELECT SUM(Entrada.valor)
FROM Entrada;

-- Exemplo de DELETE (comentado de propósito, rode só se quiser apagar):
-- DELETE FROM Despesas
-- WHERE id = 7;


-- ============================================================
-- 4. SALDO
-- saldo atual = saldo inicial + entradas - despesas PAGAS
-- (despesa pendente ainda não tirou dinheiro da conta)
-- Esperado com os dados acima: 1000 + 2150 - 75.94 = 3074.06
-- ============================================================




SELECT 1000
           + (SELECT SUM(Entrada.valor) FROM Entrada)
           - (SELECT SUM(DESPESAS.VALOR) FROM Despesas  WHERE paga = 1 )
           AS saldo;

