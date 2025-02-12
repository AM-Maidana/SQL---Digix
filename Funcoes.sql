--=======================================
--         EXEMPLOS PRÁTICOS
--
--=======================================


-- ===== Funções definidas pelo usuário ====
create function --→ Cria uma função personalizada
--ex: 
--CREATE FUNCTION nome_da_funcao (nome da variavel e o tipo dela) RETURNS tipo_de_retorno 
--BEGIN instruções 
--END

--ex: CREATE FUNCTION nome_da_funcao (nome da variavel e o tipo dela) RETURNS tipo_de_retorno 
-- DETERMINISTIC BEGIN instruções -- é uma clausula opcional que indica que a função retorna o mesmo resultado para os mesmos argumentos de entrada
--END

CREATE FUNCTION SOMA (a INT, b INT) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END

SELECT SOMA (10, 20); -- chama a função

-- OPERAÇÃO DE INSERT NAS FUNÇÕES
CREATE OR REPLACE FUNCTION INSERE_ALUNO (NOME VARCHAR(50), ENDERECO TEXT, TELEFONE VARCHAR(20), DATA_NASCIMENTO DATE, ALTURA FLOAT, PESO INT) RETURNS VOID AS
BEGIN
    INSERT INTO EX_VIEWS.ALUNO (FK_TURMA, DATA_MATRICULA, NOME, ENDERECO, TELEFONE, DATA_NASCIMENTO_ALUNO, ALTURA, PESO)
END

-- Chamado
SELECT INSERE_ALUNO(1, '2025-02-12', 'JOAO', 'RUA 1', '999999999', '2000-01-01', 1.80, 80);


-- FUNÇÃO DE CONSULTA
CREATE OR REPLACE FUNCTION CONSULTA_TIME() RETURNS TIMES AS
BEGIN
    RETURN QUERY SELECT * FROM TIMES;
END

-- Função com variável interna
--postgres
CREATE OR REPLACE FUNCTION CONSULTA_VENCEDOR_POR_TIME (ID_TIME INT) RETURNS VARCHAR(50) AS $$
DECLARE
    VENCEDOR VARCHAR(50);
BEGIN 
    SELECT CASE
        WHEN TIMES_1_GOLS > TIMES_2_GOLS THEN (SELECT NOME FROM TIMES WHERE ID = TIME_1)
        WHEN TIMES_1_GOLS < TIMES_2_GOLS THEN (SELECT NOME FROM TIMES WHERE ID = TIME_2)
            ELSE 'EMPATE'
        END INTO VENCEDOR
        FROM PARTIDA
        WHERE TIMES_1 = ID_TIME OR TIMES_2 = ID_TIME;
        RETURN VENCEDOR;
    END;
$$ LANGUAGE PLPGSQL;