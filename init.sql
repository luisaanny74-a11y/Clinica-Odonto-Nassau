-- 29.1 Usuários
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    matricula VARCHAR(30) UNIQUE,
    perfil ENUM('ALUNO', 'PROFESSOR', 'ADMIN', 'RECEPCAO') NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 29.2 Pacientes e prontuários
CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(11) UNIQUE,
    rg VARCHAR(30),
    data_nascimento DATE,
    sexo VARCHAR(30),
    estado_civil VARCHAR(30),
    etnia VARCHAR(50),
    naturalidade VARCHAR(100),
    endereco VARCHAR(255),
    cep VARCHAR(8),
    uf CHAR(2),
    telefone VARCHAR(20),
    celular VARCHAR(20),
    profissao VARCHAR(100),
    escolaridade VARCHAR(100),
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE prontuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL UNIQUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

-- 29.3 Especialidades e atendimentos
CREATE TABLE especialidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE atendimentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prontuario_id INT NOT NULL,
    especialidade_id INT NOT NULL,
    aluno_id INT NOT NULL,
    iniciado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finalizado_em DATETIME NULL,
    FOREIGN KEY (prontuario_id) REFERENCES prontuarios(id),
    FOREIGN KEY (especialidade_id) REFERENCES especialidades(id),
    FOREIGN KEY (aluno_id) REFERENCES usuarios(id)
);

-- 29.4 Fichas e Semiologia
CREATE TABLE fichas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atendimento_id INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    status ENUM(
        'RASCUNHO',
        'AGUARDANDO_APROVACAO',
        'CORRECAO_SOLICITADA',
        'APROVADA'
    ) NOT NULL DEFAULT 'RASCUNHO',
    versao INT NOT NULL DEFAULT 1,
    criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enviada_em DATETIME NULL,
    aprovada_em DATETIME NULL,
    FOREIGN KEY (atendimento_id) REFERENCES atendimentos(id)
);

CREATE TABLE fichas_semiologia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ficha_id INT NOT NULL UNIQUE,
    queixa_principal TEXT,
    historia_doenca_atual TEXT,
    antecedentes_familiares TEXT,
    observacoes_gerais TEXT,
    diagnostico TEXT,
    plano_tratamento TEXT,
    necessita_encaminhamento BOOLEAN DEFAULT FALSE,
    especialidade_encaminhamento_id INT NULL,
    motivo_encaminhamento TEXT,
    FOREIGN KEY (ficha_id) REFERENCES fichas(id),
    FOREIGN KEY (especialidade_encaminhamento_id) REFERENCES especialidades(id)
);

-- 29.5 Condições, alergias e medicamentos
CREATE TABLE condicoes_medicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE paciente_condicoes_medicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    condicao_id INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    observacao TEXT,
    registrado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (condicao_id) REFERENCES condicoes_medicas(id)
);

CREATE TABLE alergias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo ENUM('MEDICAMENTO', 'ANESTESICO', 'ALIMENTO', 'MATERIAL', 'OUTRA') NOT NULL,
    agente VARCHAR(150) NOT NULL,
    reacao TEXT,
    ativa BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

CREATE TABLE medicamentos_paciente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    dosagem VARCHAR(100),
    frequencia VARCHAR(100),
    observacao TEXT,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

-- 29.6 Sinais vitais
CREATE TABLE sinais_vitais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atendimento_id INT NOT NULL,
    pressao_sistolica INT,
    pressao_diastolica INT,
    pulso INT,
    frequencia_respiratoria INT,
    temperatura DECIMAL(4,1),
    peso DECIMAL(5,2),
    altura DECIMAL(4,2),
    glicemia DECIMAL(6,2),
    registrado_por INT NOT NULL,
    registrado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (atendimento_id) REFERENCES atendimentos(id),
    FOREIGN KEY (registrado_por) REFERENCES usuarios(id)
);

-- 29.7 Odontograma
CREATE TABLE odontogramas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prontuario_id INT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prontuario_id) REFERENCES prontuarios(id)
);

CREATE TABLE condicoes_odontologicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nome VARCHAR(150) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE odontograma_registros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    odontograma_id INT NOT NULL,
    atendimento_id INT NOT NULL,
    numero_dente INT NOT NULL,
    face ENUM(
        'VESTIBULAR', 'LINGUAL', 'PALATINA', 'MESIAL',
        'DISTAL', 'OCLUSAL', 'INCISAL', 'DENTE_INTEIRO'
    ) NOT NULL,
    condicao_id INT NOT NULL,
    observacao TEXT,
    registrado_por INT NOT NULL,
    registrado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (odontograma_id) REFERENCES odontogramas(id),
    FOREIGN KEY (atendimento_id) REFERENCES atendimentos(id),
    FOREIGN KEY (condicao_id) REFERENCES condicoes_odontologicas(id),
    FOREIGN KEY (registrado_por) REFERENCES usuarios(id)
);

-- 29.8 Aprovações e histórico
CREATE TABLE aprovacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ficha_id INT NOT NULL,
    professor_id INT NOT NULL,
    decisao ENUM('APROVADA', 'CORRECAO_SOLICITADA') NOT NULL,
    observacao TEXT,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ficha_id) REFERENCES fichas(id),
    FOREIGN KEY (professor_id) REFERENCES usuarios(id)
);

CREATE TABLE historico_status_ficha (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ficha_id INT NOT NULL,
    status_anterior VARCHAR(50),
    status_novo VARCHAR(50) NOT NULL,
    usuario_id INT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ficha_id) REFERENCES fichas(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Inserção dos usuários oficiais do MVP
INSERT INTO usuarios (nome, email, senha_hash, matricula, perfil, ativo) VALUES
('Aluno Teste', 'aluno@uninassau.edu.br', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'OD2026A', 'ALUNO', TRUE),
('Professor Teste', 'professor@uninassau.edu.br', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'PR02026', 'PROFESSOR', TRUE),
('Recepção Teste', 'recepcao@uninassau.edu.br', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'RC2026', 'RECEPCAO', TRUE),
('Coordenadora Admin', 'coordenadora@uninassau.edu.br', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'AD02026', 'ADMIN', TRUE);