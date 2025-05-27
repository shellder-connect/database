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

-- Criar as tabelas

-- TIPO USUARIO
CREATE TABLE T_Tipo_Usuario (
    id_tipo_usuario     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE -- Pode ser "Comum","Voluntário", "Empresa Parceira", "Pessoa Atendida", "Profissional de Saúde",Médico, "Administrador", etc.
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

-- Inserir os dados modelos

-- T_Tipo_Usuario
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Administrador');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Voluntário');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Empresa Parceira');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Pessoa Atendida');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Profissional de Saúde');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Médico');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Comum');

-- T_Usuario
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Ana Silva', 'ana.silva@email.com', 'senha123', 1, '11999990001', 1, TO_DATE('1990-05-15', 'YYYY-MM-DD'), '12345678901', 1);
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Bruno Costa', 'bruno.costa@email.com', 'senha123', 2, '11999990002', 2, TO_DATE('1985-08-22', 'YYYY-MM-DD'), '23456789012', 1);
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Carla Mendes', 'carla.mendes@email.com', 'senha123', 3, '11999990003', 3, TO_DATE('1992-11-30', 'YYYY-MM-DD'), '34567890123', 1);
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Daniela Rocha', 'daniela.rocha@email.com', 'senha123', 4, '11999990004', 4, TO_DATE('1988-03-10', 'YYYY-MM-DD'), '45678901234', 1);
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Eduardo Lima', 'eduardo.lima@email.com', 'senha123', 5, '11999990005', 5, TO_DATE('1995-07-25', 'YYYY-MM-DD'), '56789012345', 1);
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Fernanda Alves', 'fernanda.alves@email.com', 'senha123', 6, '11999990006', 6, TO_DATE('1993-09-18', 'YYYY-MM-DD'), '67890123456', 1);
INSERT INTO T_Usuario (nome, email, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Gustavo Pereira', 'gustavo.pereira@email.com', 'senha123', 7, '11999990007', 7, TO_DATE('1987-12-05', 'YYYY-MM-DD'), '78901234567', 1);

-- T_Endereco
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua das Flores', '123', 'Centro', 'São Paulo', 'SP', '01001-000', 'Apartamento 101');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Avenida Brasil', '456', 'Jardins', 'Rio de Janeiro', 'RJ', '20040-002', 'Bloco B');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua das Acácias', '789', 'Bela Vista', 'Belo Horizonte', 'MG', '30130-110', 'Casa');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua dos Lírios', '321', 'Centro', 'Curitiba', 'PR', '80010-000', 'Sala 12');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Avenida Paulista', '1000', 'Paulista', 'São Paulo', 'SP', '01310-100', 'Cobertura');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua XV de Novembro', '55', 'Centro', 'Florianópolis', 'SC', '88010-400', 'Frente à praça');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Avenida Getúlio Vargas', '88', 'Centro', 'Porto Alegre', 'RS', '90010-150', 'Loja 3');

-- T_Categoria
INSERT INTO T_Categoria (descricao) VALUES ('Alimentos');
INSERT INTO T_Categoria (descricao) VALUES ('Roupas');
INSERT INTO T_Categoria (descricao) VALUES ('Higiene Pessoal');
INSERT INTO T_Categoria (descricao) VALUES ('Material Escolar');
INSERT INTO T_Categoria (descricao) VALUES ('Produtos de Limpeza');
INSERT INTO T_Categoria (descricao) VALUES ('Brinquedos');
INSERT INTO T_Categoria (descricao) VALUES ('Medicamentos');

-- T_Abrigo
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (100, 75, 'Abrigo Esperança - Centro');
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (80, 60, 'Casa de Apoio Vida Nova');
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (120, 90, 'Abrigo Luz do Amanhã');
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (150, 110, 'Refúgio Solidário');
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (60, 45, 'Casa de Passagem Caminhar Juntos');
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (200, 150, 'Centro de Acolhimento Vida Plena');
INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao) VALUES (90, 70, 'Abrigo Renovar');

-- T_Doacao
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (1, 'Doação de alimentos não perecíveis', 1, 50);
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (2, 'Roupas de inverno diversas', 2, 30);
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (3, 'Kit de higiene pessoal', 3, 40);
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (4, 'Mochilas e cadernos', 4, 25);
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (5, 'Produtos de limpeza variados', 5, 35);
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (6, 'Brinquedos para crianças', 6, 20);
INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade) VALUES (7, 'Medicamentos básicos', 7, 15);

-- T_Distribuicao
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (1, 10, TO_TIMESTAMP('2025-05-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (2, 5, TO_TIMESTAMP('2025-05-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2);
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (3, 8, TO_TIMESTAMP('2025-05-03 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 3);
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (4, 12, TO_TIMESTAMP('2025-05-04 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 4);
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (5, 7, TO_TIMESTAMP('2025-05-05 16:20:00', 'YYYY-MM-DD HH24:MI:SS'), 5);
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (6, 9, TO_TIMESTAMP('2025-05-06 13:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6);
INSERT INTO T_Distribuicao (id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida) VALUES (7, 6, TO_TIMESTAMP('2025-05-07 15:55:00', 'YYYY-MM-DD HH24:MI:SS'), 7);

-- T_Feedbacks
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (5, 'Excelente atendimento e suporte.', TO_TIMESTAMP('2025-05-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (4, 'Bom serviço, mas pode melhorar.', TO_TIMESTAMP('2025-05-02 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2);
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (3, 'Atendimento razoável.', TO_TIMESTAMP('2025-05-03 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), 3);
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (5, 'Muito satisfeito com o serviço.', TO_TIMESTAMP('2025-05-04 15:45:00', 'YYYY-MM-DD HH24:MI:SS'), 4);
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (2, 'Precisa de melhorias.', TO_TIMESTAMP('2025-05-05 16:20:00', 'YYYY-MM-DD HH24:MI:SS'), 5);
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (4, 'Bom, mas com alguns problemas.', TO_TIMESTAMP('2025-05-06 17:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6);
INSERT INTO T_Feedbacks (nota, comentario, data_feedback, id_usuario) VALUES (5, 'Serviço excepcional!', TO_TIMESTAMP('2025-05-07 18:55:00', 'YYYY-MM-DD HH24:MI:SS'), 7);

-- T_Registro_Evento
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Reunião de planejamento semanal.', TO_TIMESTAMP('2025-05-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, '01001-000', 1);
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Entrega de doações recebidas.', TO_TIMESTAMP('2025-05-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, '02002-000', 2);
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Treinamento de voluntários.', TO_TIMESTAMP('2025-05-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 3, '03003-000', 3);
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Visita de inspeção da prefeitura.', TO_TIMESTAMP('2025-05-04 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 4, '04004-000', 4);
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Campanha de arrecadação.', TO_TIMESTAMP('2025-05-05 16:20:00', 'YYYY-MM-DD HH24:MI:SS'), 5, '05005-000', 5);
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Sessão de feedback com atendidos.', TO_TIMESTAMP('2025-05-06 13:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6, '06006-000', 6);
INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo) VALUES ('Evento de integração comunitária.', TO_TIMESTAMP('2025-05-07 15:55:00', 'YYYY-MM-DD HH24:MI:SS'), 7, '07007-000', 7);


