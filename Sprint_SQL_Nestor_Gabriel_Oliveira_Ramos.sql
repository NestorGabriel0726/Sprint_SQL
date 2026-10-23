-- CRIAÇÃO DO BANCO DE DADOS --
CREATE DATABASE sistema_bancario;
USE sistema_bancario;

-- CRIAÇÃO DAS TABELAS DO BANCO --
CREATE TABLE clientes (
    titular_id VARCHAR(50) PRIMARY KEY, 
    nome VARCHAR(100),                  
    cpf VARCHAR(15) UNIQUE,             
    endereco VARCHAR(100),
    data_de_nascimento DATE
);

CREATE TABLE conta (
    conta_id VARCHAR(30) PRIMARY KEY,
    saldo DECIMAL(10, 2) NOT NULL DEFAULT 0.00, 
    tipo_de_conta VARCHAR(10),
    titular VARCHAR(50),                        
    FOREIGN KEY (titular) REFERENCES clientes(titular_id)
);

CREATE TABLE transacoes (
    id_transacao INT AUTO_INCREMENT PRIMARY KEY,
    conta_id VARCHAR(30),
    tipo_movimentacao VARCHAR(15) NOT NULL,
    valor_movimentacao DECIMAL(15,2) NOT NULL,
    data_movimentacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Preenche a data automaticamente
    FOREIGN KEY (conta_id) REFERENCES conta(conta_id)
);

CREATE TABLE cartoes (
    cartao_id INT AUTO_INCREMENT PRIMARY KEY,
    conta_id VARCHAR(30),
    titular_cartao VARCHAR(50),                
    numero_cartao VARCHAR(20),                  
    via_cartao VARCHAR(6),
    status_cartao VARCHAR(10),
    limite_cartao DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (conta_id) REFERENCES conta(conta_id),
    FOREIGN KEY (titular_cartao) REFERENCES clientes(titular_id)
);

CREATE TABLE emprestimos (
    contrato_emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    conta_solicitante VARCHAR(30),
    titular_conta VARCHAR(50),                  
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conta_solicitante) REFERENCES conta(conta_id),
    FOREIGN KEY (titular_conta) REFERENCES clientes(titular_id)
);

-- INSERÇÃO DOS DADOS NA TABELA --

INSERT INTO clientes (titular_id, nome, cpf, endereco, data_de_nascimento) VALUES 
('cli_ana99', 'Ana Silva Sauro', '123.456.789-00', 'Rua das Flores, 123 - São Paulo/SP', '1995-05-15'),
('cli_carlos88', 'Carlos Eduardo Sousa', '987.654.321-11', 'Av. Central, 456 - Salvador/BA', '1988-11-23');

INSERT INTO conta (conta_id, saldo, tipo_de_conta, titular) VALUES 
('10001-9', 2500.00, 'CORRENTE', 'cli_ana99'),
('20002-8', 50.00, 'POUPANCA', 'cli_carlos88');

INSERT INTO transacoes (conta_id, tipo_movimentacao, valor_movimentacao) VALUES 
('10001-9', 'CREDITO', 3000.00), -- Depósito / Salário
('10001-9', 'DEBITO', 500.00),   -- Pagamento de conta
('20002-8', 'CREDITO', 50.00);    -- Depósito

INSERT INTO cartoes (conta_id, titular_cartao, numero_cartao, via_cartao, status_cartao, limite_cartao) VALUES 
('10001-9', 'cli_ana99', '4532 1122 3344 5566', '01', 'ATIVO', 5000.00),
('20002-8', 'cli_carlos88', '5124 9988 7766 5544', '01', 'BLOQUEADO', 0.00);

INSERT INTO emprestimos (conta_solicitante, titular_conta) VALUES 
('10001-9', 'cli_ana99');

-- INSERI MAIS DADOS AQUI --

INSERT INTO clientes (titular_id, nome, cpf, endereco, data_de_nascimento) VALUES 
('cli_mariana77', 'Mariana Oliveira Ramos', '444.555.666-77', 'Rua das Pedras, 89 - Belo Horizonte/MG', '1982-03-10'),
('cli_joao55', 'João Pedro Santos', '111.222.333-44', 'Av. Atlântica, 1020 - Rio de Janeiro/RJ', '1990-07-25'),
('cli_fernanda33', 'Fernanda Lima Costa', '999.888.777-66', 'Rua XV de Novembro, 330 - Curitiba/PR', '1998-12-05'),
('cli_roberto21', 'Roberto Almeida', '555.444.333-22', 'Praça da Sé, 12 - São Paulo/SP', '1975-08-19');

INSERT INTO conta (conta_id, saldo, tipo_de_conta, titular) VALUES 
('30003-7', 15400.50, 'CORRENTE', 'cli_mariana77'),
('40004-6', 120.00, 'POUPANCA', 'cli_joao55'),
('50005-5', 3450.00, 'CORRENTE', 'cli_fernanda33'),
('60006-4', 89000.00, 'CORRENTE', 'cli_roberto21');

INSERT INTO transacoes (conta_id, tipo_movimentacao, valor_movimentacao) VALUES 
('30003-7', 'CREDITO', 16000.00),
('30003-7', 'DEBITO', 599.50),
('40004-6', 'CREDITO', 200.00),
('40004-6', 'DEBITO', 80.00),
('50005-5', 'CREDITO', 4000.00),
('50005-5', 'DEBITO', 550.00),
('60006-4', 'CREDITO', 95000.00),
('60006-4', 'DEBITO', 6000.00);


INSERT INTO cartoes (conta_id, titular_cartao, numero_cartao, via_cartao, status_cartao, limite_cartao) VALUES 
('30003-7', 'cli_mariana77', '4532 8899 1122 3344', '01', 'ATIVO', 15000.00),
('40004-6', 'cli_joao55', '5124 3322 1100 9988', '02', 'ATIVO', 1000.00),
('50005-5', 'cli_fernanda33', '4532 5555 6666 7777', '01', 'ATIVO', 3500.00),
('60006-4', 'cli_roberto21', '5124 1111 2222 3333', '01', 'BLOQUEADO', 50000.00);


INSERT INTO emprestimos (conta_solicitante, titular_conta) VALUES 
('40004-6', 'cli_joao55'),
('60006-4', 'cli_roberto21'),
('50005-5', 'cli_fernanda33');

-- CONSULTAS PARA VALIDAÇÃO --

SELECT * FROM clientes;
SELECT * FROM transacoes
WHERE tipo_movimentacao = 'CREDITO';

SELECT * FROM clientes
WHERE YEAR (data_de_nascimento) >= 1990;

-- CRIAÇÃO DE DUAS INNER JOIN --

SELECT clientes.nome, conta.tipo_de_conta, conta.saldo
FROM clientes
INNER JOIN conta
ON clientes.titular_id = conta.titular;

SELECT clientes.nome, conta.conta_id, conta.saldo, cartoes.numero_cartao, cartoes.limite_cartao
FROM clientes
INNER JOIN conta
	ON clientes.titular_id = conta.titular
INNER JOIN cartoes
	ON conta.titular = titular_cartao
WHERE limite_cartao >= 1000; -- FILTRO NA INNER JOIN

-- CRIAÇÃO DA VIEW --
    
CREATE VIEW clientes_plus AS SELECT
	titular,
    conta_id,
    saldo
FROM conta
WHERE saldo > 2000;

SELECT * FROM clientes_plus;