
-- USUARIO
CREATE TABLE Usuario (
    id_usuario          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome                VARCHAR2(100),
    username            VARCHAR2(100) UNIQUE NOT NULL,
    senha               VARCHAR2(15) NOT NULL,
    id_tipo_usuario     NUMBER NOT NULL -- 'admin', 'voluntario', 'profissional', 'atendido'
    telefone            VARCHAR2(20),
    id_endereco         NUMBER NOT NULL,
    data_nascimento     DATETIME,
    documento           VARCHAR2(20), -- CPF ou CNPJ
    id_status_usuario   NUMBER, -- status 0 ou 1
    CONSTRAINT fk_usuario_tipo FOREIGN KEY (id_tipo_usuario) REFERENCES Tipo_Usuario(id_tipo_usuario),
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (id_endereco) REFERENCES Endereco(id_endereco),
    CONSTRAINT fk_usuario_status FOREIGN KEY (id_status_usuario) REFERENCES Status_Usuario(id_status_usuario)
);

-- TIPO USUARIO
CREATE TABLE Tipo_Usuario (
    id_tipo_usuario     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE,   -- Ex: 'Admin', 'Voluntario', 'Profissional', 'Atendido'
);

-- STATUS USUARIO
CREATE TABLE Status_Usuario (
    id_status_usuario   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(10) NOT NULL UNIQUE,   -- Ex: 'Ativo', 'Inativo'
);

-- ENDERECO
CREATE TABLE Endereco (
    id_endereco     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rua             VARCHAR2(100),
    numero          NUMBER,
    bairro          VARCHAR2(100),
    cidade          VARCHAR2(255),
    estado          VARCHAR2(100),
    cep             NUMBER(8),
    complemento     VARCHAR2(255)
);

-- CATEGORIA
CREATE TABLE Categoria (
    id_categoria    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao       VARCHAR2(50) NOT NULL UNIQUE  -- exemplo: 'Roupa', 'Alimento', 'Medicamento'
);

-- ABRIGO
CREATE TABLE Abrigo (
    id_abrigo           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    capacidade_total    NUMBER,
    ocupacao_atual      NUMBER,
    descricao           VARCHAR2(200),       
);

-- DOACAO
CREATE TABLE Doacao (
    id_doacao       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_abrigo       NUMBER,
    descricao       VARCHAR2(200),
    id_categoria    NUMBER,
    quantidade      NUMBER,
    CONSTRAINT fk_doacao_abrigo FOREIGN KEY (id_abrigo) REFERENCES Abrigo(id_abrigo),
    CONSTRAINT fk_doacao_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- PESSOA ATENDIDA
CREATE TABLE Pessoa_Atendida (
    id_pessoa_atendida      NUMBER PRIMARY KEY,
    id_categoria            NUMBER,
    servico_desejado        VARCHAR2(200),
    observacoes             VARCHAR2(200),
    CONSTRAINT fk_pessoaatendida_usuario FOREIGN KEY (id) REFERENCES Usuario(id_usuario)
);

-- DISTRIBUICAO
CREATE TABLE Distribuicao (
    id_distribuicao         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_doacao               NUMBER,
    qtd_destinada           NUMBER,
    data_destinada          DATETIME,
    id_pessoa_atendida      NUMBER,
    CONSTRAINT fk_distribuicao_doacao FOREIGN KEY (id_doacao) REFERENCES Doacao(id_doacao),
    CONSTRAINT fk_distribuicao_pessoa FOREIGN KEY (id_pessoa_atendida) REFERENCES Pessoa_Atendida(id_pessoa_atendida)
);

-- VOLUNTARIO
CREATE TABLE Voluntario (
    id_voluntario          NUMBER PRIMARY KEY,
    id_categoria           VARCHAR2(50), -- Saúde, Educação, Assistência Social, etc.
    id_disponibilidade     VARCHAR2(50), -- Turno?
    CONSTRAINT fk_voluntario_usuario FOREIGN KEY (id) REFERENCES Usuario(id_usuario)
    CONSTRAINT fk_voluntario_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria_Voluntario(id_categoria),
    CONSTRAINT fk_voluntario_disponibilidade FOREIGN KEY (id_disponibilidade) REFERENCES Disponibilidade(id_disponibilidade)
);

-- CATEGORIA VOLUNTARIO
CREATE TABLE Categoria_Voluntario (
    id_categoria    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao       VARCHAR2(100) NOT NULL UNIQUE,   -- Ex: 'Saúde', 'Educação', 'Assistência Social'
);

-- DISPONIBILIDADE DO VOLUNTARIO
CREATE TABLE Disponibilidade (
    id_disponibilidade  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE  -- exemplo: 'Manhã', 'Tarde', 'Noite', 'Integral'
);


-- EMPRESA PARCEIRA
CREATE TABLE EmpresaParceira (
    id_empresa_parceira      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_categoria            VARCHAR2(100),
    servico_oferecido       VARCHAR2(200), -- Lista com saúde, educação, assistência social, roupa, alimento, etc.
    CONSTRAINT fk_empresa_usuario FOREIGN KEY (id_empresa_parceira) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_empresa_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- ESPECIALIDADE
CREATE TABLE Especialidade (
    id_especialidade    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(100)
);

-- FEEDBACK
CREATE TABLE Feedback (
    id_feedback     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    nota            NUMBER,
    comentario      VARCHAR2(200),
    data_feedback   DATETIME
    id_usuario      NUMBER, -- quem esta avaliando
    id_profissional NUMBER, -- quem esta recebendo a avaliação
    id_abrigo       NUMBER, -- abrigo que esta recebendo a avaliação
    CONSTRAINT fk_feedback_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_feedback_profissional FOREIGN KEY (id_profissional) REFERENCES ProfissionalSaude(id_profissional),
    CONSTRAINT fk_feedback_abrigo FOREIGN KEY (id_abrigo) REFERENCES Abrigo(id_abrigo)
);

-- PROFISSIONAL SAUDE
CREATE TABLE ProfissionalSaude (
    id_profissional     NUMBER PRIMARY KEY,
    id_especialidade    NUMBER,
    forma_atendimento   VARCHAR2(50),
    id_feedback         NUMBER,
    CONSTRAINT fk_profissional_usuario FOREIGN KEY (id_profissional) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_profissional_especialidade FOREIGN KEY (id_especialidade) REFERENCES Especialidade(id_especialidade),
    CONSTRAINT fk_profissional_feedback FOREIGN KEY (id_feedback) REFERENCES Feedback(id_feedback)
);

-- MURAL EMERGENCIA
CREATE TABLE Mural_Emergencia (
    id_mural                    NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    mensagem                    VARCHAR2(255),
    id_tipo_mural_emergencia    NUMBER NOT NULL, -- 0 - alerta, 1 - aviso, 2 - informação
    status_apoio                VARCHAR2(1), -- 0 - não apoiado, 1 - apoiado
    data_hora                   DATETIME,
    CONSTRAINT fk_mural_tipo FOREIGN KEY (id_tipo_mural_emergencia) REFERENCES Tipo_Mural_Emergencia(id_tipo_mural_emergencia)
);

-- TIPO MURAL EMERGENCIA
CREATE TABLE Tipo_Mural_Emergencia (
    id_tipo_mural_emergencia    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao                   VARCHAR2(50) NOT NULL UNIQUE,  -- exemplo: 'Alerta', 'Aviso', 'Informação'
);

-- REGISTRO EVENTO
CREATE TABLE RegistroEvento (
    id_registro_evento  NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    id_tipo_evento      NUMBER(1),  -- 0 - doação, 1 - distribuição
    descricao           VARCHAR2(255),
    data_hora           DATETIME,
    id_usuario          NUMBER,
    localizacao         VARCHAR2(200),
    CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_registro_tipo FOREIGN KEY (id_tipo_evento) REFERENCES TipoEvento(id_tipo_evento)
);

-- TIPO EVENTO
CREATE TABLE TipoEvento (
    id_tipo_evento  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao       VARCHAR2(255)
);