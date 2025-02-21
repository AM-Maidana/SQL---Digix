--==================================================
--                  TRIGGERS
--                 19/02/2025
--==================================================
CREATE TABLE TRIGGERS.TIMES (
ID INTEGER PRIMARY KEY,
NOME VARCHAR(50)
);

CREATE TABLE TRIGGERS.PARTIDA (
ID INTEGER PRIMARY KEY,
TIMES_1 INTEGER,
TIMES_2 INTEGER,
TIMES_1_GOLS INTEGER,
TIMES_2_GOLS INTEGER,
FOREIGN KEY(TIMES_1) REFERENCES TIMES(ID),
FOREIGN KEY(TIMES_2) REFERENCES TIMES(ID)
);

INSERT INTO TRIGGERS.TIMES(ID, NOME) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');

INSERT INTO TRIGGERS.PARTIDA(ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);

-- As triggers são gatilhos automaticos que são executados antes ou depoiis de uma operação
-- de insert, update ou delete.

-- As triggers são muitos utilizadas para garantir a integridade dos dados
-- Quando as trigger são necessárias?
--1. Quando é necessario garantir a integridade dos dados
--2. Quando é necessario garantir a consistencia dos dados
--3. Para validar regras de negocio antes de inserir, atualixzar ou deletar dados
--4. Para automatixar tarefas que devam ser execitadas

-- Tabela de exemplo que registra os eventos antes das outeas
CREATE TABLE TRIGGERS.LOG_PARTIDA(
    ID SERIAL PRIMARY KEY,
    PARTIDA_ID INT,
    ACAO VARCHAR(20),
    DATA TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- o default é usado para pegar a data e a hora atual
);

-- criação de trigger com sintaxe MySql
--CREATE TRIGGER LOG_PARTIDA_INSERT
--AFTER INSERT ON PARTIDA -- after quer dizer que acontece depois da operação nas tabelas
--FOR EACH ROW -- para cada linha que dor inserida
--BEGIN
--    INSERT INTO TLOG_PARTIDA(ID, PARTIDA_ID, ACAO) VALUES (NEW.ID, NEW.PARTIDA_ID, 'INSERT'); -- new.id é o id da linha
--END;

--criação de trigger no postgres = cria a função e depois a trigger que chama 
-- a função
CREATE OR REPLACE FUNCTION TRIGGERS.LOG_PARTIDA_INSERT()
RETURNS TRIGGER AS $$ 
BEGIN
    INSERT INTO TRIGGERS.LOG_PARTIDA(PARTIDA_ID, ACAO) VALUES (NEW.ID, 'INSERT');
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;


CREATE TRIGGER LOG_PARTIDA_INSERT
AFTER INSERT ON TRIGGERS.PARTIDA
FOR EACH ROW
EXECUTE FUNCTION TRIGGERS.LOG_PARTIDA_INSERT();


-- TESTES!!!
-


SELECT * FROM TRIGGERS.PARTIDA;



SELECT * FROM TRIGGERS.LOG_PARTIDA;

-- crianfo Trigger de Restrição
CREATE OR REPLACE FUNCTION TRIGGERS.INSERT_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN   
    IF NEW.TIMES_1 = NEW.TIMES_2 THEN
        RAISE NOTICE 'NÃO É PERMITIDO JOGOS ENTRE O MESMO TIME';
    END IF;
    RETURN NEW; -- o return new pe para garantir que a operação continue normalmente e qnão seja interrompida
END;
$$ LANGUAGE PLPGSQL;

-- Aqui a gente cria a função que vai ser chamada pela trigger
 
 CREATE TRIGGER INSERT_PARTIDA
 BEFORE INSERT ON TRIGGERS.PARTIDA -- before quer dizer que acontece antes da operação nas tabelas
 FOR EACH ROW -- para cada linha que dor inserida
 EXECUTE FUNCTION TRIGGERS.INSERT_PARTIDA();

 -- TESTES!!

 INSERT INTO TRIGGERS.PARTIDA (ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS) VALUES (10, 1, 1, 1, 0);

SELECT * FROM TRIGGERS.PARTIDA;
-- O instead of nao é suportado pelo mysql porque ele não tem suporte para trigger de visão
-- O instead of é utilizado para fazer trigger em visões
-- No postgres a sintaxe é a mesma

-- exemplo de instead of no postgres que é o único que suporta
-- fazer um visão

CREATE VIEW TRIGGERS.PARTIDA_V AS
SELECT ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS FROM TRIGGERS.PARTIDA;
-- Agora queremos permitir inserções na partida_v, mas os dados reais devem
--ser armazenados na tabela partida. 
-- Para isso, usamos instead of
CREATE OR REPLACE FUNCTION TRIGGERS.INSERT_PARTIDA_V()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO TRIGGERS.PARTIDA(ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS) VALUES (NEW.ID, NEW.TIMES_1, NEW.TIMES_2, NEW.TIMES_1_GOLS, NEW.TIMES_2_GOLS);
    RETURN NULL; -- nao quero inserir na visão diretamente
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER INSERT_PARTIDA_V
INSTEAD OF INSERT ON TRIGGERS.PARTIDA_V -- aqui nós estamos dizendo que a rigger vai ser execurada no lugar de uma inserção na visão
FOR EACH ROW -- para cada linha que for inserida na visão
EXECUTE FUNCTION TRIGGERS.INSERT_PARTIDA_V();

-- TESTES!!
INSERT INTO TRIGGERS.PARTIDA_V (ID, TIMES_1, TIMES_2, TIMES_1_GOLS, TIMES_2_GOLS) VALUES (11,1,2,1,0);

-- update
CREATE OR REPLACE FUNCTION TRIGGERS.UPDATE_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LOG_PARTIDA(PARTIDA_ID, ACAO) VALUES (NEW.ID, 'UPDATE');
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER UPDATE_PARTIDA
AFTER UPDATE ON TRIGGERS.PARTIDA
FOR EACH ROW
EXECUTE FUNCTION UPDATE_PARTIDA();

-- TESTE
UPDATE TRIGGERS.PARTIDA SET TIMES_1_GOLS = 2 WHERE ID = 11;
SELECT * FROM LOG_PARTIDA();

-- fazer uma trigger que impessa de fazer update em partidaas que já foram finalizadas
CREATE OR REPLACE FUNCTION VALIDAR_UPDATE_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.TIMES_1_GOLS IS NOT NULL THEN
        RAISE EXCEPTION 'NÃO É PERMITIDO ALTERAR PARTIDAS FINALIZADAS';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGER VALIDAR_UPDATE_PARTIDA
BEFORE UPDATE ON TRIGGERS.PARTIDA
FOR EACH ROW
EXECUTE FUNCTION VALIDAR_UPDATE_PARTIDA();

-- DELETE
CREATE OR REPLACE FUNCTION TRIGGERS.DELETE_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN
    --INSERT INTO TRIGGERS.LOG_PARTIDA(PARTIDA_ID, ACAO) VALUES (OLD.ID, 'DELETE');
    --RETURN OLD;
    -- IMPEDIR DELETE
    RAISE EXCEPTION 'NÃO É PERMITIDO EXCLUIR PARTIDAS';
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER DELETE_PARTIDA
AFTER DELETE ON TRIGGERS.PARTIDA
FOR EACH ROW
EXECUTE FUNCTION DELETE_PARTIDA();

DELETE FROM TRIGGERS.PARTIDA WHERE ID = 11;