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
DROP TABLE T_Distribuicao CASCADE CONSTRAINTS;
DROP TABLE T_Feedbacks CASCADE CONSTRAINTS;
DROP TABLE T_Registro_Evento CASCADE CONSTRAINTS;

-- TIPO USUARIO
CREATE TABLE T_Tipo_Usuario (
    id_tipo_usuario     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE -- Pode ser "Comum","Voluntário", "Empresa Parceira", "Pessoa Atendida", "Profissional de Saúde",Médico, "Administrador", etc.
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
    descricao       VARCHAR2(50) NOT NULL UNIQUE -- Pode ser "Alimentos", "Roupas", "Higiene", etc.
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


-- DISTRIBUICAO
CREATE TABLE T_Distribuicao (
    id_distribuicao     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_doacao           NUMBER NOT NULL,
    qtd_destinada       NUMBER,
    data_destinada      TIMESTAMP,
    id_pessoa_atendida  NUMBER NOT NULL,
    CONSTRAINT fk_distribuicao_doacao FOREIGN KEY (id_doacao) REFERENCES T_Doacao(id_doacao)
);


-- FEEDBACK
CREATE TABLE T_Feedbacks (
    id_feedback     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nota            NUMBER,
    comentario      VARCHAR2(200),
    data_feedback   TIMESTAMP,
    id_usuario      NUMBER NOT NULL,
    CONSTRAINT fk_feedback_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

-- REGISTRO EVENTO
CREATE TABLE T_Registro_Evento (
    id_registro_evento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao          VARCHAR2(255), -- mensagem, pode ser do mural ou outro tipo de evento.
    data_hora          TIMESTAMP,
    id_usuario         NUMBER NOT NULL,
    localizacao        VARCHAR2(200),
    id_abrigo          NUMBER NOT NULL, -- registro que será vinculado a um abrigo específico
    CONSTRAINT fk_registro_evento_abrigo FOREIGN KEY (id_abrigo) REFERENCES T_Abrigo(id_abrigo),
    CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);