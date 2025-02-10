--==================================================
--              EXERCÍCIOS - VIEW
--                  AULA 05
--==================================================

-- DICA: Quando for muitos -- cria uma tabela de relacionamento
-- quando for de 1 p/ 1 cria na tabela mesmo

CREATE TABLE PESSOA (
    ID_PESSOA INT AUTO_INCREMENT PRIMARY KEY, 
    NOME VARCHAR(200),
    CPF VARCHAR(11)
);

CREATE TABLE UNIDADE_RESIDENCIAL (
    ID_UR INT AUTO_INCREMENT PRIMARY KEY,
    METRAGEM_UNIDADE FLOAT,
    NUM_QUARTOS INT,
    NUM_BANHEIROS INT
);

CREATE TABLE EX_VIEWS.PESSOA_UNIDADE (
    ID_PESSOA_UNIDADE INT AUTO_INCREMENT PRIMARY KEY,
    FK_PESSOA INT,
    FK_UNIDADE INT,
    CONSTRAINT FK_PESSOA FOREIGN KEY (FK_PESSOA) REFERENCES EX_VIEWS.PESSOA(ID_PESSOA),
    CONSTRAINT FK_UNIDADE FOREIGN KEY (FK_UNIDADE) REFERENCES EX_VIEWS.UNIDADE_RESIDENCIAL(ID_UR)
);

CREATE TABLE EX_VIEWS.ENGENHEIRO (
    ID_ENG INT AUTO_INCREMENT PRIMARY KEY,
    CREA INT, 
    FK_PESSOA INT,
    CONSTRAINT FK_ENG_PESSOA FOREIGN KEY (FK_PESSOA) REFERENCES EX_VIEWS.PESSOA(ID_PESSOA)
);

CREATE TABLE EX_VIEWS.EDIFICACAO (
    ID_EDIF INT AUTO_INCREMENT PRIMARY KEY,
    METRAGEM_TOTAL FLOAT,
    FK_UR INT,
    CONSTRAINT FK_UR FOREIGN KEY (FK_UR) REFERENCES EX_VIEWS.UNIDADE_RESIDENCIAL(ID_UR)
);

CREATE TABLE EX_VIEWS.PROJETO (
    ID_PROJETO INT AUTO_INCREMENT PRIMARY KEY,
    FK_ENGENHEIRO INT,
    CONSTRAINT FK_ENGENHEIRO FOREIGN KEY (FK_ENGENHEIRO) REFERENCES EX_VIEWS.ENGENHEIRO(ID_ENG),
    FK_EDIFICACAO INT,
    CONSTRAINT FK_EDIFICACAO FOREIGN KEY (FK_EDIFICACAO) REFERENCES EX_VIEWS.EDIFICACAO(ID_EDIF)
);

CREATE TABLE EX_VIEWS.PREDIO (
    ID_PREDIO INT AUTO_INCREMENT PRIMARY KEY,
    NOME_PREDIO VARCHAR(200),
    NUM_ANDARES INT,
    APTOS_ANDAR INT,
    FK_EDIFICACAO INT,
    CONSTRAINT FK_PREDIO_EDIFICACAO FOREIGN KEY (FK_EDIFICACAO) REFERENCES EX_VIEWS.EDIFICACAO(ID_EDIF)
);

CREATE TABLE EX_VIEWS.CASA (
    ID_CASA INT AUTO_INCREMENT PRIMARY KEY,
    CONDOMINIO BOOLEAN,
    NUM_ANDARES INT,
    FK_EDIFICACAO INT,
    CONSTRAINT FK_CASA_EDIFICACAO FOREIGN KEY (FK_EDIFICACAO) REFERENCES EX_VIEWS.EDIFICACAO(ID_EDIF)
);

---=============
-- Inserindo dados nas tabelas
--=============

INSERT INTO EX_VIEWS.PESSOA (NOME, CPF) VALUES
('João Silva', '12345678901'),
('Maria Oliveira', '23456789012'),
('Carlos Souza', '34567890123'),
('Ana Lima', '45678901234'),
('Pedro Santos', '56789012345'),
('Mariana Costa', '67890123456'),
('Lucas Almeida', '78901234567'),
('Juliana Rocha', '89012345678'),
('Fernando Mendes', '90123456789'),

('Beatriz Ribeiro', '01234567890');

INSERT INTO EX_VIEWS.UNIDADE_RESIDENCIAL (METRAGEM_UNIDADE, NUM_QUARTOS, NUM_BANHEIROS) VALUES
(80.5, 2, 1),
(100.0, 3, 2),
(75.0, 2, 1),
(120.0, 4, 3),
(95.0, 3, 2),
(110.0, 3, 2);

INSERT INTO EX_VIEWS.PESSOA_UNIDADE (FK_PESSOA, FK_UNIDADE) VALUES
(1, 1), (2, 1),  -- João e Maria moram na mesma unidade
(3, 2), (4, 2),  -- Carlos e Ana moram na mesma unidade
(5, 3),          -- Pedro mora sozinho na unidade 3
(6, 4), (7, 4),  -- Mariana e Lucas na unidade 4
(8, 5), (9, 5),  -- Juliana e Fernando na unidade 5
(10, 6);         -- Beatriz mora sozinha na unidade 6

INSERT INTO EX_VIEWS.ENGENHEIRO (CREA, FK_PESSOA) VALUES
(123456, 1),  -- João Silva é engenheiro
(234567, 3),  -- Carlos Souza é engenheiro
(345678, 6),  -- Mariana Costa é engenheira
(456789, 9);  -- Fernando Mendes é engenheiro

INSERT INTO EX_VIEWS.EDIFICACAO (METRAGEM_TOTAL, FK_UR) VALUES
(500.0, 1),  -- Edificação 1 para a unidade 1
(600.0, 2),  -- Edificação 2 para a unidade 2
(700.0, 3),  -- Edificação 3 para a unidade 3
(800.0, 4),  -- Edificação 4 para a unidade 4
(650.0, 5),  -- Edificação 5 para a unidade 5
(750.0, 6);  -- Edificação 6 para a unidade 6

INSERT INTO EX_VIEWS.PROJETO (FK_ENGENHEIRO, FK_EDIFICACAO) VALUES
(1, 1),  -- João Silva no projeto 1
(2, 2),  -- Carlos Souza no projeto 2
(3, 3),  -- Mariana Costa no projeto 3
(4, 4),  -- Fernando Mendes no projeto 4
(1, 5),  -- João Silva no projeto 5
(2, 5),  -- Mariana Costa no projeto 5
(3, 6),  -- Carlos Souza no projeto 6
(4, 6),  -- João Silva no projeto 6
(1, 3),  -- João Silva no projeto 7
(2, 2),  -- Carlos Souza no projeto 7
(3, 1);  -- Mariana Costa no projeto 7

INSERT INTO EX_VIEWS.PREDIO (NOME_PREDIO, NUM_ANDARES, APTOS_ANDAR, FK_EDIFICACAO) VALUES
('Prédio A', 10, 4, 1),  -- Prédio A com 10 andares e 4 apartamentos por andar
('Prédio B', 12, 5, 2),  -- Prédio B com 12 andares e 5 apartamentos por andar
('Prédio C', 15, 6, 3),  -- Prédio C com 15 andares e 6 apartamentos por andar
('Prédio D', 8, 3, 4);   -- Prédio D com 8 andares e 3 apartamentos por andar

INSERT INTO EX_VIEWS.CASA (CONDOMINIO, NUM_ANDARES, FK_EDIFICACAO) VALUES
(TRUE, 2, 5),  -- Casa no condomínio com 2 andares
(FALSE, 1, 6),  -- Casa sem condomínio e 1 andar
(TRUE, 3, 5),   -- Casa no condomínio com 3 andares (ID 5 para casa)
(FALSE, 2, 6),  -- Casa sem condomínio e 2 andares (ID 6 para casa)
(TRUE, 1, 4);   -- Casa no condomínio com 1 andar (ID 4 para casa)

SELECT * FROM PESSOA;
SELECT * FROM UNIDADE_RESIDENCIAL;
SELECT * FROM PESSOA_UNIDADE;
SELECT * FROM ENGENHEIRO;
SELECT * FROM EDIFICACAO;
SELECT * FROM PROJETO;
SELECT * FROM PREDIO;
SELECT * FROM EX_VIEWS.CASA;

-- 1) Listar todas as unidades residenciais, com seus proprietários e engenheiros responsáveis
SELECT DISTINCT * FROM UNIDADE_RESIDENCIAL UR
JOIN PESSOA_UNIDADE PU ON UR.ID_UR = PU.FK_UNIDADE
JOIN PROJETO PJ ON PJ.FK_ENGENHEIRO = UR.ID_UR;

-- 2) Listar todas as unidades residenciais, com proprietários
--e engenheiros, ordenando por metragem total da edificação;
SELECT DISTINCT * FROM UNIDADE_RESIDENCIAL UR
JOIN PESSOA_UNIDADE PU ON UR.ID_UR = PU.FK_UNIDADE
JOIN PROJETO PJ ON PJ.FK_ENGENHEIRO = UR.ID_UR
GROUP BY UR.METRAGEM_TOTAL DESC; -- NAO FUNCIONOU