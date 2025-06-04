Crie o banco de dados e suas tabelas abaixo.

Tabela: empregado
Colunas: 
Código do empregado char 8
Nome do empregado char 30
Data de nascimento do empregado data
Endereço do empregado char 50
Cidade do empregado char 20
Estado do empregado char 2
Telefone do empregado char 11

Tabela: dependente
Colunas: 
Código do empregado char 8
Código do dependente inteiro 
Nome do dependente char 30
Data de nascimento do dependente data
Grau de parentesco do dependente inteiro

Tabela: parentesco
Colunas: 
Código do parentesco inteiro
Nome do parentesco char 25

Os códigos de parentesco são:
    99 -> esposa
    1 -> filha
    2 -> filho

Usando o banco de dados criado com as tabelas acima faça:

1 – Crie as seguintes chaves primárias usando o comando ALTER:
A – tabela Empregado campo código do Empregado
B – tabela Dependente campo código do Empregado e código do dependente
C – tabela Parentesco campo código do parentesco

2 – Crie as seguintes chaves estrangeiras usando o comando ALTER:
D – tabela Dependente campo código do empregado referência tabela Empregado
E – tabela Dependente campo código do parentesco referência tabela Parentesco

3 – Insira dados com as seguintes características:
- 3 empregados com idade > de 50 anos e cada empregado tem 1 esposas > 47 anos e 1 filho < 17 anos e 1 filha > 17 anos. 
- 3 empregados com idade entre 35 e 49 anos e cada empregado tem 1 esposas entre 35 e 46 anos e 1 filho < 12 anos e 1 filha > 12 anos.
- 3 empregados com idade entre 20 e 34 anos e cada empregado tem 1 esposas entre 20 e 32 anos e 1 filho < 5 anos e 1 filha > 5 anos.
OBS.: dia 01 mês 01 para a data de nascimento.

Os nomes dos empregados são:
empregado1, empregado2, empregado3, empregado4, empregado5, empregado6, empregado7, empregado8, empregado9

Os nomes das esposas são:
Esposa1, esposa2, esposa3, esposa4, esposa5, esposa6, esposa7, esposa8, esposa9

Os nomes dos filhos são:
filho1, filho2, filho3, filho4, filho5, filho6, filho7, filho8, filho9 

Os nomes das filhas são:
filha1, filha2, filha3, filha4, filha5, filha6, filha7, filha8, filha9 

As cidades devem ser inseridas na seguinte sequência na tabela empregado:
cidade1, cidade2, cidade3, cidade4, cidade5, cidade6, cidade7, cidade8, cidade9

Os estados devem ser inseridos na seguinte sequência na tabela empregado: 
SP, MG, SP, MG, SP, MG, SP, MG e SP

4 – Escreva uma query para mostrar empregados e seus dependentes com as seguintes colunas:
       colunas -> nome empregado, data de nascimento do empregado, nome da esposa, nome dos filhos e nome das filhas.

5 – Escreva uma query para mostrar empregados e seus dependentes com as seguintes colunas:
      colunas -> nome empregado, nome da esposa, nome dos filhos, data de nascimento, nome das filhas, data de nascimento    

6 – Escreva uma query para mostrar os empregados entre 35 e 49 anos e seus filhos/filhas < de 12 anos com as seguintes colunas:
       colunas -> nome empregado, data nascimento empregado, nome do filho, data de nascimento do filho, nome da filha, data nascimento da filha.

7 – Escreva uma query para mostrar os empregados com as esposas entre 20 e 32 anos e seus filhos/filhas > 5 anos numa tabela com as seguintes colunas:
       colunas -> nome empregado, nome esposa, data nascimento esposa, nome do filho, data de nascimento do filho, nome da filha, data nascimento da filha.

8 – Escreva uma query para mostrar os empregados com as esposas > 47 anos e seus filhos/ filhas > 17 numa tabela com as seguintes colunas:
       colunas -> nome empregado, nome esposa, data nascimento esposa, nome do filho, data de nascimento do filho, nome da filha, data nascimento da filha.

9 - Escreva uma query para mostras os filhos que moram no estado de ‘SP’ com as seguintes colunas:
       colunas -> nome empregado, nome da esposa, nome do filho e data de nascimento do filho, nome da filha, data de nascimento da filha e estado

10 - Escreva uma query para mostrar as cidades do estado de ‘MG’ com as seguintes colunas:
       colunas -> nome empregado, nome da esposa, nome do filho, data de nascimento do filho nome da filha, data de nascimento da filha e cidade.

OBS.: Quando não houver dados a coluna tem que aparecer vazia.