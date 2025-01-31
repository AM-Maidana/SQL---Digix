create table usuario (
    id int primary key not null,
    nome varchar (50),
    email varchar (100)
);

create table cargo (
    id int primary key not null,
    nome varchar (50),
    fk_usuario int,
    constraint fk_cargo_usuario foreign key(fk_usuario) references usuario(id)
);

insert into usuario values(1, 'amanda', 'amanda.email@gmail.com');
insert into usuario values(2, 'jose', 'jose.email@gmail.com');
insert into usuario values(3, 'luiz', 'luiz.email@gmail.com');

insert into cargo values(1, 'presidente', 1);
insert into cargo values(2, 'vice', 2);
insert into cargo values(3, 'gerente', 3);

select * from usuario;
select * from cargo;

-- Imprimir somente o nome 
SELECT cargo.nome from cargo;
SELECT cargo.id_cargo FROM cargo;


-- Abreviação da tabela
select c.nome from cargo c;
select c.nome, u.nome from cargo c, usuario u;

-- Aplicação de Condições
select c.nome from cargo c where id_cargo =1; -- IMprimi o nome do cargo com o id 1;

select u.id_usuario from usuario u where u.nome = 'Willdanthe'; -- imprime o ID do willdanthe

select u.nome from usuario u where u.id = 1 or u.id = 2; -- operador 'ou' que imprimi 1 ou 2 ID

select u.nome from usuario u where u.id = 1 and u.id = 2; -- operador 'and' que imprimi 1 e 2 ID

-- selecionar lista de ID 
select u.nome from usuario u where id_usuario in (1,2,3); -- in quer dizer vai selecionar os valores dentro da 'lista'
select u.nome from usuario u where id_usuario not in (1,2,3); -- not quer dizer que não é imprimir os valores da 'lista'
select u.nome from usuario u where id_usuario BETWEEN 1 and 3; -- Imprimindo entre os intervalos de  


-- utilizar o operador between para selecionar o que está entre os intervalos
select u.nome from usuario u where nome between 'joao' and 'jose'; --

-- Utiliza o operado Like para pesquisar partes de uma string(texto)
select u.id, u.nome from usuario u where nome like '%e'; -- % qualquer coisa de caracter
select id, nome from usuario where nome like '%ao;'; -- tudo que pode ser imprimido que termine com 'ao';

--<<<<< Operadores de Comparação >>>>>--
select u.id, u.nome from usuario u where id > 1; -- maior que 1
select u.id, u.nome from usuario u where id >= 1; -- maior igual a 1
select u.id, u.nome from usuario u where id < 1; -- menor que 1

select u.id, u.nome from usuario u where id > 1 and id < 3; --operadores lóficos que imprime entre marcações

--<<<<< Operadores de Ordenação >>>>>--
select u.id, u.nome from usuario u order by id desc; -- order by - ordernar, o Desc estabelece que é de forma decrescente
select u.id, u.nome from usuario u order by id asc; -- crescente
select u.id, u.nome from usuario u order by nome desc; -- ordenando por """string" e por indice de caracteres

--<<<<< Limitar os resultados >>>>>--
select * from usuario limit 1;

--<<<<< Agrupamento >>>>>--
select c.nome, u.nome from usuario u, cargo c
where u.id = c.fk_usuario group by c.nome, u.id; -- group by = agrupamento por 

 --<<<<< Contadores >>>>>--
select c.nome, u.nome count(c.id) from usuario u, cargo c
where u.id = c.fk_usuario group by c.nome, u.id; -- Operador count é par contar a quantidade de ocorrencia naquela coluna

