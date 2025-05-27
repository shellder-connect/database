SET SERVEROUTPUT ON;

-- Nome dos Integrantes: 
-- Claudio Silva Bispo RM553472
-- Patricia Naomi Yamagishi RM552981

-- Deletar tabelas caso já existam
DROP TABLE T_Usuario CASCADE CONSTRAINTS;
DROP TABLE T_Tipo_Usuario CASCADE CONSTRAINTS;
DROP TABLE T_Endereco CASCADE CONSTRAINTS;
DROP TABLE T_Categoria CASCADE CONSTRAINTS;
DROP TABLE T_Abrigo CASCADE CONSTRAINTS;
DROP TABLE T_Doacao CASCADE CONSTRAINTS;
DROP TABLE T_Pessoa_Atendida CASCADE CONSTRAINTS;
DROP TABLE T_Distribuicao CASCADE CONSTRAINTS;
DROP TABLE T_Categoria_Voluntario CASCADE CONSTRAINTS;
DROP TABLE T_Disponibilidade CASCADE CONSTRAINTS;
DROP TABLE T_Voluntario CASCADE CONSTRAINTS;
DROP TABLE T_Empresa_Parceira CASCADE CONSTRAINTS;
DROP TABLE T_Especialidade CASCADE CONSTRAINTS;
DROP TABLE T_Feedbacks CASCADE CONSTRAINTS;
DROP TABLE T_Profissional_Saude CASCADE CONSTRAINTS;
DROP TABLE T_Mural_Emergencia CASCADE CONSTRAINTS;
DROP TABLE T_Registro_Evento CASCADE CONSTRAINTS;

-- TIPO USUARIO
CREATE TABLE T_Tipo_Usuario (
    id_tipo_usuario     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE
);

-- ENDERECO
CREATE TABLE T_Endereco (
    id_endereco     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rua             VARCHAR2(100),
    numero          VARCHAR2(100),
    bairro          VARCHAR2(100),
    cidade          VARCHAR2(100),
    estado          VARCHAR2(100),
    cep             VARCHAR2(10),
    complemento     VARCHAR2(255)
);

-- USUARIO
CREATE TABLE T_Usuario (
    id_usuario          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome                VARCHAR2(100),
    username            VARCHAR2(100) UNIQUE NOT NULL,
    senha               VARCHAR2(255) NOT NULL,
    id_tipo_usuario     NUMBER NOT NULL,
    telefone            VARCHAR2(20),
    id_endereco         NUMBER NOT NULL,
    data_nascimento     DATE,
    documento           VARCHAR2(20),
    status              NUMBER(1) DEFAULT 1,
    CONSTRAINT fk_usuario_tipo FOREIGN KEY (id_tipo_usuario) REFERENCES T_Tipo_Usuario(id_tipo_usuario),
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (id_endereco) REFERENCES T_Endereco(id_endereco)
);

-- CATEGORIA
CREATE TABLE T_Categoria (
    id_categoria    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao       VARCHAR2(50) NOT NULL UNIQUE
);

-- ABRIGO
CREATE TABLE T_Abrigo (
    id_abrigo           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    capacidade_total    NUMBER,
    ocupacao_atual      NUMBER,
    descricao           VARCHAR2(200)
);

-- DOACAO
CREATE TABLE T_Doacao (
    id_doacao       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_abrigo       NUMBER NOT NULL,
    descricao       VARCHAR2(200),
    id_categoria    NUMBER NOT NULL,
    quantidade      NUMBER,
    CONSTRAINT fk_doacao_abrigo FOREIGN KEY (id_abrigo) REFERENCES T_Abrigo(id_abrigo),
    CONSTRAINT fk_doacao_categoria FOREIGN KEY (id_categoria) REFERENCES T_Categoria(id_categoria)
);

-- PESSOA ATENDIDA
CREATE TABLE T_Pessoa_Atendida (
    id_pessoa_atendida INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    servico_desejado   VARCHAR2(200),
    observacao         VARCHAR2(200),
    CONSTRAINT fk_pessoa_atendida_usuario FOREIGN KEY (id_pessoa_atendida) REFERENCES T_Usuario(id_usuario)
);

-- DISTRIBUICAO
CREATE TABLE T_Distribuicao (
    id_distribuicao     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_doacao           NUMBER NOT NULL,
    qtd_destinada       NUMBER,
    data_destinada      TIMESTAMP,
    id_pessoa_atendida  NUMBER NOT NULL,
    CONSTRAINT fk_distribuicao_doacao FOREIGN KEY (id_doacao) REFERENCES T_Doacao(id_doacao),
    CONSTRAINT fk_distribuicao_pessoa FOREIGN KEY (id_pessoa_atendida) REFERENCES T_Pessoa_Atendida(id_pessoa_atendida)
);

-- CATEGORIA VOLUNTARIO
CREATE TABLE T_Categoria_Voluntario (
    id_categoria_voluntario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao               VARCHAR2(100) NOT NULL UNIQUE
);

-- DISPONIBILIDADE
CREATE TABLE T_Disponibilidade (
    id_disponibilidade INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao          VARCHAR2(50) NOT NULL UNIQUE
);

-- VOLUNTARIO
CREATE TABLE T_Voluntario (
    id_voluntario           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_categoria_voluntario NUMBER NOT NULL,
    id_disponibilidade      NUMBER NOT NULL,
    CONSTRAINT fk_voluntario_usuario FOREIGN KEY (id_voluntario) REFERENCES T_Usuario(id_usuario),
    CONSTRAINT fk_voluntario_categoria FOREIGN KEY (id_categoria_voluntario) REFERENCES T_Categoria_Voluntario(id_categoria_voluntario),
    CONSTRAINT fk_voluntario_disponibilidade FOREIGN KEY (id_disponibilidade) REFERENCES T_Disponibilidade(id_disponibilidade)
);

-- EMPRESA PARCEIRA
CREATE TABLE T_Empresa_Parceira (
    id_empresa_parceira INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_categoria        NUMBER NOT NULL,
    servico_oferecido   VARCHAR2(200),
    CONSTRAINT fk_empresa_usuario FOREIGN KEY (id_empresa_parceira) REFERENCES T_Usuario(id_usuario),
    CONSTRAINT fk_empresa_categoria FOREIGN KEY (id_categoria) REFERENCES T_Categoria(id_categoria)
);

-- ESPECIALIDADE
CREATE TABLE T_Especialidade (
    id_especialidade INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao        VARCHAR2(100)
);

-- FEEDBACK
CREATE TABLE T_Feedbacks (
    id_feedback     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nota            NUMBER,
    comentario      VARCHAR2(200),
    data_feedback   TIMESTAMP,
    id_avaliado     NUMBER NOT NULL,
    id_usuario      NUMBER NOT NULL,
    CONSTRAINT fk_feedback_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario),
    CONSTRAINT fk_feedback_avaliado FOREIGN KEY (id_avaliado) REFERENCES T_Usuario(id_usuario)
);

-- PROFISSIONAL SAUDE
CREATE TABLE T_Profissional_Saude (
    id_profissional         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_especialidade        NUMBER NOT NULL,
    CONSTRAINT fk_profissional_usuario FOREIGN KEY (id_profissional) REFERENCES T_Usuario(id_usuario),
    CONSTRAINT fk_profissional_especialidade FOREIGN KEY (id_especialidade) REFERENCES T_Especialidade(id_especialidade)
);

-- MURAL EMERGENCIA
CREATE TABLE T_Mural_Emergencia (
    id_mural                 INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario               NUMBER NOT NULL,
    mensagem                 VARCHAR2(255),
    data_hora                TIMESTAMP,
    CONSTRAINT fk_usuario_mural FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

-- REGISTRO EVENTO
CREATE TABLE T_Registro_Evento (
    id_registro_evento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao          VARCHAR2(255),
    data_hora          TIMESTAMP,
    id_usuario         NUMBER NOT NULL,
    localizacao        VARCHAR2(200),
    CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);
