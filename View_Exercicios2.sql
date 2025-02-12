--===================================================
--                VIEW: Exercicios2
--              12/02/2025 - QUARTA-FEIRA
--===================================================
CREATE TABLE AULA12_02.TIMES (
ID INTEGER PRIMARY KEY,
NOME VARCHAR(50)
);

CREATE TABLE AULA12_02.PARTIDA (
ID INTEGER PRIMARY KEY,
TIMES_1 INTEGER,
TIMES_2 INTEGER,
TIMES_1_GOLS INTEGER,
TIMES_2_GOLS INTEGER,
FOREIGN KEY(TIMES_1) REFERENCES TIMES(ID),
FOREIGN KEY(TIMES_2) REFERENCES TIMES(ID)
);

INSERT INTO AULA12_02.TIMES(ID, NOME) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');

INSERT INTO AULA12_02.PARTIDA(ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);


--======================
-- EXERCICIOS
--======================
--1. Crie uma view vpartida que retorne a tabela partida adicionando as
--colunas nome_time_1 e nome_time_2 com o nome dos times
CREATE OR REPLACE VIEW VPARTIDA AS
SELECT P .*, T1.NOME AS NOME_TIME_1, T2.NOME AS NOME_TIME_2
FROM AULA12_02.PARTIDA P
LEFT JOIN AULA12_02.TIMES T1 ON P.TIMES_1 = T1.ID
LEFT JOIN AULA12_02.TIMES T2 ON P.TIMES_2 = T2.ID;

SELECT * FROM VPARTIDA
ORDER BY ID ASC;

--2. Realize uma consulra em vpartida que retorne somente os jogos times
-- que posssuem nome que começam com A ou C participaram
SELECT * FROM VPARTIDA
WHERE NOME_TIME_1 LIKE 'A%' OR NOME_TIME_1 LIKE 'C%'
AND NOME_TIME_2 LIKE 'A%' OR NOME_TIME_2 LIKE 'C%';

--3. Crie uma view, utilizando a view vpartida que retorne uma coluna
-- de classificação com o nome do ganhador da partida, ou a palavra "EMPATE"
-- em cado de empate
CREATE OR REPLACE VIEW CLASSIFICACAO AS
SELECT TIMES_1 AS TIME1, TIMES_2 AS TIME2, TIMES_1_GOLS, TIMES_2_GOLS,
       CASE 
            WHEN TIMES_1_GOLS > TIMES_2_GOLS THEN TIMES_1
            WHEN TIMES_2_GOLS > TIMES_1_GOLS THEN TIMES_2
            ELSE 'EMPATE'
       END AS RESULTADO
FROM VPARTIDA;

--4. Crie uma view vtime que retorne a tabela de time adicionando as 
--colunas partidas, vitorias, derrotas, empates e pontos
CREATE VIEW VTIMES AS
SELECT 
    T.ID, 
    T.NOME,

    -- Contagem de partidas jogadas
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_1 = T.ID) +
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_2 = T.ID) AS PARTIDAS,

    -- Contagem de vitórias
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_2_GOLS > TIMES_1_GOLS AND TIMES_2 = T.ID) +
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_1_GOLS > TIMES_2_GOLS AND TIMES_1 = T.ID) AS VITORIAS,

    -- Contagem de empates
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_2_GOLS = TIMES_1_GOLS AND TIMES_2 = T.ID) +
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_1_GOLS = TIMES_2_GOLS AND TIMES_1 = T.ID) AS EMPATES,

    -- Contagem de derrotas
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_2_GOLS < TIMES_1_GOLS AND TIMES_2 = T.ID) +
    (SELECT COUNT(*) FROM AULA12_02.PARTIDA WHERE TIMES_1_GOLS < TIMES_2_GOLS AND TIMES_1 = T.ID) AS DERROTAS,

    -- Cálculo dos pontos (3 por vitória, 1 por empate)
    (SELECT SUM(CASE 
                    WHEN TIMES_2_GOLS > TIMES_1_GOLS THEN 3 
                    WHEN TIMES_2_GOLS = TIMES_1_GOLS THEN 1 
                    ELSE 0 
                END) 
     FROM AULA12_02.PARTIDA WHERE TIMES_2 = T.ID) +
    
    (SELECT SUM(CASE 
                    WHEN TIMES_1_GOLS > TIMES_2_GOLS THEN 3 
                    WHEN TIMES_1_GOLS = TIMES_2_GOLS THEN 1 
                    ELSE 0 
                END) 
     FROM PARTIDA WHERE TIMES_1 = T.ID) AS PONTOS

FROM TIMES T
ORDER BY PONTOS DESC;

SELECT * FROM VTIMES;

--5. Realize uma consulta na view vpartida_classificação

SELECT * FROM CLASSIFICACAO;

--6. Apague a view vpartida
DROP VIEW VPARTIDA;



