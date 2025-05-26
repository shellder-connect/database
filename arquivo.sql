SET SERVEROUTPUT ON;
-- Nome dos Integrantes: 
-- Claudio Silva Bispo RM553472
-- Patricia Naomi Yamagishi RM552981

-- Deletar tabelas caso já existam
DROP TABLE Usuario CASCADE CONSTRAINTS;
DROP TABLE Tipo_Usuario CASCADE CONSTRAINTS;
DROP TABLE Status_Usuario CASCADE CONSTRAINTS;
DROP TABLE Endereco CASCADE CONSTRAINTS;
DROP TABLE Categoria CASCADE CONSTRAINTS;
DROP TABLE Abrigo CASCADE CONSTRAINTS;
DROP TABLE Doacao CASCADE CONSTRAINTS;
DROP TABLE Pessoa_Atendida CASCADE CONSTRAINTS;
DROP TABLE Distribuicao CASCADE CONSTRAINTS;
DROP TABLE Voluntario CASCADE CONSTRAINTS;
DROP TABLE Categoria_Voluntario CASCADE CONSTRAINTS;
DROP TABLE Disponibilidade CASCADE CONSTRAINTS;
DROP TABLE Empresa_Parceira CASCADE CONSTRAINTS;
DROP TABLE Especialidade CASCADE CONSTRAINTS;
DROP TABLE Feedbacks CASCADE CONSTRAINTS;
DROP TABLE Profissional_Saude CASCADE CONSTRAINTS;
DROP TABLE Mural_Emergencia CASCADE CONSTRAINTS;
DROP TABLE Tipo_Mural_Emergencia CASCADE CONSTRAINTS;
DROP TABLE Forma_Atendimento CASCADE CONSTRAINTS;
DROP TABLE Status_Apoio CASCADE CONSTRAINTS;
DROP TABLE Registro_Evento CASCADE CONSTRAINTS;
DROP TABLE Tipo_Evento CASCADE CONSTRAINTS;

-- TIPO USUARIO
CREATE TABLE Tipo_Usuario (
    id_tipo_usuario     INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE
);

-- STATUS USUARIO
CREATE TABLE Status_Usuario (
    id_status_usuario   INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao           VARCHAR2(10) NOT NULL UNIQUE
);

-- ENDERECO
CREATE TABLE Endereco (
    id_endereco     INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    rua             VARCHAR2(100),
    numero          VARCHAR2(100),
    bairro          VARCHAR2(100),
    cidade          VARCHAR2(100),
    estado          VARCHAR2(100),
    cep             VARCHAR2(10),
    complemento     VARCHAR2(255)
);

-- USUARIO
CREATE TABLE Usuario (
    id_usuario          INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nome                VARCHAR2(100),
    username            VARCHAR2(100) UNIQUE NOT NULL,
    senha               VARCHAR2(255) NOT NULL,
    id_tipo_usuario     NUMBER NOT NULL,
    telefone            VARCHAR2(20),
    id_endereco         NUMBER NOT NULL,
    data_nascimento     DATE,
    documento           VARCHAR2(20),
    id_status_usuario   NUMBER NOT NULL,
    CONSTRAINT fk_usuario_tipo FOREIGN KEY (id_tipo_usuario) REFERENCES Tipo_Usuario(id_tipo_usuario),
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco),
    CONSTRAINT fk_usuario_status FOREIGN KEY (id_status_usuario) REFERENCES Status_Usuario(id_status_usuario)
);

-- CATEGORIA
CREATE TABLE Categoria (
    id_categoria    INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao       VARCHAR2(50) NOT NULL UNIQUE
);

-- ABRIGO
CREATE TABLE Abrigo (
    id_abrigo           INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    capacidade_total    NUMBER,
    ocupacao_atual      NUMBER,
    descricao           VARCHAR2(200)
);

-- DOACAO
CREATE TABLE Doacao (
    id_doacao       INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_abrigo       NUMBER NOT NULL,
    descricao       VARCHAR2(200),
    id_categoria    NUMBER NOT NULL,
    quantidade      NUMBER,
    CONSTRAINT fk_doacao_abrigo FOREIGN KEY (id_abrigo) REFERENCES Abrigo(id_abrigo),
    CONSTRAINT fk_doacao_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- PESSOA ATENDIDA
CREATE TABLE Pessoa_Atendida (
    id_pessoa_atendida      INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    servico_desejado        VARCHAR2(200),
    observacoes             VARCHAR2(200),
    CONSTRAINT fk_pessoa_atendida_usuario FOREIGN KEY (id_pessoa_atendida) REFERENCES Usuario(id_usuario)
);

-- DISTRIBUICAO
CREATE TABLE Distribuicao (
    id_distribuicao         INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_doacao               NUMBER NOT NULL,
    qtd_destinada           NUMBER,
    data_destinada          TIMESTAMP,
    id_pessoa_atendida      NUMBER NOT NULL,
    CONSTRAINT fk_distribuicao_doacao FOREIGN KEY (id_doacao) REFERENCES Doacao(id_doacao),
    CONSTRAINT fk_distribuicao_pessoa FOREIGN KEY (id_pessoa_atendida) REFERENCES Pessoa_Atendida(id_pessoa_atendida)
);

-- CATEGORIA VOLUNTARIO
CREATE TABLE Categoria_Voluntario (
    id_categoria_voluntario     INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao                   VARCHAR2(100) NOT NULL UNIQUE
);

-- DISPONIBILIDADE
CREATE TABLE Disponibilidade (
    id_disponibilidade  INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE
);

-- VOLUNTARIO
CREATE TABLE Voluntario (
    id_voluntario               INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_categoria_voluntario     NUMBER NOT NULL,
    id_disponibilidade          NUMBER NOT NULL,
    CONSTRAINT fk_voluntario_usuario FOREIGN KEY (id_voluntario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_voluntario_categoria FOREIGN KEY (id_categoria_voluntario) REFERENCES Categoria_Voluntario(id_categoria_voluntario),
    CONSTRAINT fk_voluntario_disponibilidade FOREIGN KEY (id_disponibilidade) REFERENCES Disponibilidade(id_disponibilidade)
);

-- EMPRESA PARCEIRA
CREATE TABLE Empresa_Parceira (
    id_empresa_parceira     INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_categoria            NUMBER NOT NULL,
    servico_oferecido       VARCHAR2(200),
    CONSTRAINT fk_empresa_usuario FOREIGN KEY (id_empresa_parceira) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_empresa_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- ESPECIALIDADE
CREATE TABLE Especialidade (
    id_especialidade    INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao           VARCHAR2(100)
);

-- FORMA DE ATENDIMENTO
CREATE TABLE Forma_Atendimento (
    id_forma_atendimento    INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao               VARCHAR2(50) NOT NULL UNIQUE
);

-- FEEDBACK
CREATE TABLE Feedbacks (
    id_feedback     INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nota            NUMBER,
    comentario      VARCHAR2(200),
    data_feedback   TIMESTAMP,
    id_avaliado     NUMBER NOT NULL,
    id_usuario      NUMBER NOT NULL,
    CONSTRAINT fk_feedback_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_feedback_avaliado FOREIGN KEY (id_avaliado) REFERENCES Usuario(id_usuario)
);

-- PROFISSIONAL SAUDE
CREATE TABLE Profissional_Saude (
    id_profissional         INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_especialidade        NUMBER NOT NULL,
    id_forma_atendimento    NUMBER NOT NULL,
    CONSTRAINT fk_profissional_usuario FOREIGN KEY (id_profissional) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_profissional_especialidade FOREIGN KEY (id_especialidade) REFERENCES Especialidade(id_especialidade),
    CONSTRAINT fk_forma_atendimento FOREIGN KEY (id_forma_atendimento) REFERENCES Forma_Atendimento(id_forma_atendimento)
);

-- TIPO MURAL EMERGENCIA
CREATE TABLE Tipo_Mural_Emergencia (
    id_tipo_mural_emergencia    INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao                   VARCHAR2(50) NOT NULL UNIQUE
);

-- STATUS APOIO
CREATE TABLE Status_Apoio (
    id_status_apoio      INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao            VARCHAR2(50) NOT NULL UNIQUE
);

-- MURAL EMERGENCIA
CREATE TABLE Mural_Emergencia (
    id_mural                    INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_usuario                  NUMBER NOT NULL,
    mensagem                    VARCHAR2(255),
    id_tipo_mural_emergencia    NUMBER NOT NULL,
    id_status_apoio             NUMBER NOT NULL,
    data_hora                   TIMESTAMP,
    CONSTRAINT fk_usuario_mural FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_mural_tipo    FOREIGN KEY (id_tipo_mural_emergencia) REFERENCES Tipo_Mural_Emergencia(id_tipo_mural_emergencia),
    CONSTRAINT fk_mural_status  FOREIGN KEY (id_status_apoio) REFERENCES Status_Apoio(id_status_apoio)
);

-- TIPO EVENTO
CREATE TABLE Tipo_Evento (
    id_tipo_evento  INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    descricao       VARCHAR2(255)
);

-- REGISTRO EVENTO
CREATE TABLE Registro_Evento (
    id_registro_evento  INTEGER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_tipo_evento      NUMBER NOT NULL,  
    descricao           VARCHAR2(255),
    data_hora           TIMESTAMP,
    id_usuario          NUMBER NOT NULL,
    localizacao         VARCHAR2(200),
    CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_registro_tipo FOREIGN KEY (id_tipo_evento) REFERENCES Tipo_Evento(id_tipo_evento)
);
