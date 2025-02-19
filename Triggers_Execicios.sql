--=========================================================
--              TRIGGERS - EXERCICIOS
--                  19/02/2025
--=========================================================

CREATE TABLE TRIGGERS.MAQUINA (
ID_MAQUINA INT PRIMARY KEY NOT NULL,
TIPO VARCHAR(255),
VELOCIDADE INT,
HARDDISK INT,
PLACA_REDE INT,
MEMORIA_RAM INT,
FK_USUARIO INT,
FOREIGN KEY(FK_USUARIO) REFERENCES TRIGGERS.USUARIOS(ID_USUARIO)
);

CREATE TABLE TRIGGERS.USUARIOS (
ID_USUARIO INT PRIMARY KEY NOT NULL,
PASSWORD VARCHAR(255),
NOME_USUARIO VARCHAR(255),
RAMAL INT,
ESPECIALIDADE VARCHAR(255)
);

CREATE TABLE TRIGGERS.SOFTWARE (
ID_SOFTWARE INT PRIMARY KEY NOT NULL,
PRODUTO VARCHAR(255),
HARDDISK INT,
MEMORIA_RAM INT,
FK_MAQUINA INT,
FOREIGN KEY(FK_MAQUINA) REFERENCES TRIGGERS.MAQUINA(ID_MAQUINA)
);
--===========================================
-- INSERINDO OS DADOS
INSERT INTO TRIGGERS.MAQUINA VALUES (1, 'DESKTOP', 2, 500, 1, 4, 1);
INSERT INTO TRIGGERS.MAQUINA VALUES (2, 'NOTEBOOK', 1, 250, 1, 2, 2);
INSERT INTO TRIGGERS.MAQUINA VALUES (3, 'DESKTOP', 3, 1000, 1, 8, 3);
INSERT INTO TRIGGERS.MAQUINA VALUES (4, 'NOTEBOOK', 2, 500, 1, 4, 4);

INSERT INTO TRIGGERS.USUARIOS VALUES (1, '123', 'JOAO', 123, 'TI');
INSERT INTO TRIGGERS.USUARIOS VALUES (2, '456', 'MARIA', 456, 'RH');
INSERT INTO TRIGGERS.USUARIOS VALUES (3, '789', 'JOSE', 789, 'FINANCEIRO');
INSERT INTO TRIGGERS.USUARIOS VALUES (4, '101', 'ANA', 101, 'TI');

INSERT INTO TRIGGERS.SOFTWARE VALUES (1, 'WINDOWS', 100, 2, 1);
INSERT INTO TRIGGERS.SOFTWARE VALUES (2, 'LINUX', 50, 1, 2);
INSERT INTO TRIGGERS.SOFTWARE VALUES (3, 'WINDOWS', 200, 4, 3);
--===========================================
/*
1. Criar um Trigger para Auditoria de Exclusão de Máquinas: Criar um trigger que registre quando um registro da tabela Maquina for excluído.*/
CREATE OR REPLACE FUNCTION TRIGGERS.AUDITORIA_EXCLUSAO_MAQUINA (ID_MAQUINA INT) RETURNS AS $$
BEGIN 
    INSERT INTO TRIGGERS.AUDITORIA_EXCLUSAO (ID_MAQUINA, TIPO, VELOCIDADE, HARDDISK, PLACA_REDE, MEMORIA_RAM, FK_USUARIO, DATA_EXCLUSAO)
    VALUES (:OLD.ID_MAQUINA, :OLD.TIPO, :OLD.VELOCIDADE, :OLD.HARDDISK, :OLD.PLACA_REDE, :OLD.MEMORIA_RAM, :OLD.FK_USUARIO,)
$$ LANGUAGE PLPGSQL;

CREATE TRI

/*2. Criar um Trigger para Evitar Senhas Fracas: Criar um BEFORE INSERT trigger para impedir que um usuário seja cadastrado com uma senha menor que 6 caracteres.*/

/*3.Criar um Trigger para Atualizar Contagem de Softwares em Cada Máquina: Criar um AFTER INSERT trigger que atualiza uma tabela auxiliar 
Maquina_Software_Count que armazena a quantidade de softwares instalados em cada máquina.*/

/*4. Criar um Trigger para Evitar Remoção de Usuários do Setor de TI: 
Objetivo: Impedir a remoção de usuários cuja Especialidade seja 'TI'.*/

/*5. Criar um Trigger para Calcular o Uso Total de Memória por Máquina: 
Criar um AFTER INSERT e AFTER DELETE trigger que calcula a quantidade total de memória RAM ocupada pelos softwares em cada máquina.*/

/*6. Criar um Trigger para Registrar Alterações de Especialidade em Usuários: 
Criar um trigger que registre as mudanças de especialidade dos usuários na tabela Usuarios.*/

/*7. Criar um Trigger para Impedir Exclusão de Softwares Essenciais: 
Criar um BEFORE DELETE trigger que impeça a exclusão de softwares considerados essenciais (ex: Windows).
*/