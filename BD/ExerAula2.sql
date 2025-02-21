create table users (
    id int primary key not null,
    nome varchar (100),
    pssword varchar (255),
    ramal int,
    especialidade varchar (50)
);

create table maquinas (
    id int primary key not null,
    tipo varchar (50),
    velocidade decimal (4,2),
    hard_disk int,
    placa_rede float,
    memoria_ram int
);

create table software (
    id int primary key not null,
    produto varchar (50),
    hard_disk int,
    memoria_ram int
);

CREATE TABLE users_maquinas (
    fk_users INT NOT NULL,
    fk_maquinas INT NOT NULL,
    PRIMARY KEY (fk_users, fk_maquinas),
    CONSTRAINT fk_maquina_users FOREIGN KEY (fk_users) REFERENCES users(id),
    CONSTRAINT fk_users_maquinas FOREIGN KEY (fk_maquinas) REFERENCES maquinas(id)
);

CREATE TABLE maquinas_software (
    fk_maquinas INT NOT NULL,
    fk_software INT NOT NULL,
    PRIMARY KEY (fk_maquinas, fk_software), -- Chave primária composta
    CONSTRAINT fk_software_maquinas FOREIGN KEY (fk_maquinas) REFERENCES maquinas(id),
    CONSTRAINT fk_maquinas_software FOREIGN KEY (fk_software) REFERENCES software(id)
);


INSERT INTO users (id, nome, pssword, ramal, especialidade) VALUES
(1, 'joão', 'senha456', 102, 'Desenvolvimento'),
(2, 'ana', 'senha789', 103, 'Infraestrutura'),
(3, 'carlos', 'senhaabc', 104, 'Segurança'),
(4, 'maria', 'senha123', 101, 'Suporte'),
(5, 'fernanda', 'senhadef', 105, 'Banco de Dados'),
(6, 'roberto', 'senhaghi', 106, 'Redes'),
(7, 'paula', 'senhajkl', 107, 'Helpdesk');

INSERT INTO users VALUES (8, 'William', 'senhakkk', 108, 'tecnico');

INSERT INTO maquinas (id, tipo, velocidade, hard_disk, placa_rede, memoria_ram) VALUES
(1, 'Core II', 2.40, 500, 1.0, 8),
(2, 'Core III', 3.10, 1000, 1.0, 16),
(3, 'Core V', 3.60, 2000, 2.5, 32),
(4, 'Pentium', 2.80, 250, 1.0, 4),
(5, 'Dual Core', 2.20, 320, 1.0, 4),
(6, 'Core V', 3.80, 1000, 2.5, 16),
(7, 'Core III', 3.40, 500, 1.0, 8);


INSERT INTO software (id, produto, hard_disk, memoria_ram) VALUES
(1, 'Windows 10', 50, 4),
(2, 'Linux Ubuntu', 30, 2),
(3, 'Microsoft Office', 20, 4),
(4, 'Adobe Photoshop', 500, 8),
(5, 'AutoCAD', 700, 16),
(6, 'Google Chrome', 1, 1),
(7, 'Visual Studio Code', 2, 2);


INSERT INTO users_maquinas (fk_users, fk_maquinas) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);


INSERT INTO maquinas_software (fk_maquinas, fk_software) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

select * from users;
select * from maquinas;
select * from software;
select * from users_maquinas;
select * from maquinas_software;

-- 1) usuarios com a especialidade tecnico
select u.nome from users u where especialidade = 'tecnico';

-- 2)
-- 3)
-- 4)
-- 5) usuarios que tinham o tipo da maquina COREIII ou CORE v
SELECT u.nome, m.tipo
FROM users u
JOIN users_maquinas um ON u.id = um.fk_users
JOIN maquinas m ON um.fk_maquinas = m.id
WHERE m.tipo = 'Core III' OR m.tipo = 'Core V';

-- 6)
-- 7)
-- 8) usuarios + velocidade de suas maquinas
SELECT u.nome, m.velocidade FROM users u JOIN users_maquinas um ON u.id = um.fk_users 
JOIN maquinas m ON um.fk_maquinas = m.id WHERE m.velocidade > 0;

-- 9) usuarios com id menores que o da Maria
SELECT u.id, u.nome FROM users u WHERE id < 4 AND nome not in ('Maria'); --id da maria eh 4

-- 10) maquinas que tinham velocidade maiores que 2.4 (total)
SELECT m.id, m.velocidade FROM maquinas m WHERE m.velocidade > 2.4;
-- SELECT SUM(counts) AS total_count
-- FROM (
--     SELECT COUNT(*) AS counts
--     FROM maquinas m
--     WHERE m.velocidade > 2.4
--     GROUP BY m.id, m.velocidade
-- ) subquery;

-- 11) o numero de usuarios por maquina
SELECT SUM(counts) AS total_count
FROM (
    SELECT COUNT(*) AS counts
    FROM users_maquinas um
    
) subquery;

-- 12) o numero de usuarios agrupados pelo tipo da maquina
SELECT u.nome, m.tipo FROM users u JOIN users_maquinas um ON u.id = um.fk_users JOIN maquinas m ON um.fk_maquinas = m.id
WHERE m.tipo != '' GROUP BY u.nome, m.tipo;


-- 13) o numero de usuarios por um tipo específico
SELECT SUM(counts) AS total_count
FROM (
    SELECT COUNT(*) AS counts
    FROM maquinas m
    WHERE m.tipo = 'Dual Core' -- aplicar aos outros tipos
    GROUP BY m.id, m.tipo
) subquery;


-- 14)
-- 15)
-- 16)
-- 17) O número total de maquinas de cada tipo
SELECT tipo, COUNT(id) FROM maquinas GROUP BY tipo;

-- 18)
-- 19) a identificação e o respectivo produto cujo o nome tenha "O" em sua composição
SELECT s.id, s.produto FROM software s WHERE s.produto like '%o%'; 



-- 20)
SELECT maquina."id-maquina", maquina.HD
FROM maquinas maquina
WHERE HD > ALL
    (SELECT HD
     FROM software);  -- O all é usado para comparar todos os valores