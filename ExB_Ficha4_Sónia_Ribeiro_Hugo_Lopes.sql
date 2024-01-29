-- ** eliminar tabelas se existentes **
-- CASCADE CONSTRAINTS para eliminar as restri??es de integridade das chaves prim?rias e chaves ?nicas
-- PURGE elimina a tabela da base de dados e da "reciclagem"

DROP TABLE empregado                CASCADE CONSTRAINTS PURGE;
DROP TABLE empregadoEfetivo         CASCADE CONSTRAINTS PURGE;
DROP TABLE empregadoTemporario      CASCADE CONSTRAINTS PURGE;
DROP TABLE falta                    CASCADE CONSTRAINTS PURGE;
DROP TABLE ferias                   CASCADE CONSTRAINTS PURGE;
DROP TABLE avaliacao                CASCADE CONSTRAINTS PURGE;
DROP TABLE avaliacaoTemporario      CASCADE CONSTRAINTS PURGE;
DROP TABLE avaliacaoEfetivo         CASCADE CONSTRAINTS PURGE;
DROP TABLE departamento             CASCADE CONSTRAINTS PURGE;
DROP TABLE empregadoDepartamento    CASCADE CONSTRAINTS PURGE;

-- ** cria??o de tabelas **

CREATE TABLE empregado (
    idEmpregado             INTEGER GENERATED AS IDENTITY   CONSTRAINT pkEmpregadoIdEmpregado           PRIMARY KEY,
    nome                    VARCHAR(40)                     CONSTRAINT nnEmpregadoNome                  NOT NULL,
    dataNascimento          DATE                            CONSTRAINT nnEmpregadoDataNascimento        NOT NULL,
    nrIdentificacaoCivil    INTEGER                         CONSTRAINT ckEmpregadoNrIdentificacaoCivil  CHECK(REGEXP_LIKE(nrIdentificacaoCivil, '^\d{6,}$'))
                                                            CONSTRAINT ukEmpregadoNrIdentificacaoCivil  UNIQUE,
    nif                     INTEGER                         CONSTRAINT nnEmpregadoNif                   NOT NULL
                                                            CONSTRAINT ckEmpregadoNif                   CHECK(REGEXP_LIKE(nif, '^\d{9}$'))
                                                            CONSTRAINT ukEmpregadoNif                   UNIQUE
);

CREATE TABLE empregadoEfetivo (
    idEmpregado         INTEGER         CONSTRAINT pkEmpregadoEfetivoIdEmpregado   PRIMARY KEY,
    salarioMensalBase   NUMERIC(10,2)   CONSTRAINT nnEmpregadoEfetivoSalarioMensalBase   NOT NULL
                                        CONSTRAINT ckEmpregadoEfetivoSalarioMensalBase   CHECK (salarioMensalBase >= 500)
);

CREATE TABLE empregadoTemporario (
    idEmpregado INTEGER         CONSTRAINT pkEmpregadoTemporarioIdEmpregado PRIMARY KEY,
    salarioHora NUMERIC(4,2)    CONSTRAINT nnEmpregadoTemporarioSalarioHora NOT NULL
);

CREATE TABLE falta (
    idEmpregado     INTEGER,
    dataInicio      DATE,
    dataFim         DATE,
    justificacao    VARCHAR(50),
                            
    CONSTRAINT pkFaltaIdEmpregadoDataInicio PRIMARY KEY (idEmpregado, dataInicio),
    CONSTRAINT ckFaltaDataInicioDataFim     CHECK (dataFim>=dataInicio)
);

CREATE TABLE ferias (
    idEmpregado     INTEGER,
    dataInicio      DATE,
    dataFim         DATE        CONSTRAINT nnFeriasDataFim   NOT NULL,
    
    CONSTRAINT pkFeriasIdEmpregadoDataInicio    PRIMARY KEY (idEmpregado, dataInicio),
    CONSTRAINT ckFeriasDataInicioDataFim        CHECK(dataFim>=dataInicio)
);

CREATE TABLE avaliacao (
    idAvaliacao VARCHAR(3)  CONSTRAINT pkAvaliacaoIdAvaliacao   PRIMARY KEY,
    descricao   VARCHAR(15) CONSTRAINT nnAvaliacaoDescricao     NOT NULL
);

CREATE TABLE avaliacaoTemporario (
    idDepartamento  VARCHAR(5),
    idEmpregado     INTEGER,
    dataInicio      DATE,
    idAvaliacao     VARCHAR(3),
    
    CONSTRAINT pkAvaliacaoTemporarioIdEmpregadoDataInicio   PRIMARY KEY (idDepartamento, idEmpregado, dataInicio)
);

CREATE TABLE avaliacaoEfetivo (
    idEmpregado INTEGER,
    ano         INTEGER     CONSTRAINT ckAvaliacaoEfetivoAno            CHECK(ano>=2015)    NOT NULL,
    idAvaliacao VARCHAR(3)  CONSTRAINT nnAvaliacaoEfetivoIdAvaliacao    NOT NULL,
    
    CONSTRAINT pkAvaliacaoEfetivoIdEmpregadoAno PRIMARY KEY (idEmpregado, ano)
);

CREATE TABLE departamento (
    idDepartamento          VARCHAR(5)  CONSTRAINT pkDepartamentoIdDepartamento PRIMARY KEY,
    idDepartamentoSuperior  VARCHAR(5),
    designacao              VARCHAR(50) CONSTRAINT nnDepartamentoIdDesignacao   NOT NULL
);


CREATE TABLE empregadoDepartamento (
    idDepartamento  VARCHAR(5),
    idEmpregado     INTEGER,
    dataInicio      DATE,
    dataFim         DATE,
    
    CONSTRAINT pkEmpregadoDepartamentoIdDepartamentoIdEmpregadoDataInicio PRIMARY KEY (idDepartamento, idEmpregado, dataInicio),
    CONSTRAINT ckEmpregadoDepartamentoDataInicioDataFim                   CHECK(dataFim>=dataInicio)
);


-- ** chaves estrangeiras ** 

ALTER TABLE empregadoEfetivo    ADD CONSTRAINT fkEmpregadoEfetivoIdEmpregado                            FOREIGN KEY (idEmpregado)                               REFERENCES empregado (idEmpregado);

ALTER TABLE empregadoTemporario ADD CONSTRAINT fkEmpregadoTemporarioIdEmpregado                         FOREIGN KEY (idEmpregado)                               REFERENCES empregado (idEmpregado);

ALTER TABLE falta               ADD CONSTRAINT fkFaltaIdEmpregado                                       FOREIGN KEY (idEmpregado)                               REFERENCES empregado (idEmpregado);

ALTER TABLE ferias              ADD CONSTRAINT fkFeriasIdEmpregado                                      FOREIGN KEY (idEmpregado)                               REFERENCES empregadoEfetivo (idEmpregado);

ALTER TABLE avaliacaoTemporario ADD CONSTRAINT fkAvaliacaoTemporarioIdEmpregado                         FOREIGN KEY (idEmpregado)                               REFERENCES empregadoTemporario (idEmpregado);
ALTER TABLE avaliacaoTemporario ADD CONSTRAINT fkAvaliacaoTemporarioIdDepartamentoIdEmpregadoDataInicio FOREIGN KEY (idDepartamento, idEmpregado, dataInicio)   REFERENCES empregadoDepartamento (idDepartamento, idEmpregado, dataInicio);
ALTER TABLE avaliacaoTemporario ADD CONSTRAINT fkAvaliacaoTemporarioIdAvaliacao                         FOREIGN KEY (idAvaliacao)                               REFERENCES avaliacao (idAvaliacao);

ALTER TABLE avaliacaoEfetivo    ADD CONSTRAINT fkAvaliacaoEfetivoIdEmpregado                            FOREIGN KEY (idEmpregado)                               REFERENCES empregadoEfetivo (idEmpregado);
ALTER TABLE avaliacaoEfetivo    ADD CONSTRAINT fkAvaliacaoEfetivoIdAvaliacao                            FOREIGN KEY (idAvaliacao)                               REFERENCES avaliacao (idAvaliacao);

ALTER TABLE departamento        ADD CONSTRAINT fkDepartamentoidDepartamentoSuperior                     FOREIGN KEY (idDepartamentoSuperior)                    REFERENCES departamento (idDepartamento);

ALTER TABLE empregadoDepartamento ADD CONSTRAINT fkEmpregadoDepartamentoIdDepartamento                  FOREIGN KEY (idDepartamento)                            REFERENCES departamento (idDepartamento);
ALTER TABLE empregadoDepartamento ADD CONSTRAINT fkEmpregadoDepartamentoIdEmpregado                     FOREIGN KEY (idEmpregado)                               REFERENCES empregado (idEmpregado);

-- ** guardar em DEFINITIVO as altera??es na base de dados, se a op??o Autocommit do SQL Developer n?o estiver ativada **
-- COMMIT;


-- ** tabela Empregado **

INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Belmiro Cunha', TO_DATE('1985-01-13','yyyy-mm-dd'), 1111111, 111111111); 
INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Luisa Coelho',  TO_DATE('1980-05-03','yyyy-mm-dd'), 2222222, 222222222); 
INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Jo?o Pereira',  TO_DATE('1970-09-05','yyyy-mm-dd'), 3333333, 333333333); 
INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Carlos Silva',  TO_DATE('1983-02-10','yyyy-mm-dd'), 4444444, 444444444); 
INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Anibal Dias',   TO_DATE('1982-10-12','yyyy-mm-dd'), 5555555, 555555555); 
INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Anibal Dias',   TO_DATE('1983-04-22','yyyy-mm-dd'), 6666666, 666666666); 
INSERT INTO empregado (nome, dataNascimento, nrIdentificacaoCivil, nif) VALUES ('Joana Freitas', TO_DATE('1995-03-15','yyyy-mm-dd'), 7777777, 777777777); 

-- ** tabela Falta **

INSERT INTO falta (idEmpregado, dataInicio, dataFim, justificacao) VALUES (2, TO_DATE('2015-05-15','yyyy-mm-dd'), TO_DATE('2015-05-20','yyyy-mm-dd'), 'gripe'); 
INSERT INTO falta (idEmpregado, dataInicio, dataFim, justificacao) VALUES (3, TO_DATE('2018-11-05','yyyy-mm-dd'), TO_DATE('2018-11-15','yyyy-mm-dd'), 'apoio a familiares'); 
INSERT INTO falta (idEmpregado, dataInicio, dataFim, justificacao) VALUES (5, TO_DATE('2018-08-15','yyyy-mm-dd'), TO_DATE('2018-08-31','yyyy-mm-dd'), 'fratura'); 
INSERT INTO falta (idEmpregado, dataInicio, dataFim, justificacao) VALUES (6, TO_DATE('2020-09-25','yyyy-mm-dd'), TO_DATE('2020-09-28','yyyy-mm-dd'), 'gripe'); 

-- ** tabela EmpregadoEfetivo **

INSERT INTO empregadoEfetivo (idEmpregado, salarioMensalBase) VALUES (1,1500); 
INSERT INTO empregadoEfetivo (idEmpregado, salarioMensalBase) VALUES (2,700);
INSERT INTO empregadoEfetivo (idEmpregado, salarioMensalBase) VALUES (3,1000);
INSERT INTO empregadoEfetivo (idEmpregado, salarioMensalBase) VALUES (4,1000);

-- ** tabela EmpregadoTemporario **

INSERT INTO empregadoTemporario (idEmpregado, salarioHora) VALUES (5,7); 
INSERT INTO empregadoTemporario (idEmpregado, salarioHora) VALUES (6,7);
INSERT INTO empregadoTemporario (idEmpregado, salarioHora) VALUES (7,5);

-- ** tabela Departamento **
INSERT INTO departamento (idDepartamento, idDepartamentoSuperior, designacao) VALUES ('DIR', NULL, 'Dire??o'); 
INSERT INTO departamento (idDepartamento, idDepartamentoSuperior, designacao) VALUES ('DRH', 'DIR', 'Departamento de Recursos Humanos'); 
INSERT INTO departamento (idDepartamento, idDepartamentoSuperior, designacao) VALUES ('DSI', 'DIR', 'Departamento de Sistemas Inform?ticos'); 
INSERT INTO departamento (idDepartamento, idDepartamentoSuperior, designacao) VALUES ('DAU', 'DSI', 'Departamento de Apoio ao Utilizador'); 
INSERT INTO departamento (idDepartamento, idDepartamentoSuperior, designacao) VALUES ('DMI', 'DSI', 'Departamento de Manuten??o Inform?tica'); 

-- ** tabela EmpregadoDepartamento **

INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DIR', 1, TO_DATE('2010-09-15','yyyy-mm-dd'), NULL); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DRH', 2, TO_DATE('2010-10-26','yyyy-mm-dd'), NULL); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DAU', 3, TO_DATE('2015-03-07','yyyy-mm-dd'), TO_DATE('2019-09-09','yyyy-mm-dd')); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DMI', 3, TO_DATE('2019-09-10','yyyy-mm-dd'), NULL); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DAU', 4, TO_DATE('2018-04-12','yyyy-mm-dd'), NULL); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DAU', 5, TO_DATE('2018-08-01','yyyy-mm-dd'), TO_DATE('2018-08-31','yyyy-mm-dd')); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DMI', 6, TO_DATE('2020-09-20','yyyy-mm-dd'), TO_DATE('2020-09-30','yyyy-mm-dd')); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DRH', 7, TO_DATE('2019-11-15','yyyy-mm-dd'), TO_DATE('2019-12-31','yyyy-mm-dd')); 
INSERT INTO empregadoDepartamento (idDepartamento, idEmpregado, dataInicio, dataFim) VALUES ('DRH', 7, TO_DATE('2020-03-15','yyyy-mm-dd'), TO_DATE('2020-04-15','yyyy-mm-dd')); 

-- ** tabela Avaliacao **

INSERT INTO avaliacao (idAvaliacao, descricao) VALUES ('MB', 'MUITO BOM'); 
INSERT INTO avaliacao (idAvaliacao, descricao) VALUES ('B', 'BOM');
INSERT INTO avaliacao (idAvaliacao, descricao) VALUES ('S', 'SUFICIENTE');
INSERT INTO avaliacao (idAvaliacao, descricao) VALUES ('I', 'INSUFICIENTE');

-- ** tabela AvaliacaoTemporario **

INSERT INTO avaliacaoTemporario (idDepartamento, idEmpregado, dataInicio, idAvaliacao) VALUES ('DAU', 5, TO_DATE('2018-08-01','yyyy-mm-dd'), 'S');
INSERT INTO avaliacaoTemporario (idDepartamento, idEmpregado, dataInicio, idAvaliacao) VALUES ('DMI', 6, TO_DATE('2020-09-20','yyyy-mm-dd'), 'S');
INSERT INTO avaliacaoTemporario (idDepartamento, idEmpregado, dataInicio, idAvaliacao) VALUES ('DRH', 7, TO_DATE('2019-11-15','yyyy-mm-dd'), 'MB');
INSERT INTO avaliacaoTemporario (idDepartamento, idEmpregado, dataInicio, idAvaliacao) VALUES ('DRH', 7, TO_DATE('2020-03-15','yyyy-mm-dd'), 'MB');

-- ** tabela AvaliacaoEfetivo **

INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (1, 2015, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (1, 2016, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (1, 2017, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (1, 2018, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (1, 2019, 'MB');

INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (2, 2015, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (2, 2016, 'B'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (2, 2017, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (2, 2018, 'MB'); 
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (2, 2019, 'MB');

INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (3, 2016, 'S');
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (3, 2017, 'S');
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (3, 2018, 'S');
INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (3, 2019, 'S');

INSERT INTO avaliacaoEfetivo (idEmpregado, ano, idAvaliacao) VALUES (4, 2019, 'MB');

-- ** tabela Ferias **

INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2011-08-15','yyyy-mm-dd'), TO_DATE('2011-08-31','yyyy-mm-dd')); 
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2012-08-15','yyyy-mm-dd'), TO_DATE('2012-08-31','yyyy-mm-dd')); 
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2013-08-01','yyyy-mm-dd'), TO_DATE('2013-08-11','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2014-08-15','yyyy-mm-dd'), TO_DATE('2014-08-31','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2015-08-15','yyyy-mm-dd'), TO_DATE('2015-08-31','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2016-08-15','yyyy-mm-dd'), TO_DATE('2016-08-31','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2017-08-15','yyyy-mm-dd'), TO_DATE('2017-08-31','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (1, TO_DATE('2019-08-01','yyyy-mm-dd'), TO_DATE('2019-08-31','yyyy-mm-dd'));

INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (2, TO_DATE('2014-03-01','yyyy-mm-dd'), TO_DATE('2014-03-25','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (2, TO_DATE('2015-07-01','yyyy-mm-dd'), TO_DATE('2015-07-20','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (2, TO_DATE('2016-06-01','yyyy-mm-dd'), TO_DATE('2016-06-30','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (2, TO_DATE('2017-07-01','yyyy-mm-dd'), TO_DATE('2017-07-27','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (2, TO_DATE('2018-05-01','yyyy-mm-dd'), TO_DATE('2018-05-31','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (2, TO_DATE('2019-12-10','yyyy-mm-dd'), TO_DATE('2019-12-31','yyyy-mm-dd'));

INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (3, TO_DATE('2016-06-01','yyyy-mm-dd'), TO_DATE('2016-06-30','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (3, TO_DATE('2017-07-01','yyyy-mm-dd'), TO_DATE('2017-07-11','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (3, TO_DATE('2018-03-01','yyyy-mm-dd'), TO_DATE('2018-03-18','yyyy-mm-dd'));
INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (3, TO_DATE('2019-05-01','yyyy-mm-dd'), TO_DATE('2019-05-15','yyyy-mm-dd'));

INSERT INTO ferias (idEmpregado, dataInicio, dataFim) VALUES (4, TO_DATE('2019-05-01','yyyy-mm-dd'), TO_DATE('2019-05-31','yyyy-mm-dd'));

-- ** guardar em DEFINITIVO as altera??es na base de dados, se a op??o Autocommit do SQL Developer n?o estiver ativada **
-- COMMIT;

--A1) Obter o produto cartesiano (i.e. CROSS JOIN) entre as tabelas Empregado e EmpregadoEfetivo, de acordo 
--com a Figura 2.
SELECT Empregado.idEmpregado AS ID_EMPREGADO, EmpregadoEfetivo.idEmpregado AS ID_EMPREGADO_EFETIVO
FROM Empregado CROSS JOIN EmpregadoEfetivo order by 1,2;

--A2) Obter toda a informa  o dos empregados efetivos, por ordem alfab tica dos nomes e de acordo com a 
--Figura 3. 
select EmpregadoEfetivo.idEmpregado, Empregado.nome, Empregado.dataNascimento, Empregado.nrIdentificacaoCivil, Empregado.nif, EmpregadoEfetivo.salarioMensalBase from Empregado inner join EmpregadoEfetivo on(Empregado.idEmpregado = EmpregadoEfetivo.idEmpregado) order by 2;

--A3) Obter as faltas dos empregados efetivos, de acordo com a Figura 4.
select EmpregadoEfetivo.idEmpregado, Falta.dataInicio, Falta.dataFim, Falta.Justificacao from EmpregadoEfetivo inner join Falta on(EmpregadoEfetivo.idEmpregado = Falta.idEmpregado);

--A4) Obter as faltas dos empregados tempor rios, de acordo com a Figura 5.
 select Empregado.nome, Empregado.nrIdentificacaoCivil, EmpregadoTemporario.idEmpregado, Falta.dataInicio, Falta.dataFim, Falta.Justificacao from EmpregadoTemporario inner join Falta on(EmpregadoTemporario.idEmpregado = Falta.idEmpregado) inner join Empregado on (EmpregadoTemporario.idEmpregado = Empregado.idEmpregado);
 
--A5) Obter as avalia  es dos empregados tempor rios, de acordo com a Figura 6.
SELECT DISTINCT
    Empregado.nome,
    Empregado.nrIdentificacaoCivil,
    EmpregadoDepartamento.idDepartamento,
    EmpregadoDepartamento.dataInicio,
    EmpregadoDepartamento.dataFim,
    Avaliacao.descricao
FROM 
    EmpregadoTemporario
INNER JOIN Empregado ON EmpregadoTemporario.idEmpregado = Empregado.idEmpregado
INNER JOIN EmpregadoDepartamento ON EmpregadoTemporario.idEmpregado = EmpregadoDepartamento.idEmpregado
INNER JOIN AvaliacaoTemporario ON EmpregadoTemporario.idEmpregado = AvaliacaoTemporario.idEmpregado
INNER JOIN Avaliacao ON AvaliacaoTemporario.idAvaliacao = Avaliacao.idAvaliacao;

--A6) Obter o nome e o n mero de identifica  o civil de todos empregados que nunca faltaram, de acordo com 
--a Figura 7.
select Empregado.nome, Empregado.nrIdentificacaoCivil from Empregado left join Falta on(Empregado.idEmpregado = Falta.idEmpregado) where Falta.idEmpregado is null order by 1;

--A7)Obter o identificador e a designação de todos os departamentos juntamente com a designação do 
--respetivo departamento do nível hierárquico superior. O resultado apresentado deve estar de acordo com 
--a Figura 8. 
SELECT
    DEPARTAMENTO1.IDDEPARTAMENTO,
    DEPARTAMENTO1.DESIGNACAO AS DESIGNACAO,
    DEPARTAMENTO2.DESIGNACAO AS DEPARTAMENTO_NIVEL_SUPERIOR
FROM
    DEPARTAMENTO DEPARTAMENTO1
LEFT JOIN
    DEPARTAMENTO DEPARTAMENTO2 ON DEPARTAMENTO1.IDDEPARTAMENTOSUPERIOR = DEPARTAMENTO2.IDDEPARTAMENTO
    ORDER BY DESIGNACAO DESC;

--A8)Obter pares de empregados distintos e com idades diferentes, de acordo com a Figura 9
SELECT IDEMPREGADO, NOME, IDEMPREGADO_1, NOME_1
FROM (
    SELECT
    E1.IDEMPREGADO,
    E1.NOME AS NOME,
    E1.DATANASCIMENTO AS DATANASCIMENTO1,
    E2.IDEMPREGADO AS IDEMPREGADO_1,
    E2.NOME AS NOME_1,
    E2.DATANASCIMENTO AS DATANASCIMENTO2,
    TRUNC((SYSDATE - E1.DATANASCIMENTO)/365) AS IDADE1,
    TRUNC((SYSDATE - E2.DATANASCIMENTO)/365) AS IDADE2
FROM
    Empregado E1
JOIN
    Empregado E2 ON E1.DATANASCIMENTO > E2.DATANASCIMENTO
    )
    WHERE IDADE1 !=  IDADE2
    ORDER BY IDEMPREGADO, IDEMPREGADO_1;
  
--B1)Obter o nome e o número de identificação civil de todos os empregados que tiveram pelo menos uma 
--avaliação "MUITO BOM". O resultado apresentado deve estar de acordo com a Figura 10.
SELECT E.NOME, E.NRIDENTIFICACAOCIVIL
FROM(
    SELECT IDEMPREGADO, IDAVALIACAO
    FROM AVALIACAOEFETIVO
    UNION
    SELECT IDEMPREGADO, IDAVALIACAO 
    FROM AVALIACAOTEMPORARIO
) A
INNER JOIN
    EMPREGADO E ON A.IDEMPREGADO = E.IDEMPREGADO
    WHERE A.IDAVALIACAO = 'MB';

--B2)Obter a descrição das avaliações que são comuns a empregados efetivos e temporários, de acordo com a 
--Figura 11.
SELECT A.DESCRICAO 
FROM(
SELECT DISTINCT E.IDAVALIACAO
FROM AVALIACAOEFETIVO E
INNER JOIN
AVALIACAOTEMPORARIO T ON E.IDAVALIACAO = T.IDAVALIACAO
) Q 
INNER JOIN 
AVALIACAO A ON Q.IDAVALIACAO = A.IDAVALIACAO;

--B3)Obter o nome e o número de identificação civil dos empregados efetivos que tiveram sempre classificação 
--"MUITO BOM”, de acordo com a Figura 12.
SELECT DISTINCT F1.NOME, F1.NRIDENTIFICACAOCIVIL
FROM (
SELECT A.IDEMPREGADO, A.IDAVALIACAO, E.NOME, E.NRIDENTIFICACAOCIVIL
FROM AVALIACAOEFETIVO A
INNER JOIN
    EMPREGADO E ON A.IDEMPREGADO = E.IDEMPREGADO
    ) F1 
    MINUS
    SELECT DISTINCT F2.NOME, F2.NRIDENTIFICACAOCIVIL
FROM (
SELECT A.IDEMPREGADO, A.IDAVALIACAO, E.NOME, E.NRIDENTIFICACAOCIVIL
FROM AVALIACAOEFETIVO A
INNER JOIN
    EMPREGADO E ON A.IDEMPREGADO = E.IDEMPREGADO
    WHERE A.IDAVALIACAO = 'B' OR A.IDAVALIACAO = 'S'
    ) F2 ;

--B4)Obter o nome e o número de identificação civil dos empregados efetivos cujas férias têm todas duração
--superior a 15 dias. O resultado apresentado deve estar de acordo com a Figura 13.
SELECT EMPREGADO.NOME, EMPREGADO.NRIDENTIFICACAOCIVIL
FROM(
SELECT DISTINCT IDEMPREGADO 
FROM FERIAS
MINUS
SELECT DISTINCT IDEMPREGADO 
FROM FERIAS WHERE (DATAFIM - DATAINICIO - 1) <= 15
) Z
INNER JOIN
EMPREGADO ON (EMPREGADO.IDEMPREGADO = Z.IDEMPREGADO)
ORDER BY NOME ;
