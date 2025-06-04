Crie o banco de dados e as tabelas abaixo. Insira os dados abaixo. 

Create database TR_aluno;                               
Use TR_aluno;
CREATE TABLE Empregado 
 (Empr_cd_Empregado Char(8) NOT NULL, 
 Empr_nm_Empregado Char(30), 
 Empr_dt_Nascimento Date,
 Empr_ds_Endereco Char(50), 
 Empr_nm_Cidade Char(20), 
 Empr_nm_Estado char(2),
 Empr_nm_Telefone char(11)); 

 CREATE TABLE Dependente 
 (Empr_cd_Empregado Char(8) NOT NULL, 
 Depe_cd_Dependente Integer NOT NULL, 
 Depe_nm_Dependente Char(30), 
 Depe_dt_Nascimento Date,
 Pare_cd_Parentesco Integer); 
 
 CREATE TABLE Parentesco 
 (Pare_cd_Parentesco Integer NOT NULL, 
 Pare_ds_Parentesco char(25)); 

alter table empregado
add primary key (empr_cd_empregado);

alter table dependente
add primary key (empr_cd_empregado,depe_cd_dependente);

alter table parentesco
add primary key (pare_cd_parentesco);

alter table dependente
add foreign key (empr_cd_empregado) references empregado (empr_cd_empregado);

alter table dependente
add foreign key (pare_cd_parentesco) references parentesco (pare_cd_parentesco);

insert into parentesco values (99, 'Esposa');
insert into parentesco values (1, 'Filho');
insert into parentesco values (2, 'Filha');

insert into empregado values (1,'Empregado 1','1966-01-01','Rua 1','Cidade 1','sp','33642735');
insert into empregado values (2,'Empregado 2','1966-01-01','Rua 2','Cidade 2','rj','33257896');
insert into empregado values (3,'Empregado 3','1966-01-01','Rua 3','Cidade 3','sp','33754127');

insert into empregado values (4,'Empregado 4','1976-01-01','Rua 4','Cidade 4','rj','33675896');
insert into empregado values (5,'Empregado 5','1976-01-01','Rua 5','Cidade 5','sp','33641258');
insert into empregado values (6,'Empregado 6','1976-01-01','Rua 6','Cidade 6','rj','33634185');

insert into empregado values (7,'Empregado 7','1991-01-01','Rua 7','Cidade 7','sp','33675896');
insert into empregado values (8,'Empregado 8','1991-01-01','Rua 8','Cidade 8','rj','33641258');
insert into empregado values (9,'Empregado 9','1991-01-01','Rua 9','Cidade 9','sp','33634185');

insert into dependente values (1,1,'Filho 1','2007-01-01',1);
insert into dependente values (1,2,'Filha 1','2002-01-01',2);
insert into dependente values (1,3,'Esposa 1','1971-01-01',99);

insert into dependente values (2,1,'Filho 2','2007-01-01',1);
insert into dependente values (2,2,'Filha 2','2002-01-01',2);
insert into dependente values (2,3,'Esposa 2','1971-01-01',99);

insert into dependente values (3,1,'Filho 3','2007-01-01',1);
insert into dependente values (3,2,'Filha 3','2002-01-01',2);
insert into dependente values (3,3,'Esposa 3','1971-01-01',99);

insert into dependente values (4,1,'Filho 4','2012-01-01',1);
insert into dependente values (4,2,'Filha 4','2008-01-01',2);
insert into dependente values (4,3,'Esposa 4','1980-01-01',99);

insert into dependente values (5,1,'Filho 5','2012-01-01',1);
insert into dependente values (5,2,'Filha 5','2008-01-01',2);
insert into dependente values (5,3,'Esposa 5','1980-01-01',99);

insert into dependente values (6,1,'Filho 6','2012-01-01',1);
insert into dependente values (6,2,'Filha 6','2008-01-01',2);
insert into dependente values (6,3,'Esposa 6','1980-01-01',99);

insert into dependente values (7,1,'Filho 7','2018-01-01',1);
insert into dependente values (7,2,'Filha 7','2014-01-01',2);
insert into dependente values (7,3,'Esposa 7','1998-01-01',99);

insert into dependente values (8,1,'Filho 8','2018-01-01',1);
insert into dependente values (8,2,'Filha 8','2014-01-01',2);
insert into dependente values (8,3,'Esposa 8','1998-01-01',99);

insert into dependente values (9,1,'Filho 9','2018-01-01',1);
insert into dependente values (9,2,'Filha 9','2014-01-01',2);
insert into dependente values (9,3,'Esposa 9','1998-01-01',99);

Com o banco de dados pronto e os dados inseridos, faça:
OBS: sinalize na 1. linha do arquivo .sql se foi feito no MYSQL ou SQL 

1 - Escreva uma query para mostrar a mãe com idade > 50 anos e seus filhos/filhas com idade > 17 anos.
       colunas -> nome e data nascimento esposa, nome e data nascimento filho, nome e data nascimento filha e cidade

2 - Escreva uma query para mostrar a mãe com idade de 20 a 34 anos e seus filhos/filhas com idade < 5 anos.
       colunas -> nome e data nascimento esposa, nome e data nascimento filho, nome e data nascimento filha e endereço

3 – Escreva uma query para mostrar a mãe com idade de 35 a 49 anos, esposas e seus filhos/filhas < de 12 anos.
      colunas -> nome e data nascimento esposa, nome e data de nascimento filho, nome e data nascimento filha e o estado.

4 - Escreva uma query para mostrar o empregado, esposa com idade de 35 a 49 anos e seus filhos/filhas com idade > 12 anos.
       colunas -> nome e data nascimento empregado, nome e data de nascimento da esposa, nome e data nascimento filho, nome e data nascimento filha e código do empregado

5 - Escreva uma query para mostrar o empregado com idade > 50 anos, esposa e seus filhos/filhas com idade < 17 anos.
       colunas -> nome e data nascimento empregado, nome e data de nascimento da esposa, nome e data nascimento filho, nome e data nascimento filha e cidade 

6 – Escreva uma query para mostrar os empregados com idade de 20 a 34 anos, esposas e os filhos/filhas > de 5 anos.
      colunas -> nome empregado, nome e data nascimento esposa, nome e data nascimento filhos, nome e data nascimento filha.

Escreva as seguintes procedures e execute usando PASSAGEM DE PARÂMETROS:

7 – na tabela de empregados altere o ano para 1992,1987,1982,1977,1972,1967,1962, 1957, 1952 mantendo o dia e mês original.

8 – na tabela de dependentes altere o ano das esposas para 1953,1956,1959,1973,1976, 1979, 1983, 1986, 1989 mantendo o dia e mês original.

9 - na tabela de dependentes altere o ano dos filhos homens para 1993, 1993, 1993, 1995, 1995, 1995, 1997, 1997, 1997 mantendo o dia e mês original

10 - na tabela de dependentes altere o ano das filhas mulheres para 2010, 2010, 2010, 2012, 2012, 2012, 2016, 2016, 2016 mantendo o dia e mês original