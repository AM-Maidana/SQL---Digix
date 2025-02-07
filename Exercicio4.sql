--===================================================================
--                    EXERCICIOS LISTA 3
--                  07/02/2025 - SEXTA-FEIRA
--
--===================================================================
CREATE TABLE INSTUTOR (
    ID_INSTRUTOR INT PRIMARY KEY NOT NULL,
    NOME_INSTRUTOR VARCHAR(50),
    RG INT,
    DATA_NASCIMENTO_INSTRUTOR DATE,
    TITULACAO INT
);
CREATE TABLE TELINSTRUTOR (
    ID_TELEFONE INT PRIMARY KEY NOT NULL,
    NUMERO VARCHAR(20),
    TIPO VARCHAR(45),
    FK_IDINSTRUTOR INT,
    CONSTRAINT FK_TELIDINSTRUTOR_INSTRUTOR FOREIGN KEY (FK_IDINSTRUTOR) REFERENCES INSTUTOR(ID_INSTRUTOR)
);

CREATE TABLE ATIVIDADE (
    ID_ATIVIDADE INT PRIMARY KEY NOT NULL,
    NOME_ATIVIDADE VARCHAR(50)
);

CREATE TABLE TURMA (
    ID_TURMA INT PRIMARY KEY NOT NULL,
    HORARIO_TURMA TIME,
    DATA_INICIO DATE,
    DATA_FINAL DATE,
    DURACAO INT,
    FK_ATIVIDADE INT,
    FK_INSTRUTOR INT,
    CONSTRAINT FK_TURMA_ATIVIDADE FOREIGN KEY (FK_ATIVIDADE) REFERENCES ATIVIDADE(ID_ATIVIDADE),
    CONSTRAINT FK_TURMA_INSTRUTOR FOREIGN KEY (FK_INSTRUTOR) REFERENCES INSTUTOR(ID_INSTRUTOR)
);
CREATE TABLE ALUNO (
    ID_MATRICULA INT PRIMARY KEY NOT NULL,
    FK_TURMA INT,
    CONSTRAINT FK_ALUNO_TURMA FOREIGN KEY (FK_TURMA) REFERENCES TURMA(ID_TURMA),
    DATA_MATRICULA DATE,
    NOME VARCHAR(50),
    ENDERECO TEXT,
    TELEFONE VARCHAR(20),
    DATA_NASCIMENTO_ALUNO DATE,
    ALTURA FLOAT,
    PESO INT
);
CREATE TABLE CHAMADA (
    ID_CHAMADA INT PRIMARY KEY NOT NULL,
    FK_TURMA INT,
    CONSTRAINT FK_CHAMADA_TURMA FOREIGN KEY (FK_TURMA) REFERENCES TURMA(ID_TURMA),
    FK_ALUNO INT,
    CONSTRAINT FK_CHAMADA_ALUNO FOREIGN KEY (FK_ALUNO) REFERENCES ALUNO(ID_MATRICULA),
    DATA_CHAMADA DATE,
    PRESENCA BOOL
);

SELECT * FROM INSTUTOR;
SELECT * FROM TELINSTRUTOR;
SELECT * FROM ATIVIDADE;
SELECT * FROM TURMA;
SELECT * FROM ALUNO;
SELECT * FROM CHAMADA;

--------------------------------------
-- INSERÇÃO DE DADOS NAS TABELAS
--------------------------------------


INSERT INTO INSTUTOR (ID_INSTRUTOR, NOME_INSTRUTOR, RG, DATA_NASCIMENTO_INSTRUTOR, TITULACAO)
VALUES 
(1, 'CAIO', 123, '2003-07-11', 1),
(2, 'AMANDA', 234, '1997-01-04', 1),
(3, 'FABIANA', 345, '1997-04-08', 2),
(4, 'ALEXANDRE', 456, '1988-02-09', 1),
(5, 'CÉSAR', 567, '2000-12-15', 2),
(6, 'LUCAS', 678, '2000-01-01', 3),
(7, 'TERESA', 789, '1999-09-09', 4),
(8, 'MALCOM', 890, '1992-07-22', 3);

INSERT INTO TELINSTRUTOR (ID_TELEFONE, NUMERO, TIPO, FK_IDINSTRUTOR)
VALUES
(1, '99254-1800', 'CELULAR', 1),
(2, '3042-8589', 'FIXO', 2),
(3, '99225-4422', 'CELULAR', 3),
(4, '3022-3318', 'FIXO', 4),
(5, '99698-4452', 'CELULAR', 5),
(6, '3002-8922', 'COMERCIAL', 6),
(7, '99219-1919', 'CELULAR', 7),
(8, '3030-0800', 'FIXO', 8);

INSERT INTO ATIVIDADE (ID_ATIVIDADE, NOME_ATIVIDADE)
VALUES
(1, 'CROSS FTI'),
(2, 'CROCHÊ'),
(3, 'YOGA'),
(4, 'PINTURA'),
(5, 'CERÂMICA');

INSERT INTO TURMA (ID_TURMA, HORARIO_TURMA, DATA_INICIO, DATA_FINAL, DURACAO, FK_ATIVIDADE, FK_INSTRUTOR)
VALUES
(1, '18:00:00', '2025-02-20', '2025-06-20', 4, 1, 1),
(2, '09:00:00', '2025-01-10', '2025-07-10', 3, 2, 2),
(3, '14:00:00', '2025-03-01', '2025-12-20', 2, 3, 3),
(4, '17:00:00', '2025-03-01', '2025-05-20', 2, 4, 4),
(5, '17:00:00', '2025-01-15', '2025-05-15', 4, 1, 5);

INSERT INTO ALUNO (ID_MATRICULA, FK_TURMA, DATA_MATRICULA, NOME, ENDERECO, TELEFONE, DATA_NASCIMENTO_ALUNO, ALTURA, PESO)
VALUES
(1, 2, '2025-01-07', 'Samantha Santos', 'R. Espada de S. Jorge, 512 - Bairro Salve Jorge', '99258-1177', '2000-07-11', 1.69, 55),
(2, 1, '2025-02-02', 'Carlos Cargueiro', 'Av. Atlântica, 1000 - Bairro Copacabana', '99955-1111', '1995-11-25', 1.90, 90),
(3, 3, '2025-01-07', 'Bianca Bin', 'R. das Palmeiras, 320 - Bairro Jardim das Flores', '98132-1515', '2004-10-02', 1.55, 45),
(4, 1, '2025-01-07', 'Lucas Silva', 'R. São João, 54 - Bairro Centro', '98876-5432', '1998-06-15', 1.72, 68),
(5, 4, '2025-01-07', 'Juliana Costa', 'R. Lagoa Azul, 15 - Bairro Lagoa', '97765-4321', '2001-12-03', 1.63, 50),
(6, 4, '2025-01-07', 'Renato Souza', 'R. Independência, 100 - Bairro Independente', '96654-3210', '1999-02-19', 1.78, 80),
(7, 5, '2025-01-07', 'Amanda Pereira', 'R. dos Jacarandás, 240 - Bairro Jardim Tropical', '95543-2109', '2000-09-10', 1.65, 60),
(8, 3, '2025-01-07', 'Gustavo Oliveira', 'R. dos Cedros, 88 - Bairro Serrano', '94432-1098', '2003-04-25', 1.82, 85),
(9, 3, '2025-01-07', 'Mariana Rocha', 'R. das Flores, 77 - Bairro Jardim das Rosas', '93321-9876', '1997-08-30', 1.70, 62),
(10, 4, '2025-01-07', 'Rafael Alves', 'R. Caminho Verde, 112 - Bairro Verde Vale', '92210-8765', '2002-11-10', 1.75, 78),
(11, 5, '2025-01-07', 'Fernanda Lima', 'R. Rio Branco, 89 - Bairro Imperial', '91109-7654', '2001-01-01', 1.68, 58),
(12, 1, '2025-01-07', 'Thiago Martins', 'R. Sol Nascente, 33 - Bairro Nascente', '90098-6543', '2000-05-14', 1.77, 70);

INSERT INTO CHAMADA (ID_CHAMADA, FK_TURMA, FK_ALUNO, DATA_CHAMADA, PRESENCA)
VALUES
(1, 1, 2, '2025-02-20', 1),
(2, 1, 4, '2025-02-20', 1),
(3, 1, 12, '2025-02-20', 0),
(4, 2, 1, '2025-01-10', 1),
(5, 3, 3, '2025-03-01', 1),
(6, 3, 8, '2025-03-01', 0),
(7, 3, 9, '2025-03-01', 1),
(8, 4, 5, '2025-03-01', 1),
(9, 4, 6, '2025-03-01', 0),
(10, 4, 10, '2025-03-01', 1),
(11, 5, 7, '2025-01-15', 1),
(12, 5, 11, '2025-01-15', 0);

CREATE TABLE MATRICULADO (
    FK_ALUNO INT,
    CONSTRAINT FK_MATRICULADO_ALUNO FOREIGN KEY (FK_ALUNO) REFERENCES ALUNO(ID_MATRICULA),
    FK_TURMA INT,
    CONSTRAINT FK_MATRICULADO_TURMA FOREIGN KEY (FK_TURMA) REFERENCES TURMA(ID_TURMA)
    );

INSERT INTO MATRICULADO (FK_ALUNO, FK_TURMA)
VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 1),
(5, 4),
(6, 4),
(7, 5),
(8, 3),
(9, 3),
(10, 4),
(11, 5),
(12, 1);
--=========================================================
--              EXERCICIOS
--=========================================================


--1️. Listar todos os alunos e os nomes das turmas em que estão matriculados
--SELECT AL.NOME, ATI.NOME FROM ALUNO AL JOIN MATRICULADO MA ON AL.ID_MATRICULA = MA.FK_ATIVIDADE JOIN ATIVIDADE ATI
ON MA.FK_TURMA = T.ID_TURMA;(Usa JOIN para relacionar as tabelas aluno, matricula e turma.)



SELECT u.nome, m.velocidade FROM users u JOIN users_maquinas um ON u.id = um.fk_users 
JOIN maquinas m ON um.fk_maquinas = m.id WHERE m.velocidade > 0;

--2️. Contar quantos alunos estão matriculados em cada turma
--( Usa GROUP BY e COUNT() para contar os alunos por turma.)
--3️. Mostrar a média de idade dos alunos em cada turma
--Usa AVG() e DATEDIFF() para calcular a idade média dos alunos.
SELECT NOME, ROUND(AVG(EXTRACT(YEAR FROM AGE(DATA_NASCIMENTO_ALUNO))), 2) AS IDADE
FROM ALUNO GROUP BY NOME;

--4️. Encontrar as turmas com mais de 3️ alunos matriculados
--(Usa HAVING para filtrar apenas as turmas com mais de 3 alunos.)
--5️. Exibir os instrutores que orientam turmas e os que ainda não possuem turmas
--6️. Encontrar alunos que frequentaram todas as aulas de sua turma
--( Usa COUNT() para comparar a quantidade de presenças com a quantidade de aulas.)
SELECT AL.NOME AS ALUNO, T.ID_TURMA AS TURMA
FROM ALUNO AL
JOIN CHAMADA C ON AL.ID_MATRICULA = C.FK_ALUNO
JOIN TURMA T ON C.FK_TURMA = T.ID_TURMA
GROUP BY AL.ID_MATRICULA, T.ID_TURMA

HAVING COUNT(CASE WHEN C.PRESENCA = TRUE THEN 1 END) =
(SELECT COUNT(*) FROM CHAMADA C2 WHERE C2.FK_TURMA = T.ID_TURMA);
--7️. Mostrar os instrutores que ministram turmas de "Crossfit" ou "Yoga"
--(Usa JOIN e WHERE para filtrar turmas com atividades específicas.)

--8️. Listar os alunos que estão matriculados em mais de uma turma
--(Usa HAVING COUNT() > 1️ para encontrar alunos matriculados em mais de uma
--turma.)
--9️. Encontrar as turmas que possuem a maior quantidade de alunos
--(Usa ORDER BY e LIMIT para exibir apenas as turmas com mais alunos.)
--10. Listar os alunos que não compareceram a nenhuma aula
--(Usa NOT IN para encontrar alunos sem registros na tabela chamada.)