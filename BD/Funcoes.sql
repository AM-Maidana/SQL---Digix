--========================================
--              FUNÇÕES
--              14/02/2025
--========================================
-- Estamos utilizando o postgres devido algumas funções que ele tem.
CREATE TABLE TIMES (
ID INTEGER PRIMARY KEY,
NOME VARCHAR(50)
);

CREATE TABLE PARTIDA (
ID INTEGER PRIMARY KEY,
TIMES_1 INTEGER,
TIMES_2 INTEGER,
TIMES_1_GOLS INTEGER,
TIMES_2_GOLS INTEGER,
FOREIGN KEY(TIMES_1) REFERENCES TIMES(ID),
FOREIGN KEY(TIMES_2) REFERENCES TIMES(ID)
);

INSERT INTO TIMES(ID, NOME) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');

INSERT INTO PARTIDA(ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);

-- Tabela Temporaria, elas são para dados temporarios, e que são de unica sessão de banco de dado
CREATE TEMP TABLE TEMP_TIME AS SELECT * FROM TIMES;

SELECT * FROM TEMP_TIME;


-- Operações nas funções no Postgress
--1. ceia variceis dentro da dunção e imporiimir
CREATE OR REPLACE FUNCTION OPERACAO_FUNCAO()
RETURNS VOID AS $$ 
DECLARE
    VAR_ID INTEGER;
    V_NOME VARCHAR(50);
BEGIN
    -- Atribuindo valores
    VAR_ID := 1;
    V_NOME := 'TESTE';

    -- Exibindo valores
    RAISE NOTICE 'ID: %, NOME: %', VAR_ID, V_NOME;

    -- OPERAÇÕES MATEMÁTICAS
    VAR_ID := VAR_ID + 1;
    RAISE NOTICE 'SOMA: %', 1 + 1;
    RAISE NOTICE 'SUBTRAÇÃO: %', 1 - 1;
    RAISE NOTICE 'MULTIPLICAÇÃO: %', 1 * 1;
    RAISE NOTICE 'DIVISÃO: %', 1 / 1;

    -- OPERAÇÕES DE COMPARAÇÃO
    RAISE NOTICE 'IGUAL: %', 1 = 1;
    RAISE NOTICE 'DIFERENTE: %', 1 <> 1;
    RAISE NOTICE 'MAIOR: %', 1 > 1;
    RAISE NOTICE 'MENOR: %', 1 < 1;
    RAISE NOTICE 'MAIOR OU IGUAL: %', 1 >= 1;
    RAISE NOTICE 'MENOR OU IGUAL: %', 1 <= 1;

    -- OPERAÇÕES LÓGICAS
    RAISE NOTICE 'E (AND): %', TRUE AND TRUE;
    RAISE NOTICE 'OU (OR): %', TRUE OR FALSE;
    RAISE NOTICE 'NÃO (NOT): %', NOT TRUE;

    -- MANIPULAÇÃO DE STRING
    RAISE NOTICE 'TAMANHO DA STRING: %', LENGTH('TESTE');
    RAISE NOTICE 'SUBSTITUIR: %', REPLACE('TESTE', 'T', 'X');
    RAISE NOTICE 'POSIÇÃO: %', POSITION('T' IN 'TESTE');
    RAISE NOTICE 'SUBSTRING: %', SUBSTRING('TESTE' FROM 1 FOR 2);
    RAISE NOTICE 'MAIÚSCULA: %', UPPER('teste');
    RAISE NOTICE 'MINÚSCULA: %', LOWER('TESTE');

    -- CONCATENAÇÃO DE STRINGS
    RAISE NOTICE 'CONCATENAR: %', 'TESTE' || ' TESTE 1';

    -- MANIPULAÇÃO DE DATA E HORA
    RAISE NOTICE 'DATA ATUAL: %', NOW();
    RAISE NOTICE 'DATA ATUAL: %', CURRENT_DATE;
    RAISE NOTICE 'HORA ATUAL: %', CURRENT_TIME;

    -- MANIPULAÇÃO DE ARRAY
    RAISE NOTICE 'ARRAY: %', ARRAY[1,2,3]; 
    RAISE NOTICE 'ARRAY: %', ARRAY['AULA', 'TESTE'];
    -- RAISE NOTICE 'ARRAY: %', ARRAY['AULA', 1, TRUE]; -- NÃO É POSSÍVEL TIPOS DIFERENTES

    -- MANIPULAÇÃO DE JSON
    RAISE NOTICE 'JSON: %', '{"nome": "TESTE"}'::json;
END;
$$ LANGUAGE PLPGSQL;

-- EXECUTANDO A FUNÇÃO
SELECT OPERACAO_FUNCAO();

-- 2.Criar uma função que recebe parametros e retorna um valor
CREATE OR REPLACE FUNCTION OBTER_NOME_TIME(P_ID INTEGER) RETURNS
VARCHAR AS $$
DECLARE
    V_NOME VARCHAR(50);
BEGIN
    SELECT NOME INTO V_NOME FROM TIMES WHERE ID = P_ID;
    RETURN V_NOME;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_NOME_TIME(1);

-- 3. Criar uma função com loops
CREATE OR REPLACE FUNCTION OBTER_TIMES() RETURNS SETOF TIME AS $$ -- SETOF É PRA RETORNAR UMA TABELA
DECLARE
    I INT := 1;
BEGIN   
    LOOP -- É EQUIVALENTE AO WHILE
        EXIT WHEN I > 5; -- EXIT É QUANDO A CONDIÇÃO FOR VERDADEIRA
        RAISE NOTICE 'VALOR DE I: %', I;
        I :=I+1;
    END LOOP;
    END;
$$ LANGUAGE PLPGSQL;
-- outra forma de fazer é usando o for
CREATE OR REPLACE FUNCTION OBTER_TIMES() RETURNS SETOF TIME AS $$ -- SETOF É PRA RETORNAR UMA TABELA
DECLARE
    I INT := 1;
BEGIN   
    FOR I IN 1..5 LOOP -- A gente coloca os 2 pontos para indicar o intervalo, e inicio e o fim
        RAISE NOTICE 'VALOR DE I: %', I;
        I :=I+1;


    WHILE I <=5 LOOP
        RAISE NOTICE 'VALOR DE I: %', I;
        I :=I+1;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM OBTER_TIMES();

-- 4. Criar uma função que percorre uma tabela usando Return Next
CREATE OR REPLACE FUNCTION OBTER_TIMES_DADOS() RETURNS SETOF TIME AS $$
DECLARE
    V_TIME TIMES%ROWTYPE;
BEGIN
    FOR V_TIME IN SELECT * FROM TIMES LOOP -- Aqui estamos percorrendo todos os registros da tabela 
        RETURN NEXT V_TIME; -- return next é para retornar o valor da variavel
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM OBTER_TIMES_DADOS();

-- 5. Função que trabalha condições
CREATE OR REPLACE FUNCTION GOLS() RETURNS SETOF TIME AS $$
DECLARE
    V_GOLS INTEGER;
BEGIN
    SELECT TIMES_1_GOLS INTO V_GOLS FROM PARTIDA WHERE ID = 1;
    IF V_GOLS > 2 THEN
        RAISE NOTICE 'TIME MARCOU MAIS DE 2 GOLS';
    ELSE
        RAISE NOTICE 'TIME MARCOU MENOS DE 2 GOLS';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM GOLS();

-- ou com o case
CREATE OR REPLACE FUNCTION GOLS() RETURNS SETOF TIME AS $$
DECLARE
    V_GOLS INTEGER;
BEGIN
    SELECT TIMES_1_GOLS INTO V_GOLS FROM PARTIDA WHERE ID = 1;
    CASE 
        WHEN V_GOLS > 2 THEN
            RAISE NOTICE 'TIME MARCOU MAIS DE 2 GOLS';
        ELSE
            RAISE NOTICE 'TIME MARCOU MENOS DE 2 GOLS';
    END CASE;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM GOLS();

--6. Função que trata Exceções
CREATE OR REPLACE FUNCTION OBTER_NOME_TIME_EXCECAO (ID_TIME INTEGER) RETURNS VARCHAR AS $$
DECLARE
    V_NOME VARCHAR(50);
BEGIN
    SELECT NOME INTO V_NOME FROM TIMES WHERE ID = ID_TIME;
    RETURN V_NOME;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RAISE NOTICE 'TIME NÃO ENCONTRADO';
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_NOME_TIME_EXCECAO(6);