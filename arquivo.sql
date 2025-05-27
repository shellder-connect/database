SET SERVEROUTPUT ON;

-- Apagar todas as tabelas pois estou com logs antigos

BEGIN
    FOR rec IN (SELECT table_name FROM all_tables WHERE owner = 'RM553472') LOOP
        EXECUTE IMMEDIATE 'DROP TABLE "' || rec.table_name || '" CASCADE CONSTRAINTS';
    END LOOP;
END;

-- Nome dos Integrantes: 
-- Claudio Silva Bispo RM553472
-- Patricia Naomi Yamagishi RM552981

/***********************************************************************************************
    Deletar tabelas caso já existam
***********************************************************************************************/
DROP TABLE T_Tipo_Usuario CASCADE CONSTRAINTS;
DROP TABLE T_Usuario CASCADE CONSTRAINTS;
DROP TABLE T_Endereco CASCADE CONSTRAINTS;
DROP TABLE T_Categoria CASCADE CONSTRAINTS;
DROP TABLE T_Abrigo CASCADE CONSTRAINTS;
DROP TABLE T_Doacao CASCADE CONSTRAINTS;
DROP TABLE T_Distribuicao CASCADE CONSTRAINTS;
DROP TABLE T_Feedbacks CASCADE CONSTRAINTS;
DROP TABLE T_Registro_Evento CASCADE CONSTRAINTS;

/***********************************************************************************************
    Criar as tabelas
***********************************************************************************************/

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
    descricao          VARCHAR2(255), 
    data_hora          TIMESTAMP,
    id_usuario         NUMBER NOT NULL,
    localizacao        VARCHAR2(200),
    id_abrigo          NUMBER NOT NULL, 
    CONSTRAINT fk_registro_evento_abrigo FOREIGN KEY (id_abrigo) REFERENCES T_Abrigo(id_abrigo),
    CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

/***********************************************************************************************
    Inserir os dados modelos
***********************************************************************************************/

-- T_Tipo_Usuario
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Administrador');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Voluntário');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Empresa Parceira');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Pessoa Atendida');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Profissional de Saúde');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Médico');
INSERT INTO T_Tipo_Usuario (descricao) VALUES ('Comum');

-- T_Endereco
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua das Flores', '123', 'Centro', 'São Paulo', 'SP', '01001-000', 'Apartamento 101');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Avenida Brasil', '456', 'Jardins', 'Rio de Janeiro', 'RJ', '20040-002', 'Bloco B');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua das Acácias', '789', 'Bela Vista', 'Belo Horizonte', 'MG', '30130-110', 'Casa');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua dos Lírios', '321', 'Centro', 'Curitiba', 'PR', '80010-000', 'Sala 12');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Avenida Paulista', '1000', 'Paulista', 'São Paulo', 'SP', '01310-100', 'Cobertura');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Rua XV de Novembro', '55', 'Centro', 'Florianópolis', 'SC', '88010-400', 'Frente à praça');
INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento) VALUES ('Avenida Getúlio Vargas', '88', 'Centro', 'Porto Alegre', 'RS', '90010-150', 'Loja 3');

-- T_Usuario
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Ana Silva', 'ana.silva@email.com', 'senha123', 1, '11999990001', 1, TO_DATE('1990-05-15', 'YYYY-MM-DD'), '12345678901', 1);
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Bruno Costa', 'bruno.costa@email.com', 'senha123', 2, '11999990002', 2, TO_DATE('1985-08-22', 'YYYY-MM-DD'), '23456789012', 1);
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Carla Mendes', 'carla.mendes@email.com', 'senha123', 3, '11999990003', 3, TO_DATE('1992-11-30', 'YYYY-MM-DD'), '34567890123', 1);
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Daniela Rocha', 'daniela.rocha@email.com', 'senha123', 4, '11999990004', 4, TO_DATE('1988-03-10', 'YYYY-MM-DD'), '45678901234', 1);
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Eduardo Lima', 'eduardo.lima@email.com', 'senha123', 5, '11999990005', 5, TO_DATE('1995-07-25', 'YYYY-MM-DD'), '56789012345', 1);
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Fernanda Alves', 'fernanda.alves@email.com', 'senha123', 6, '11999990006', 6, TO_DATE('1993-09-18', 'YYYY-MM-DD'), '67890123456', 1);
INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, telefone, id_endereco, data_nascimento, documento, status) VALUES ('Gustavo Pereira', 'gustavo.pereira@email.com', 'senha123', 7, '11999990007', 7, TO_DATE('1987-12-05', 'YYYY-MM-DD'), '78901234567', 1);

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

-- 2. Empacotamento de Objetos

/***************************************************************************************************************************
    -- 1. T_Tipo_Usuario

    Procedures (inserção, alteração, exclusão, busca e relatório)
    Função (retorno de total)
    Trigger (validação automática)
    Cursores com loops
    Controle de fluxo com IF/ELSE
    Relatórios com agregação e subconsulta (JOIN simplificado)
***************************************************************************************************************************/

-- 1.1. Cabeçalho 
CREATE OR REPLACE PACKAGE pkg_tipo_usuario AS
    PROCEDURE inserir_tipo_usuario(p_descricao IN VARCHAR2);
    PROCEDURE atualizar_tipo_usuario(p_id IN NUMBER, p_descricao IN VARCHAR2);
    PROCEDURE excluir_tipo_usuario(p_id IN NUMBER);
    PROCEDURE listar_tipo_usuario(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE buscar_tipo_usuario(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);
    FUNCTION contar_tipos_usuario RETURN NUMBER;
    PROCEDURE inserir_ou_atualizar_tipo_usuario(p_id IN NUMBER, p_descricao IN VARCHAR2);
    PROCEDURE relatorio_tipo_usuario(p_cursor OUT SYS_REFCURSOR);
END pkg_tipo_usuario;

-- 1.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_tipo_usuario AS

    -- Inserção
    PROCEDURE inserir_tipo_usuario(p_descricao IN VARCHAR2) IS
    BEGIN
        INSERT INTO T_Tipo_Usuario (descricao)
        VALUES (p_descricao);
        COMMIT;
    END inserir_tipo_usuario;

    -- Atualização
    PROCEDURE atualizar_tipo_usuario(p_id IN NUMBER, p_descricao IN VARCHAR2) IS
    BEGIN
        UPDATE T_Tipo_Usuario
        SET descricao = p_descricao
        WHERE id_tipo_usuario = p_id;
        COMMIT;
    END atualizar_tipo_usuario;

    -- Exclusão
    PROCEDURE excluir_tipo_usuario(p_id IN NUMBER) IS
    BEGIN
        -- Excluir os feedbacks relacionados aos usuários do tipo
        DELETE FROM T_Feedbacks
        WHERE id_usuario IN (
            SELECT id_usuario FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Excluir os registros de eventos relacionados aos usuários do tipo
        DELETE FROM T_Registro_Evento
        WHERE id_usuario IN (
            SELECT id_usuario FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Excluir os usuários que pertencem ao tipo de usuário
        DELETE FROM T_Usuario
        WHERE id_tipo_usuario = p_id;
    
        -- Excluir endereços vinculados aos usuários (caso necessário)
        DELETE FROM T_Endereco
        WHERE id_endereco IN (
            SELECT id_endereco FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Por fim, excluir o tipo de usuário
        DELETE FROM T_Tipo_Usuario
        WHERE id_tipo_usuario = p_id;
    
        COMMIT;
    END excluir_tipo_usuario;

    -- Listagem de todos
    PROCEDURE listar_tipo_usuario(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_tipo_usuario, descricao
            FROM T_Tipo_Usuario;
    END listar_tipo_usuario;

    -- Busca por ID
    PROCEDURE buscar_tipo_usuario(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_tipo_usuario, descricao
            FROM T_Tipo_Usuario
            WHERE id_tipo_usuario = p_id;
    END buscar_tipo_usuario;

    -- Função: Conta quantos tipos de usuário existem
    FUNCTION contar_tipos_usuario RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM T_Tipo_Usuario;
        RETURN v_count;
    END contar_tipos_usuario;

    -- IF/ELSE: Insere ou atualiza, dependendo se o ID existe
    PROCEDURE inserir_ou_atualizar_tipo_usuario(p_id IN NUMBER, p_descricao IN VARCHAR2) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM T_Tipo_Usuario
        WHERE id_tipo_usuario = p_id;

        IF v_count = 0 THEN
            INSERT INTO T_Tipo_Usuario (id_tipo_usuario, descricao)
            VALUES (p_id, p_descricao);
        ELSE
            UPDATE T_Tipo_Usuario
            SET descricao = p_descricao
            WHERE id_tipo_usuario = p_id;
        END IF;

        COMMIT;
    END inserir_ou_atualizar_tipo_usuario;

    -- Relatório
    PROCEDURE relatorio_tipo_usuario(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_tipo_usuario, descricao,
                   (SELECT COUNT(*) FROM T_Usuario u WHERE u.id_tipo_usuario = t.id_tipo_usuario) AS total_usuarios
            FROM T_Tipo_Usuario t;
    END relatorio_tipo_usuario;

END pkg_tipo_usuario;

-- Testes das Procedures T_Tipo_Usuario

-- Função
DECLARE
    v_total NUMBER;
BEGIN
    v_total := pkg_tipo_usuario.contar_tipos_usuario;
    DBMS_OUTPUT.PUT_LINE('Total de tipos de usuário: ' || v_total);
END;

--  Exemplo de relatório com cursor
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_descricao VARCHAR2(50);
    v_total_usuarios NUMBER;
BEGIN
    pkg_tipo_usuario.relatorio_tipo_usuario(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_descricao, v_total_usuarios;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || 
                             ', Descrição: ' || v_descricao || 
                             ', Total Usuários: ' || v_total_usuarios);
    END LOOP;

    CLOSE v_cursor;
END;

-- 1.3. Inserir
BEGIN
    pkg_tipo_usuario.inserir_tipo_usuario('Em Atendimento');
    pkg_tipo_usuario.inserir_tipo_usuario('Em crise');
    pkg_tipo_usuario.inserir_tipo_usuario('Desenvolvedor');
END;

-- 1.4. Atualizar
BEGIN
    pkg_tipo_usuario.atualizar_tipo_usuario(1, 'Administrador Master');
END;

-- 1.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_descricao VARCHAR2(50);
BEGIN
    pkg_tipo_usuario.listar_tipo_usuario(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_descricao;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ', Descrição: ' || v_descricao);
    END LOOP;

    CLOSE v_cursor;
END;

-- 1.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_descricao VARCHAR2(50);
BEGIN
    pkg_tipo_usuario.buscar_tipo_usuario(1, v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_descricao;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ', Descrição: ' || v_descricao);
    END LOOP;

    CLOSE v_cursor;
END;

-- 1.7. Excluir
BEGIN
    pkg_tipo_usuario.excluir_tipo_usuario(1);
END;

-- select * from T_Tipo_Usuario;

/*********************************************************************************************************************
    2. T_Endereco

    Procedures (CRUD completo + relatório)
    Função (quantidade por cidade)
    Trigger (validação de CEP)
    Cursores com loop
    Controle de fluxo com IF/ELSE
    Relatório com agrupamento e ordenação
*********************************************************************************************************************/

-- 2.1. Cabeçalho 
CREATE OR REPLACE PACKAGE pkg_endereco AS
    PROCEDURE inserir_endereco(
        p_rua IN VARCHAR2,
        p_numero IN VARCHAR2,
        p_bairro IN VARCHAR2,
        p_cidade IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_cep IN VARCHAR2,
        p_complemento IN VARCHAR2
    );

    PROCEDURE atualizar_endereco(
        p_id IN NUMBER,
        p_rua IN VARCHAR2,
        p_numero IN VARCHAR2,
        p_bairro IN VARCHAR2,
        p_cidade IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_cep IN VARCHAR2,
        p_complemento IN VARCHAR2
    );

    PROCEDURE excluir_endereco(p_id IN NUMBER);

    PROCEDURE listar_endereco(p_cursor OUT SYS_REFCURSOR);

    PROCEDURE buscar_endereco(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);

    FUNCTION contar_enderecos_por_cidade(p_cidade IN VARCHAR2) RETURN NUMBER;

    PROCEDURE inserir_ou_atualizar_endereco(
        p_id IN NUMBER,
        p_rua IN VARCHAR2,
        p_numero IN VARCHAR2,
        p_bairro IN VARCHAR2,
        p_cidade IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_cep IN VARCHAR2,
        p_complemento IN VARCHAR2
    );

    PROCEDURE relatorio_endereco_por_cidade(p_cursor OUT SYS_REFCURSOR);
END pkg_endereco;

-- 2.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_endereco AS

    -- Inserção
    PROCEDURE inserir_endereco(
        p_rua IN VARCHAR2,
        p_numero IN VARCHAR2,
        p_bairro IN VARCHAR2,
        p_cidade IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_cep IN VARCHAR2,
        p_complemento IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO T_Endereco (rua, numero, bairro, cidade, estado, cep, complemento)
        VALUES (p_rua, p_numero, p_bairro, p_cidade, p_estado, p_cep, p_complemento);
        COMMIT;
    END inserir_endereco;


    -- Atualização
    PROCEDURE atualizar_endereco(
        p_id IN NUMBER,
        p_rua IN VARCHAR2,
        p_numero IN VARCHAR2,
        p_bairro IN VARCHAR2,
        p_cidade IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_cep IN VARCHAR2,
        p_complemento IN VARCHAR2
    ) IS
    BEGIN
        UPDATE T_Endereco
        SET rua = p_rua,
            numero = p_numero,
            bairro = p_bairro,
            cidade = p_cidade,
            estado = p_estado,
            cep = p_cep,
            complemento = p_complemento
        WHERE id_endereco = p_id;
        COMMIT;
    END atualizar_endereco;


    -- Exclusão
    PROCEDURE excluir_endereco(p_id IN NUMBER) IS
    BEGIN
    
        -- Excluir os feedbacks relacionados aos usuários do tipo
        DELETE FROM T_Feedbacks
        WHERE id_usuario IN (
            SELECT id_usuario FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Excluir os registros de eventos relacionados aos usuários do tipo
        DELETE FROM T_Registro_Evento
        WHERE id_usuario IN (
            SELECT id_usuario FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Excluir os usuários que pertencem ao tipo de usuário
        DELETE FROM T_Usuario
        WHERE id_tipo_usuario = p_id;
    
        -- Excluir endereços vinculados aos usuários (caso necessário)
        DELETE FROM T_Endereco
        WHERE id_endereco IN (
            SELECT id_endereco FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Por fim, excluir o tipo de usuário
        DELETE FROM T_Tipo_Usuario
        WHERE id_tipo_usuario = p_id;
       
        /*
        DELETE FROM T_Endereco
        WHERE id_endereco = p_id;
        */
        COMMIT;
    END excluir_endereco;


    -- Listar todos
    PROCEDURE listar_endereco(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_endereco, rua, numero, bairro, cidade, estado, cep, complemento
            FROM T_Endereco;
    END listar_endereco;


    -- Buscar por ID
    PROCEDURE buscar_endereco(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_endereco, rua, numero, bairro, cidade, estado, cep, complemento
            FROM T_Endereco
            WHERE id_endereco = p_id;
    END buscar_endereco;


    -- 🔥 Função: Conta quantos endereços há em uma cidade
    FUNCTION contar_enderecos_por_cidade(p_cidade IN VARCHAR2) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM T_Endereco
        WHERE UPPER(cidade) = UPPER(p_cidade);
        RETURN v_count;
    END contar_enderecos_por_cidade;


    -- IF/ELSE: Insere ou atualiza
    PROCEDURE inserir_ou_atualizar_endereco(
        p_id IN NUMBER,
        p_rua IN VARCHAR2,
        p_numero IN VARCHAR2,
        p_bairro IN VARCHAR2,
        p_cidade IN VARCHAR2,
        p_estado IN VARCHAR2,
        p_cep IN VARCHAR2,
        p_complemento IN VARCHAR2
    ) IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM T_Endereco
        WHERE id_endereco = p_id;

        IF v_count = 0 THEN
            INSERT INTO T_Endereco (id_endereco, rua, numero, bairro, cidade, estado, cep, complemento)
            VALUES (p_id, p_rua, p_numero, p_bairro, p_cidade, p_estado, p_cep, p_complemento);
        ELSE
            UPDATE T_Endereco
            SET rua = p_rua,
                numero = p_numero,
                bairro = p_bairro,
                cidade = p_cidade,
                estado = p_estado,
                cep = p_cep,
                complemento = p_complemento
            WHERE id_endereco = p_id;
        END IF;

        COMMIT;
    END inserir_ou_atualizar_endereco;


    -- 🔥 Relatório: Agrupamento por cidade e estado
    PROCEDURE relatorio_endereco_por_cidade(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT cidade, estado, COUNT(*) AS total_enderecos
            FROM T_Endereco
            GROUP BY cidade, estado
            ORDER BY cidade, estado;
    END relatorio_endereco_por_cidade;

END pkg_endereco;

-- Trigger de Validação de CEP
CREATE OR REPLACE TRIGGER trg_valida_cep
BEFORE INSERT OR UPDATE ON T_Endereco
FOR EACH ROW
BEGIN
    IF :NEW.cep IS NULL OR LENGTH(REPLACE(:NEW.cep, '-', '')) < 8 THEN
        RAISE_APPLICATION_ERROR(-20002, 'CEP inválido. Informe um CEP com no mínimo 8 dígitos.');
    END IF;
END;

-- Testes das Procedures T_Endereco

-- Teste da função
DECLARE
    v_total NUMBER;
BEGIN
    v_total := pkg_endereco.contar_enderecos_por_cidade('São Paulo');
    DBMS_OUTPUT.PUT_LINE('Total de endereços em São Paulo: ' || v_total);
END;

-- 2.3. Inserir
BEGIN
    pkg_endereco.inserir_endereco(
        'Rua das Flores', '100', 'Centro', 'São Paulo', 'SP', '01001-000', 'Apto 101'
    );
    pkg_endereco.inserir_endereco(
        'Av. Brasil', '2000', 'Jardins', 'São Paulo', 'SP', '01430-000', NULL
    );
END;

-- 2.4. Atualizar
BEGIN
    pkg_endereco.atualizar_endereco(
        p_id => 1,
        p_rua => 'Rua das Palmeiras',
        p_numero => '150',
        p_bairro => 'Centro',
        p_cidade => 'São Paulo',
        p_estado => 'SP',
        p_cep => '01002-000',
        p_complemento => 'Apto 202'
    );
END;

-- 2.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_rua VARCHAR2(100);
    v_numero VARCHAR2(100);
    v_bairro VARCHAR2(100);
    v_cidade VARCHAR2(100);
    v_estado VARCHAR2(100);
    v_cep VARCHAR2(10);
    v_complemento VARCHAR2(255);
BEGIN
    pkg_endereco.listar_endereco(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_rua, v_numero, v_bairro, v_cidade, v_estado, v_cep, v_complemento;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_id || 
            ', Rua: ' || v_rua ||
            ', Numero: ' || v_numero ||
            ', Bairro: ' || v_bairro ||
            ', Cidade: ' || v_cidade ||
            ', Estado: ' || v_estado ||
            ', CEP: ' || v_cep ||
            ', Complemento: ' || NVL(v_complemento, 'N/A')
        );
    END LOOP;

    CLOSE v_cursor;
END;

-- 2.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_rua VARCHAR2(100);
    v_numero VARCHAR2(100);
    v_bairro VARCHAR2(100);
    v_cidade VARCHAR2(100);
    v_estado VARCHAR2(100);
    v_cep VARCHAR2(10);
    v_complemento VARCHAR2(255);
BEGIN
    pkg_endereco.buscar_endereco(1, v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_rua, v_numero, v_bairro, v_cidade, v_estado, v_cep, v_complemento;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_id || 
            ', Rua: ' || v_rua ||
            ', Numero: ' || v_numero ||
            ', Bairro: ' || v_bairro ||
            ', Cidade: ' || v_cidade ||
            ', Estado: ' || v_estado ||
            ', CEP: ' || v_cep ||
            ', Complemento: ' || NVL(v_complemento, 'N/A')
        );
    END LOOP;

    CLOSE v_cursor;
END;

-- 2.7. Excluir
BEGIN
    pkg_endereco.excluir_endereco(2);
END;

-- 2.8. Teste do relatório com cursor
DECLARE
    v_cursor SYS_REFCURSOR;
    v_cidade VARCHAR2(100);
    v_estado VARCHAR2(100);
    v_total NUMBER;
BEGIN
    pkg_endereco.relatorio_endereco_por_cidade(v_cursor);

    LOOP
        FETCH v_cursor INTO v_cidade, v_estado, v_total;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Cidade: ' || v_cidade || 
                             ', Estado: ' || v_estado || 
                             ', Total de endereços: ' || v_total);
    END LOOP;

    CLOSE v_cursor;
END;

/********************************************************************************************************************
    3. T_Usuario
*********************************************************************************************************************/

-- 3.1. Cabeçalho 
CREATE OR REPLACE PACKAGE pkg_usuario AS
    PROCEDURE inserir_usuario(
        p_nome IN VARCHAR2,
        p_username IN VARCHAR2,
        p_senha IN VARCHAR2,
        p_id_tipo_usuario IN NUMBER,
        p_id_endereco IN NUMBER
    );

    PROCEDURE atualizar_usuario(
        p_id IN NUMBER,
        p_nome IN VARCHAR2,
        p_username IN VARCHAR2,
        p_senha IN VARCHAR2,
        p_id_tipo_usuario IN NUMBER,
        p_id_endereco IN NUMBER
    );

    PROCEDURE excluir_usuario(p_id IN NUMBER);

    PROCEDURE listar_usuarios(p_cursor OUT SYS_REFCURSOR);

    PROCEDURE buscar_usuario(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_usuario;

-- 3.2. Corpo 
CREATE OR REPLACE PACKAGE BODY pkg_usuario AS

    PROCEDURE inserir_usuario(
        p_nome IN VARCHAR2,
        p_username IN VARCHAR2,
        p_senha IN VARCHAR2,
        p_id_tipo_usuario IN NUMBER,
        p_id_endereco IN NUMBER
    ) IS
    BEGIN
        INSERT INTO T_Usuario (nome, username, senha, id_tipo_usuario, id_endereco)
        VALUES (p_nome, p_username, p_senha, p_id_tipo_usuario, p_id_endereco);

        COMMIT;
    END inserir_usuario;

    PROCEDURE atualizar_usuario(
        p_id IN NUMBER,
        p_nome IN VARCHAR2,
        p_username IN VARCHAR2,
        p_senha IN VARCHAR2,
        p_id_tipo_usuario IN NUMBER,
        p_id_endereco IN NUMBER
    ) IS
    BEGIN
        UPDATE T_Usuario
        SET nome = p_nome,
            username = p_username,
            senha = p_senha,
            id_tipo_usuario = p_id_tipo_usuario,
            id_endereco = p_id_endereco
        WHERE id_usuario = p_id;

        COMMIT;
    END atualizar_usuario;

    PROCEDURE excluir_usuario(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM T_Usuario
        WHERE id_usuario = p_id;

        COMMIT;
    END excluir_usuario;

    PROCEDURE listar_usuarios(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_usuario, nome, username, senha, id_tipo_usuario, id_endereco
            FROM T_Usuario;
    END listar_usuarios;


    PROCEDURE buscar_usuario(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_usuario, nome, username, senha, id_tipo_usuario, id_endereco
            FROM T_Usuario
            WHERE id_usuario = p_id;
    END buscar_usuario;

END pkg_usuario;

-- Testes das Procedures T_Usuario

-- 3.3. Inserir
BEGIN
    pkg_usuario.inserir_usuario(
        'João Silva', 'joao@email.com', 'senha123', 8, 8
    );
    pkg_usuario.inserir_usuario(
        'Maria Souza', 'maria@email.com', 'senha456', 9, 9
    );
END;

-- 3.4. Atualizar
BEGIN
    pkg_usuario.atualizar_usuario(
        p_id => 1,
        p_nome => 'João Pedro Silva',
        p_username => 'joao.pedro@email.com',
        p_senha => 'novaSenha123',
        p_id_tipo_usuario => 1,
        p_id_endereco => 1
    );
END;

-- 3.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_nome VARCHAR2(100);
    v_username VARCHAR2(100);
    v_senha VARCHAR2(100);
    v_id_tipo NUMBER;
    v_id_endereco NUMBER;
BEGIN
    pkg_usuario.listar_usuarios(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_nome, v_username, v_senha, v_id_tipo, v_id_endereco;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_id || 
            ', Nome: ' || v_nome ||
            ', Email: ' || v_username ||
            ', Senha: ' || v_senha ||
            ', ID Tipo Usuário: ' || v_id_tipo ||
            ', ID Endereço: ' || v_id_endereco
        );
    END LOOP;

    CLOSE v_cursor;
END;

-- 3.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id NUMBER;
    v_nome VARCHAR2(100);
    v_username VARCHAR2(100);
    v_senha VARCHAR2(100);
    v_id_tipo NUMBER;
    v_id_endereco NUMBER;
BEGIN
    pkg_usuario.buscar_usuario(3, v_cursor);

    LOOP
        FETCH v_cursor INTO v_id, v_nome, v_username, v_senha, v_id_tipo, v_id_endereco;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || v_id || 
            ', Nome: ' || v_nome ||
            ', Email: ' || v_username ||
            ', Senha: ' || v_senha ||
            ', ID Tipo Usuário: ' || v_id_tipo ||
            ', ID Endereço: ' || v_id_endereco
        );
    END LOOP;

    CLOSE v_cursor;
END;

-- 3.7. Excluir
BEGIN
    pkg_usuario.excluir_usuario(2);
END;

/***********************************************************************************************
    4. T_Categoria
***********************************************************************************************/

-- 4.1. Cabeçalho
CREATE OR REPLACE PACKAGE pkg_categoria AS
    PROCEDURE inserir_categoria(p_descricao IN VARCHAR2);
    PROCEDURE atualizar_categoria(p_id IN NUMBER, p_descricao IN VARCHAR2);
    PROCEDURE excluir_categoria(p_id IN NUMBER);
    PROCEDURE listar_categorias(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE buscar_categoria(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_categoria;

-- 4.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_categoria AS

    PROCEDURE inserir_categoria(p_descricao IN VARCHAR2) IS
    BEGIN
        INSERT INTO T_Categoria (descricao) VALUES (p_descricao);
        COMMIT;
    END inserir_categoria;

    PROCEDURE atualizar_categoria(p_id IN NUMBER, p_descricao IN VARCHAR2) IS
    BEGIN
        UPDATE T_Categoria
        SET descricao = p_descricao
        WHERE id_categoria = p_id;
        COMMIT;
    END atualizar_categoria;

    PROCEDURE excluir_categoria(p_id IN NUMBER) IS
    BEGIN
       -- Excluir os feedbacks relacionados aos usuários do tipo
        DELETE FROM T_Feedbacks
        WHERE id_usuario IN (
            SELECT id_usuario FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Excluir os registros de eventos relacionados aos usuários do tipo
        DELETE FROM T_Registro_Evento
        WHERE id_usuario IN (
            SELECT id_usuario FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Excluir os usuários que pertencem ao tipo de usuário
        DELETE FROM T_Usuario
        WHERE id_tipo_usuario = p_id;
    
        -- Excluir endereços vinculados aos usuários (caso necessário)
        DELETE FROM T_Endereco
        WHERE id_endereco IN (
            SELECT id_endereco FROM T_Usuario WHERE id_tipo_usuario = p_id
        );
    
        -- Por fim, excluir o tipo de usuário
        DELETE FROM T_Tipo_Usuario
        WHERE id_tipo_usuario = p_id;
    END excluir_categoria;

    PROCEDURE listar_categorias(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_categoria, descricao FROM T_Categoria ORDER BY id_categoria;
    END listar_categorias;

    PROCEDURE buscar_categoria(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_categoria, descricao FROM T_Categoria WHERE id_categoria = p_id;
    END buscar_categoria;

END pkg_categoria;

-- 4.3. Inserir 
BEGIN
    pkg_categoria.inserir_categoria('Móveis');
    pkg_categoria.inserir_categoria('Eletrônicos');
END;

-- select * from T_Categoria

-- 4.4. Atualizar 
BEGIN
    pkg_categoria.atualizar_categoria(1, 'Alimentos Básicos');
END;

-- 4.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_categoria NUMBER;
    v_descricao VARCHAR2(50);
BEGIN
    pkg_categoria.listar_categorias(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id_categoria, v_descricao;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_categoria || ' - Descrição: ' || v_descricao);
    END LOOP;

    CLOSE v_cursor;
END;

-- 4.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_categoria NUMBER;
    v_descricao VARCHAR2(50);
BEGIN
    pkg_categoria.buscar_categoria(2, v_cursor);

    LOOP
        FETCH v_cursor INTO v_id_categoria, v_descricao;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_categoria || ' - Descrição: ' || v_descricao);
    END LOOP;

    CLOSE v_cursor;
END;

-- 4.7. Excluir
BEGIN
    pkg_categoria.excluir_categoria(7);
END;

/***********************************************************************************************
    5. T_Abrigo
***********************************************************************************************/

-- 5.1. Cabeçalho
CREATE OR REPLACE PACKAGE pkg_abrigo AS
    PROCEDURE inserir_abrigo(p_capacidade_total IN NUMBER, p_ocupacao_atual IN NUMBER, p_descricao IN VARCHAR2);
    PROCEDURE atualizar_abrigo(p_id IN NUMBER, p_capacidade_total IN NUMBER, p_ocupacao_atual IN NUMBER, p_descricao IN VARCHAR2);
    PROCEDURE excluir_abrigo(p_id IN NUMBER);
    PROCEDURE listar_abrigos(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE buscar_abrigo(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_abrigo;

-- .5.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_abrigo AS

    PROCEDURE inserir_abrigo(p_capacidade_total IN NUMBER, p_ocupacao_atual IN NUMBER, p_descricao IN VARCHAR2) IS
    BEGIN
        INSERT INTO T_Abrigo (capacidade_total, ocupacao_atual, descricao)
        VALUES (p_capacidade_total, p_ocupacao_atual, p_descricao);
        COMMIT;
    END inserir_abrigo;

    PROCEDURE atualizar_abrigo(p_id IN NUMBER, p_capacidade_total IN NUMBER, p_ocupacao_atual IN NUMBER, p_descricao IN VARCHAR2) IS
    BEGIN
        UPDATE T_Abrigo
        SET capacidade_total = p_capacidade_total,
            ocupacao_atual = p_ocupacao_atual,
            descricao = p_descricao
        WHERE id_abrigo = p_id;
        COMMIT;
    END atualizar_abrigo;

    PROCEDURE excluir_abrigo(p_id IN NUMBER) IS
    BEGIN
        -- Excluir registros de distribuição (que dependem das doações)
        DELETE FROM T_Distribuicao
        WHERE id_doacao IN (
            SELECT id_doacao FROM T_Doacao WHERE id_abrigo = p_id
        );
    
        -- Excluir doações vinculadas ao abrigo
        DELETE FROM T_Doacao
        WHERE id_abrigo = p_id;
    
        -- Excluir eventos vinculados ao abrigo
        DELETE FROM T_Registro_Evento
        WHERE id_abrigo = p_id;
    
        -- Excluir o abrigo
        DELETE FROM T_Abrigo
        WHERE id_abrigo = p_id;
    
        COMMIT;
    END excluir_abrigo;

    PROCEDURE listar_abrigos(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_abrigo, capacidade_total, ocupacao_atual, descricao FROM T_Abrigo ORDER BY id_abrigo;
    END listar_abrigos;

    PROCEDURE buscar_abrigo(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_abrigo, capacidade_total, ocupacao_atual, descricao FROM T_Abrigo WHERE id_abrigo = p_id;
    END buscar_abrigo;

END pkg_abrigo;

-- 5.3. Inserir
BEGIN
    pkg_abrigo.inserir_abrigo(100, 45, 'Abrigo Central');
    pkg_abrigo.inserir_abrigo(50, 20, 'Abrigo Sul');
    pkg_abrigo.inserir_abrigo(75, 60, 'Abrigo Norte');
    pkg_abrigo.inserir_abrigo(120, 110, 'Abrigo Leste');
    pkg_abrigo.inserir_abrigo(90, 50, 'Abrigo Oeste');
    pkg_abrigo.inserir_abrigo(60, 40, 'Abrigo Zona Rural');
    pkg_abrigo.inserir_abrigo(80, 70, 'Abrigo Centro Histórico');
END;

-- 5.4. atualizar
BEGIN
    pkg_abrigo.atualizar_abrigo(1, 110, 55, 'Abrigo Central Atualizado');
END;

-- 5.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_abrigo NUMBER;
    v_capacidade_total NUMBER;
    v_ocupacao_atual NUMBER;
    v_descricao VARCHAR2(200);
BEGIN
    pkg_abrigo.listar_abrigos(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id_abrigo, v_capacidade_total, v_ocupacao_atual, v_descricao;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_abrigo ||
                             ', Capacidade: ' || v_capacidade_total ||
                             ', Ocupação Atual: ' || v_ocupacao_atual ||
                             ', Descrição: ' || v_descricao);
    END LOOP;

    CLOSE v_cursor;
END;

-- 5.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_abrigo NUMBER;
    v_capacidade_total NUMBER;
    v_ocupacao_atual NUMBER;
    v_descricao VARCHAR2(200);
BEGIN
    pkg_abrigo.buscar_abrigo(3, v_cursor);

    LOOP
        FETCH v_cursor INTO v_id_abrigo, v_capacidade_total, v_ocupacao_atual, v_descricao;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_abrigo ||
                             ', Capacidade: ' || v_capacidade_total ||
                             ', Ocupação Atual: ' || v_ocupacao_atual ||
                             ', Descrição: ' || v_descricao);
    END LOOP;

    CLOSE v_cursor;
END;

-- 5.7. Excluir
BEGIN
    pkg_abrigo.excluir_abrigo(7);
END;

/***********************************************************************************************
    6. T_Doacao
***********************************************************************************************/

-- 6.1. Cabeçalho
CREATE OR REPLACE PACKAGE pkg_doacao AS
    PROCEDURE inserir_doacao(p_id_abrigo IN NUMBER, p_descricao IN VARCHAR2, p_id_categoria IN NUMBER, p_quantidade IN NUMBER);
    PROCEDURE atualizar_doacao(p_id IN NUMBER, p_id_abrigo IN NUMBER, p_descricao IN VARCHAR2, p_id_categoria IN NUMBER, p_quantidade IN NUMBER);
    PROCEDURE excluir_doacao(p_id IN NUMBER);
    PROCEDURE listar_doacoes(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE buscar_doacao(p_id_doacao IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_doacao;

-- 6.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_doacao AS

    PROCEDURE inserir_doacao(p_id_abrigo IN NUMBER, p_descricao IN VARCHAR2, p_id_categoria IN NUMBER, p_quantidade IN NUMBER) IS
    BEGIN
        INSERT INTO T_Doacao (id_abrigo, descricao, id_categoria, quantidade)
        VALUES (p_id_abrigo, p_descricao, p_id_categoria, p_quantidade);
        COMMIT;
    END inserir_doacao;

    PROCEDURE atualizar_doacao(p_id IN NUMBER, p_id_abrigo IN NUMBER, p_descricao IN VARCHAR2, p_id_categoria IN NUMBER, p_quantidade IN NUMBER) IS
    BEGIN
        UPDATE T_Doacao
        SET id_abrigo = p_id_abrigo,
            descricao = p_descricao,
            id_categoria = p_id_categoria,
            quantidade = p_quantidade
        WHERE id_doacao = p_id;
        COMMIT;
    END atualizar_doacao;

    PROCEDURE excluir_doacao(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM T_Doacao WHERE id_doacao = p_id;
        COMMIT;
    END excluir_doacao;

    PROCEDURE listar_doacoes(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT id_doacao, id_abrigo, descricao, id_categoria, quantidade FROM T_Doacao;
    END listar_doacoes;

    PROCEDURE buscar_doacao(p_id_doacao IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR 
            SELECT id_doacao, id_abrigo, descricao, id_categoria, quantidade
            FROM T_Doacao
            WHERE id_doacao = p_id_doacao;
    END buscar_doacao;

END pkg_doacao;

-- 6.3. Inserir
BEGIN
    pkg_doacao.inserir_doacao(1, 'Doação de alimentos', 1, 100);
    pkg_doacao.inserir_doacao(2, 'Doação de roupas', 2, 50);
    pkg_doacao.inserir_doacao(3, 'Doação de produtos de higiene', 3, 75);
    pkg_doacao.inserir_doacao(4, 'Doação de brinquedos', 4, 30);
    pkg_doacao.inserir_doacao(5, 'Doação de cobertores', 5, 40);
    pkg_doacao.inserir_doacao(1, 'Doação de material escolar', 6, 60);
    pkg_doacao.inserir_doacao(2, 'Doação de medicamentos', 7, 20);
END;

-- 6.4. Atualizar
BEGIN
    pkg_doacao.atualizar_doacao(1, 1, 'Doação de alimentos perecíveis', 1, 120);
END;

-- 6.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_doacao NUMBER;
    v_id_abrigo NUMBER;
    v_descricao VARCHAR2(200);
    v_id_categoria NUMBER;
    v_quantidade NUMBER;
BEGIN
    pkg_doacao.listar_doacoes(v_cursor);

    LOOP
        FETCH v_cursor INTO v_id_doacao, v_id_abrigo, v_descricao, v_id_categoria, v_quantidade;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_doacao || 
                             ', Abrigo: ' || v_id_abrigo ||
                             ', Descrição: ' || v_descricao ||
                             ', Categoria: ' || v_id_categoria ||
                             ', Quantidade: ' || v_quantidade);
    END LOOP;

    CLOSE v_cursor;
END;

-- 6.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_doacao NUMBER;
    v_id_abrigo NUMBER;
    v_descricao VARCHAR2(200);
    v_id_categoria NUMBER;
    v_quantidade NUMBER;
BEGIN
    pkg_doacao.buscar_doacao(3, v_cursor);

    LOOP
        FETCH v_cursor INTO v_id_doacao, v_id_abrigo, v_descricao, v_id_categoria, v_quantidade;
        EXIT WHEN v_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_doacao || 
                             ', Abrigo: ' || v_id_abrigo ||
                             ', Descrição: ' || v_descricao ||
                             ', Categoria: ' || v_id_categoria ||
                             ', Quantidade: ' || v_quantidade);
    END LOOP;

    CLOSE v_cursor;
END;

-- 6.7. Excluir
BEGIN
    pkg_doacao.excluir_doacao(7);
END;

/***********************************************************************************************
    7. T_Distribuicao
***********************************************************************************************/

-- 7.1. Cabeçalho
CREATE OR REPLACE PACKAGE pkg_distribuicao AS
    PROCEDURE inserir_distribuicao(p_id_doacao IN NUMBER, p_qtd_destinada IN NUMBER, p_data_destinada IN TIMESTAMP, p_id_pessoa_atendida IN NUMBER);
    PROCEDURE atualizar_distribuicao(p_id IN NUMBER, p_id_doacao IN NUMBER, p_qtd_destinada IN NUMBER, p_data_destinada IN TIMESTAMP, p_id_pessoa_atendida IN NUMBER);
    PROCEDURE excluir_distribuicao(p_id IN NUMBER);
    PROCEDURE listar_distribuicoes(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE buscar_distribuicao(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_distribuicao;

-- 7.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_distribuicao AS

    PROCEDURE inserir_distribuicao(p_id_doacao IN NUMBER, p_qtd_destinada IN NUMBER, p_data_destinada IN TIMESTAMP, p_id_pessoa_atendida IN NUMBER) IS
    BEGIN
        INSERT INTO T_Distribuicao(id_doacao, qtd_destinada, data_destinada, id_pessoa_atendida)
        VALUES(p_id_doacao, p_qtd_destinada, p_data_destinada, p_id_pessoa_atendida);
        COMMIT;
    END inserir_distribuicao;

    PROCEDURE atualizar_distribuicao(p_id IN NUMBER, p_id_doacao IN NUMBER, p_qtd_destinada IN NUMBER, p_data_destinada IN TIMESTAMP, p_id_pessoa_atendida IN NUMBER) IS
    BEGIN
        UPDATE T_Distribuicao
        SET id_doacao = p_id_doacao,
            qtd_destinada = p_qtd_destinada,
            data_destinada = p_data_destinada,
            id_pessoa_atendida = p_id_pessoa_atendida
        WHERE id_distribuicao = p_id;
        COMMIT;
    END atualizar_distribuicao;

    PROCEDURE excluir_distribuicao(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM T_Distribuicao WHERE id_distribuicao = p_id;
        COMMIT;
    END excluir_distribuicao;

    PROCEDURE listar_distribuicoes(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM T_Distribuicao;
    END listar_distribuicoes;

    PROCEDURE buscar_distribuicao(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM T_Distribuicao WHERE id_distribuicao = p_id;
    END buscar_distribuicao;

END pkg_distribuicao;

-- 7.3. Inserir
BEGIN
    pkg_distribuicao.inserir_distribuicao(1, 20, TO_TIMESTAMP('2025-05-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
    pkg_distribuicao.inserir_distribuicao(2, 15, TO_TIMESTAMP('2025-05-11 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2);
    pkg_distribuicao.inserir_distribuicao(3, 25, TO_TIMESTAMP('2025-05-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3);
    pkg_distribuicao.inserir_distribuicao(4, 10, TO_TIMESTAMP('2025-05-13 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 4);
    pkg_distribuicao.inserir_distribuicao(5, 30, TO_TIMESTAMP('2025-05-14 16:20:00', 'YYYY-MM-DD HH24:MI:SS'), 5);
    pkg_distribuicao.inserir_distribuicao(1, 5,  TO_TIMESTAMP('2025-05-15 12:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6);
    pkg_distribuicao.inserir_distribuicao(2, 18, TO_TIMESTAMP('2025-05-16 15:55:00', 'YYYY-MM-DD HH24:MI:SS'), 7);
END;

-- 7.4. Atualizar
BEGIN
    pkg_distribuicao.atualizar_distribuicao(1, 1, 22, TO_TIMESTAMP('2025-05-10 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1);
END;

-- 7.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_distribuicao NUMBER;
    v_id_doacao NUMBER;
    v_qtd_destinada NUMBER;
    v_data_destinada TIMESTAMP;
    v_id_pessoa_atendida NUMBER;
BEGIN
    pkg_distribuicao.listar_distribuicoes(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_distribuicao, v_id_doacao, v_qtd_destinada, v_data_destinada, v_id_pessoa_atendida;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_distribuicao || ', Doacao: ' || v_id_doacao || ', Quantidade: ' || v_qtd_destinada || ', Data: ' || TO_CHAR(v_data_destinada, 'YYYY-MM-DD HH24:MI:SS') || ', Pessoa: ' || v_id_pessoa_atendida);
    END LOOP;
    CLOSE v_cursor;
END;

-- 7.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_distribuicao NUMBER;
    v_id_doacao NUMBER;
    v_qtd_destinada NUMBER;
    v_data_destinada TIMESTAMP;
    v_id_pessoa_atendida NUMBER;
BEGIN
    pkg_distribuicao.buscar_distribuicao(3, v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_distribuicao, v_id_doacao, v_qtd_destinada, v_data_destinada, v_id_pessoa_atendida;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_distribuicao || ', Doacao: ' || v_id_doacao || ', Quantidade: ' || v_qtd_destinada || ', Data: ' || TO_CHAR(v_data_destinada, 'YYYY-MM-DD HH24:MI:SS') || ', Pessoa: ' || v_id_pessoa_atendida);
    END LOOP;
    CLOSE v_cursor;
END;

-- 7.7. Excluir
BEGIN
    pkg_distribuicao.excluir_distribuicao(7);
END;

/***********************************************************************************************
    8. T_Feedback
***********************************************************************************************/

-- 8.1. Cabeçalho
CREATE OR REPLACE PACKAGE pkg_feedback AS
    PROCEDURE inserir_feedback(p_id_usuario IN NUMBER, p_nota IN NUMBER, p_comentario IN VARCHAR2, p_data_feedback IN TIMESTAMP);
    PROCEDURE atualizar_feedback(p_id IN NUMBER, p_id_usuario IN NUMBER, p_nota IN NUMBER, p_comentario IN VARCHAR2, p_data_feedback IN TIMESTAMP);
    PROCEDURE excluir_feedback(p_id IN NUMBER);
    PROCEDURE listar_feedbacks(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE buscar_feedback(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_feedback;

-- 8.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_feedback AS

    PROCEDURE inserir_feedback(p_id_usuario IN NUMBER, p_nota IN NUMBER, p_comentario IN VARCHAR2, p_data_feedback IN TIMESTAMP) IS
    BEGIN
        INSERT INTO T_Feedbacks(id_usuario, nota, comentario, data_feedback)
        VALUES(p_id_usuario, p_nota, p_comentario, p_data_feedback);
        COMMIT;
    END inserir_feedback;

    PROCEDURE atualizar_feedback(p_id IN NUMBER, p_id_usuario IN NUMBER, p_nota IN NUMBER, p_comentario IN VARCHAR2, p_data_feedback IN TIMESTAMP) IS
    BEGIN
        UPDATE T_Feedbacks
        SET id_usuario = p_id_usuario,
            nota = p_nota,
            comentario = p_comentario,
            data_feedback = p_data_feedback
        WHERE id_feedback = p_id;
        COMMIT;
    END atualizar_feedback;

    PROCEDURE excluir_feedback(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM T_Feedbacks WHERE id_feedback = p_id;
        COMMIT;
    END excluir_feedback;

    PROCEDURE listar_feedbacks(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR 
        SELECT id_feedback, id_usuario, nota, comentario, 
               CAST(data_feedback AS TIMESTAMP) 
        FROM T_Feedbacks;
    END listar_feedbacks;

    PROCEDURE buscar_feedback(p_id IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR 
        SELECT id_feedback, id_usuario, nota, comentario, 
               CAST(data_feedback AS TIMESTAMP) 
        FROM T_Feedbacks 
        WHERE id_feedback = p_id;
    END buscar_feedback;

END pkg_feedback;

-- select * from T_Feedbacks;

-- 8.3. Inserir
BEGIN
    pkg_feedback.inserir_feedback(6, 1, 'Parabéns pela iniciativa!', TO_TIMESTAMP('2025-05-07 16:45:00', 'YYYY-MM-DD HH24:MI:SS'));
END;

-- 8.4. Atualizar
BEGIN
    pkg_feedback.atualizar_feedback(6, 5, 5, 'Atendimento excelente e rápido.', TO_TIMESTAMP('2025-05-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));
END;

-- 8.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_feedback NUMBER;
    v_id_usuario NUMBER;
    v_nota NUMBER;
    v_comentario VARCHAR2(4000);
    v_data_hora TIMESTAMP;
BEGIN
    pkg_feedback.listar_feedbacks(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_feedback, v_id_usuario, v_nota, v_comentario, v_data_hora;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_feedback || ', Usuário: ' || v_id_usuario || ', Nota: ' || v_nota || ', Comentário: ' || v_comentario || ', Data/Hora: ' || TO_CHAR(v_data_hora, 'YYYY-MM-DD HH24:MI:SS'));
    END LOOP;
    CLOSE v_cursor;
END;

-- 8.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_feedback NUMBER;
    v_id_usuario NUMBER;
    v_nota NUMBER;
    v_comentario VARCHAR2(4000);
    v_data_hora TIMESTAMP; -- Alterado para TIMESTAMP
BEGIN
    pkg_feedback.buscar_feedback(3, v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_feedback, v_id_usuario, v_nota, v_comentario, v_data_hora;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_feedback || ', Usuário: ' || v_id_usuario || ', Nota: ' || v_nota || ', Comentário: ' || v_comentario || ', Data/Hora: ' || TO_CHAR(v_data_hora, 'YYYY-MM-DD HH24:MI:SS'));
    END LOOP;
    CLOSE v_cursor;
END;

-- 8.7. Excluir
BEGIN
    pkg_feedback.excluir_feedback(7);
END;

/***********************************************************************************************
    9. T_Registro_Evento
***********************************************************************************************/

-- 9.1. Cabeçalho
CREATE OR REPLACE PACKAGE pkg_registro_evento AS
    PROCEDURE inserir_evento(
        p_descricao IN VARCHAR2,
        p_data_hora IN TIMESTAMP,
        p_id_usuario IN NUMBER,
        p_localizacao IN VARCHAR2,
        p_id_abrigo IN NUMBER
    );

    PROCEDURE atualizar_evento(
        p_id_evento IN NUMBER,
        p_descricao IN VARCHAR2,
        p_data_hora IN TIMESTAMP,
        p_id_usuario IN NUMBER,
        p_localizacao IN VARCHAR2,
        p_id_abrigo IN NUMBER
    );

    PROCEDURE excluir_evento(p_id_evento IN NUMBER);

    PROCEDURE listar_eventos(p_cursor OUT SYS_REFCURSOR);

    PROCEDURE buscar_evento(p_id_evento IN NUMBER, p_cursor OUT SYS_REFCURSOR);
END pkg_registro_evento;

-- 9.2. Corpo
CREATE OR REPLACE PACKAGE BODY pkg_registro_evento AS

    PROCEDURE inserir_evento(
        p_descricao IN VARCHAR2,
        p_data_hora IN TIMESTAMP,
        p_id_usuario IN NUMBER,
        p_localizacao IN VARCHAR2,
        p_id_abrigo IN NUMBER
    ) IS
    BEGIN
        INSERT INTO T_Registro_Evento (descricao, data_hora, id_usuario, localizacao, id_abrigo)
        VALUES (p_descricao, p_data_hora, p_id_usuario, p_localizacao, p_id_abrigo);
        COMMIT;
    END inserir_evento;

    PROCEDURE atualizar_evento(
        p_id_evento IN NUMBER,
        p_descricao IN VARCHAR2,
        p_data_hora IN TIMESTAMP,
        p_id_usuario IN NUMBER,
        p_localizacao IN VARCHAR2,
        p_id_abrigo IN NUMBER
    ) IS
    BEGIN
        UPDATE T_Registro_Evento
        SET descricao = p_descricao,
            data_hora = p_data_hora,
            id_usuario = p_id_usuario,
            localizacao = p_localizacao,
            id_abrigo = p_id_abrigo
        WHERE id_evento = p_id_evento;
        COMMIT;
    END atualizar_evento;

    PROCEDURE excluir_evento(p_id_evento IN NUMBER) IS
    BEGIN
        DELETE FROM T_Registro_Evento WHERE id_evento = p_id_evento;
        COMMIT;
    END excluir_evento;

    PROCEDURE listar_eventos(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM T_Registro_Evento;
    END listar_eventos;

    PROCEDURE buscar_evento(p_id_evento IN NUMBER, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM T_Registro_Evento WHERE id_evento = p_id_evento;
    END buscar_evento;

END pkg_registro_evento;

-- 9.3. Inserir
BEGIN
    pkg_registro_evento.inserir_evento('Reunião de planejamento semanal.', TO_TIMESTAMP('2025-05-01 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 'Sala de reuniões', 1);
    pkg_registro_evento.inserir_evento('Entrega de doações recebidas.', TO_TIMESTAMP('2025-05-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 'Depósito central', 2);
    pkg_registro_evento.inserir_evento('Treinamento de voluntários.', TO_TIMESTAMP('2025-05-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 'Auditório principal', 3);
    pkg_registro_evento.inserir_evento('Visita de inspeção da prefeitura.', TO_TIMESTAMP('2025-05-04 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'Sede administrativa', 4);
    pkg_registro_evento.inserir_evento('Campanha de arrecadação.', TO_TIMESTAMP('2025-05-05 16:20:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 'Praça central', 5);
    pkg_registro_evento.inserir_evento('Sessão de feedback com atendidos.', TO_TIMESTAMP('2025-05-06 13:10:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 'Sala de convivência', 6);
    pkg_registro_evento.inserir_evento('Evento de integração comunitária.', TO_TIMESTAMP('2025-05-07 15:55:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 'Parque municipal', 7);
END;

-- 9.4. Atualizar
BEGIN
    pkg_registro_evento.atualizar_evento(1, 'Reunião semanal atualizada.', TO_TIMESTAMP('2025-05-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 'Sala A', 1);
END;

-- 9.5. Listar todos
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_evento NUMBER;
    v_descricao VARCHAR2(400);
    v_data_hora TIMESTAMP;
    v_id_usuario NUMBER;
    v_localizacao VARCHAR2(100);
    v_id_abrigo NUMBER;
BEGIN
    pkg_registro_evento.listar_eventos(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_evento, v_descricao, v_data_hora, v_id_usuario, v_localizacao, v_id_abrigo;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_evento || ', Descrição: ' || v_descricao || ', Data/Hora: ' || TO_CHAR(v_data_hora, 'YYYY-MM-DD HH24:MI:SS') ||
                             ', Usuário: ' || v_id_usuario || ', Local: ' || v_localizacao || ', Abrigo: ' || v_id_abrigo);
    END LOOP;
    CLOSE v_cursor;
END;

-- 9.6. Listar por ID
DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_evento NUMBER;
    v_descricao VARCHAR2(400);
    v_data_hora TIMESTAMP;
    v_id_usuario NUMBER;
    v_localizacao VARCHAR2(100);
    v_id_abrigo NUMBER;
BEGIN
    pkg_registro_evento.buscar_evento(3, v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_evento, v_descricao, v_data_hora, v_id_usuario, v_localizacao, v_id_abrigo;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_evento || ', Descrição: ' || v_descricao || ', Data/Hora: ' || TO_CHAR(v_data_hora, 'YYYY-MM-DD HH24:MI:SS') ||
                             ', Usuário: ' || v_id_usuario || ', Local: ' || v_localizacao || ', Abrigo: ' || v_id_abrigo);
    END LOOP;
    CLOSE v_cursor;
END;

-- 9.7. Excluir
BEGIN
    pkg_registro_evento.excluir_evento(7);
END;
