
-- USUARIO
CREATE TABLE Usuario (
    id_usuario          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome                VARCHAR2(100),
    username            VARCHAR2(100) UNIQUE NOT NULL,
    senha               VARCHAR2(15) NOT NULL,
    id_tipo_usuario     NUMBER NOT NULL, -- 'admin', 'voluntario', 'profissional', 'atendido'
    telefone            VARCHAR2(20),
    id_endereco         NUMBER NOT NULL,
    data_nascimento     DATE,
    documento           VARCHAR2(20), -- CPF ou CNPJ
    id_status_usuario   NUMBER NOT NULL, -- status 0 ou 1
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
    cep             VARCHAR2(8),
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
    id_abrigo       NUMBER NOT NULL,
    descricao       VARCHAR2(200),
    id_categoria    NUMBER NOT NULL,
    quantidade      NUMBER,
    CONSTRAINT fk_doacao_abrigo FOREIGN KEY (id_abrigo) REFERENCES Abrigo(id_abrigo),
    CONSTRAINT fk_doacao_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- PESSOA ATENDIDA
CREATE TABLE Pessoa_Atendida (
    id_pessoa_atendida      NUMBER PRIMARY KEY,
    servico_desejado        VARCHAR2(200),
    observacoes             VARCHAR2(200),
    CONSTRAINT fk_pessoa_atendida_usuario FOREIGN KEY (id_pessoa_atendida) REFERENCES Usuario(id_usuario)
);


-- DISTRIBUICAO
CREATE TABLE Distribuicao (
    id_distribuicao         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_doacao               NUMBER NOT NULL,
    qtd_destinada           NUMBER,
    data_destinada          TIMESTAMP,
    id_pessoa_atendida      NUMBER NOT NULL,
    CONSTRAINT fk_distribuicao_doacao FOREIGN KEY (id_doacao) REFERENCES Doacao(id_doacao),
    CONSTRAINT fk_distribuicao_pessoa FOREIGN KEY (id_pessoa_atendida) REFERENCES Pessoa_Atendida(id_pessoa_atendida)
);

-- VOLUNTARIO
CREATE TABLE Voluntario (
    id_voluntario               NUMBER PRIMARY KEY,
    id_categoria_voluntario     NUMBER NOT NULL, -- Saúde, Educação, Assistência Social, etc.
    id_disponibilidade          NUMBER NOT NULL, -- Turno?
    CONSTRAINT fk_voluntario_usuario FOREIGN KEY (id_voluntario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_voluntario_categoria FOREIGN KEY (id_categoria_voluntario) REFERENCES Categoria_Voluntario(id_categoria_voluntario),
    CONSTRAINT fk_voluntario_disponibilidade FOREIGN KEY (id_disponibilidade) REFERENCES Disponibilidade(id_disponibilidade)
);

-- CATEGORIA VOLUNTARIO
CREATE TABLE Categoria_Voluntario (
    id_categoria_voluntario     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao                   VARCHAR2(100) NOT NULL UNIQUE,   -- Ex: 'Saúde', 'Educação', 'Assistência Social'
);

-- DISPONIBILIDADE DO VOLUNTARIO
CREATE TABLE Disponibilidade (
    id_disponibilidade  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao           VARCHAR2(50) NOT NULL UNIQUE  -- exemplo: 'Manhã', 'Tarde', 'Noite', 'Integral'
);


-- EMPRESA PARCEIRA
CREATE TABLE EmpresaParceira (
    id_empresa_parceira     NUMBER PRIMARY KEY,
    id_categoria            NUMBER NOT NULL,
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
    id_feedback     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nota            NUMBER,
    comentario      VARCHAR2(200),
    data_feedback   TIMESTAMP,
    id_avaliado     NUMBER NOT NULL, -- Quem será avaliado
    id_usuario      NUMBER NOT NULL, -- Quem esta avaliando
    CONSTRAINT fk_feedback_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_feedback_avaliado FOREIGN KEY (id_avaliado) REFERENCES Usuario(id_usuario)
);

-- PROFISSIONAL SAUDE
CREATE TABLE ProfissionalSaude (
    id_profissional         NUMBER PRIMARY KEY,
    id_especialidade        NUMBER NOT NULL,
    id_forma_atendimento    NUMBER NOT NULL, -- Presencial ou remoto?
    CONSTRAINT fk_profissional_usuario FOREIGN KEY (id_profissional) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_profissional_especialidade FOREIGN KEY (id_especialidade) REFERENCES Especialidade(id_especialidade),
    CONSTRAINT fk_forma_atendimento FOREIGN KEY (id_forma_atendimento) REFERENCES Forma_Atendimento(id_forma_atendimento)
);

-- MURAL EMERGENCIA
CREATE TABLE Mural_Emergencia (
    id_mural                    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario                  NUMBER NOT NULL,
    mensagem                    VARCHAR2(255),
    id_tipo_mural_emergencia    NUMBER NOT NULL, -- 0 - alerta, 1 - aviso, 2 - informação
    id_status_apoio             NUMBER NOT NULL, -- 0 - não apoiado, 1 - apoiado
    data_hora                   TIMESTAMP,
    CONSTRAINT fk_usuario_mural FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_mural_tipo    FOREIGN KEY (id_tipo_mural_emergencia) REFERENCES Tipo_Mural_Emergencia(id_tipo_mural_emergencia),
    CONSTRAINT fk_mural_status  FOREIGN KEY (id_status_apoio) REFERENCES Status_Apoio(id_status_apoio)
);

-- TIPO MURAL EMERGENCIA
CREATE TABLE Tipo_Mural_Emergencia (
    id_tipo_mural_emergencia    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao                   VARCHAR2(50) NOT NULL UNIQUE,  -- exemplo: 'Alerta', 'Aviso', 'Informação'
);

-- FORMA DE ATENDIMENTO
CREATE TABLE Forma_Atendimento (
    id_forma_atendimento    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao               VARCHAR2(50) NOT NULL UNIQUE,  -- Presencial ou Remoto
);

-- STATUS DO MURAL
CREATE TABLE Status_Apoio (
    id_status_apoio      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao            VARCHAR2(50) NOT NULL UNIQUE,  -- Apoiado ou Não Apoiado
);

-- REGISTRO EVENTO
CREATE TABLE RegistroEvento (
    id_registro_evento  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tipo_evento      NUMBER NOT NULL,  
    descricao           VARCHAR2(255),
    data_hora           TIMESTAMP,
    id_usuario          NUMBER NOT NULL,
    localizacao         VARCHAR2(200),
    CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT fk_registro_tipo FOREIGN KEY (id_tipo_evento) REFERENCES TipoEvento(id_tipo_evento)
);

-- TIPO EVENTO
CREATE TABLE TipoEvento (
    id_tipo_evento  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao       VARCHAR2(255) -- 0 - doação, 1 - distribuição
);