CREATE TABLE outros.empregado (
    nome VARCHAR(50),
    cpf INT PRIMARY KEY NOT NULL,
    datanasc DATE,
    sexo VARCHAR(20),
    carttrabalho INT,
    salario FLOAT
    --fk_numdep INT  ---------------------------------------------------------------------- ADICIONAR COM ALTER TABLE
    --CONSTRAINT fk_empregado_numdep FOREIGN KEY(fk_numdep) REFERENCES departamento(numdep),

);
ALTER TABLE outros.empregado ADD COLUMN fk_numdep INT,
ADD CONSTRAINT fk_empregado_numdep 
FOREIGN KEY (fk_numdep) REFERENCES outros.departamento(numdep);


ALTER TABLE outros.empregado ADD COLUMN cpfsuper INT;

CREATE TABLE outros.departamento (
    nome VARCHAR(50),
    numdep INT PRIMARY KEY NOT NULL,
    datainicio DATE
    --fk_cpfger INT, ---------------------------------------------------------------------- ADICIONAR COM ALTER TABLE
    --CONSTRAINT fk_departamento_cpfger FOREIGN KEY (fk_cpfger) REFERENCES empregado(cpf)

);

ALTER TABLE outros.departamento ADD COLUMN fk_cpfger INT, ADD CONSTRAINT fk_departamento_cpfger 
FOREIGN KEY (fk_cpfger) REFERENCES outros.empregado(cpf);

SELECT * FROM outros.empregado;
SELECT * FROM outros.departamento;

CREATE TABLE outros.projeto (
    nome VARCHAR(50),
    numproj INT PRIMARY KEY NOT NULL,
    localizacao VARCHAR(150),
    fk_numd INT,
    CONSTRAINT fk_projeto_numd FOREIGN KEY (fk_numd) REFERENCES outros.departamento(numdep)
);

CREATE TABLE outros.dependente (
    ID INT PRIMARY KEY NOT NULL,
    nomedeo VARCHAR (50),
    sexo VARCHAR(20),
    parentesco VARCHAR(50),
    fk_cpfdep INT,
    CONSTRAINT fk_dependente_cpfdep FOREIGN KEY (fk_cpfdep) REFERENCES outros.empregado(cpf)
);

CREATE TABLE outros.trabalhaem (
    id INT PRIMARY KEY NOT NULL,
    fk_cpfe INT,
    CONSTRAINT fk_trabalhaem_cpfe FOREIGN KEY (fk_cpfe) REFERENCES outros.empregado(cpf),
    fk_numproj INT,
    CONSTRAINT fk_trabalhaem_numproj FOREIGN KEY (fk_numproj) REFERENCES outros.projeto(numproj)
);


ALTER TABLE outros.trabalhaem ADD COLUMN horas INT;

---- inserção de dados ----

INSERT INTO outros.departamento VALUES ('DEP1', 1, '1990-01-01', null);
INSERT INTO outros.departamento VALUES ('DEP2', 2, '1990-01-01', null);
INSERT INTO outros.departamento VALUES ('DEP3', 3, '1990-01-01', null);
INSERT INTO outros.departamento VALUES ('DEP4', 4, '1990-01-01', null);

INSERT INTO outros.empregado VALUES ('AMANDA', 123, '2003-11-07', 'FEMININO', 007, 7.500, null);
INSERT INTO outros.empregado VALUES ('FULANO', 456, '2003-01-07', 'MASC', 117, 6.500, null);
INSERT INTO outros.empregado VALUES ('FULANO', 789, '2003-12-07', 'MASC', 457, 5.500, null);
INSERT INTO outros.empregado VALUES ('FULANO', 753, '2003-09-07', 'MASC', 777, 4.500, null);

-- Atualizar cpfger dos departamentos
UPDATE outros.departamento SET fk_cpfger = 123 WHERE numdep = 1;
UPDATE outros.departamento SET fk_cpfger = 456 WHERE numdep = 2;
UPDATE outros.departamento SET fk_cpfger = 789 WHERE numdep = 3;
UPDATE outros.departamento SET fk_cpfger = 753 WHERE numdep = 4;

INSERT INTO outros.projeto VALUES ('Proj1', 1, 'Local1', 1);
INSERT INTO outros.projeto VALUES ('Proj2', 2, 'Local2', 2);
INSERT INTO outros.projeto VALUES ('Proj3', 3, 'Local3', 3);

INSERT INTO outros.dependente VALUES (1, 'Dep1', 'M', 'Filho', 123);
INSERT INTO outros.dependente VALUES (2, 'Dep2', 'F', 'Filha', 456);
INSERT INTO outros.dependente VALUES (3, 'Dep3', 'M', 'Filho', 789);

INSERT INTO outros.trabalhaem VALUES (1, 123, 1);
INSERT INTO outros.trabalhaem VALUES (2, 456, 2);
INSERT INTO outros.trabalhaem VALUES (3, 789, 3);

-- Consulta de tudo
SELECT * FROM outros.trabalhaem, outros.departamento, outros.dependente, outros.projeto, outros.empregado;

-- Substring, com posições específicas de caracteres
SELECT nome FROM outros.projeto WHERE nome LIKE 'P____';

-- Diferenças entre as aspas:
-- * Simples pegam strings.
-- * Duplas são para identificar o nome da tabela, coluna, etc...
SELECT e.nome FROM outros.empregado e WHERE e.nome LIKE 'A%';
SELECT e.nome FROM outros.empregado e WHERE "nome" LIKE 'A%';

-- Operadores na própria coluna
-- Já vou calcular o aumento de 10% nos salários dos funcionários
SELECT e.nome, e.salario * 1.1 FROM outros.empregado e;
-- Colocar nome referência na operação usando o AS
SELECT e.nome, e.salario * 1.1 AS salarioAtualizado FROM outros.empregado e;

-- O uso do DISTINCT é para evitar duplicações
SELECT DISTINCT e.nome, e.cpf 
FROM outros.empregado e 
JOIN outros.trabalhaem t ON e.cpf = t.fk_cpfe;

-- Utilizar UNION que é união de 2 consultas
-- Listar os números de projetos nos quais esteja envolvida a empregada 'AMANDA' como empregada, 
-- ou como gerente responsável pelo departamento que controla o projeto.

(SELECT DISTINCT p.numproj 
 FROM outros.projeto p
 JOIN outros.departamento d ON p.fk_numd = d.numdep
 JOIN outros.empregado e ON d.fk_cpfger = e.cpf
 WHERE e.nome = 'AMANDA')

UNION

(SELECT t.fk_numproj FROM outros.trabalhaem t JOIN outros.empregado e ON t.fk_cpfe = e.cpf
 WHERE e.nome = 'AMANDA');

-- Uso do intersect
-- Listando os nomes dos empregads que também são gerentes de departamento
SELECT e.nome FROM outros.empregado e 
intersect
SELECT e.nome from outros.empregado e, outros.departamento d WHERE fk_cpfger = e.cpf;

-- Utilizar o is Null, para imprimir registros que não tem nulo em certa coluna
SELECT e.nome FROM outros.empregado e WHERE e.cpfsuper is null; -- que é nulo
SELECT enome FROM outros.empregado e WHERE e.cpfsuper is not null; -- que não é nulo

-- Funções que já estão nativas
-- Média dos salarios dos empregados
SELECT AVG(salario) from outros.empregado;
-- o máximo dos salarios dos empregados, ou que é o salario maximo que está nos empregados
SELECT MAX(salario) FROM outros.empregado;
SELECT MIN(salario) FROM outros.empregado;
-- soma totoal dos salarios dos empregados
SELECT SUM(salario) FROM outros.empregado;


-- ====================== EXERCÍCIO ======================
-- Selecionar o CPF de todos os empregados que trabalham no mesmo projeto e com a
-- mesma quantidade de horas que o empregado cujo cpf é 123
SELECT DISTINCT fk_cpfe
FROM outros.trabalhaem
WHERE (fk_numproj, horas) in -- o in para verificar se o resultado esta na subconsulta
(SELECT fk_numproj, horas FROM outros.trabalhaem WHERE fk_cpfe = 123);

-- ====================== EXERCÍCIO 2 ======================
-- Seelecionar o nome de todos os empregados que têm salário maior do que
-- todos os salários dos empregados do departamento 2

SELECT DISTINCT nome
FROM outros.empregado
WHERE salario > ALL
(SELECT salario FROM outros.empregado WHERE fk_numdep = 2);

