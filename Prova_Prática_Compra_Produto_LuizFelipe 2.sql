CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Atendente (
    id_atendente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE Produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    valor NUMERIC(10,2) NOT NULL
);

CREATE TABLE Compra (
    id_compra SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES Cliente(id_cliente),
    id_atendente INT NOT NULL REFERENCES Atendente(id_atendente),
    data_compra DATE NOT NULL,
    valor_total NUMERIC(10,2)
);

CREATE TABLE Item_Compra (
    id_item SERIAL PRIMARY KEY,
    id_compra INT NOT NULL REFERENCES Compra(id_compra),
    id_produto INT NOT NULL REFERENCES Produto(id_produto),
    quantidade INT NOT NULL,
    valor_parcial NUMERIC(10,2)
);
-- Inserir clientes
INSERT INTO Cliente (nome, email) VALUES
('Maria Silva', 'maria.silva@email.com'),
('João Souza', 'joao.souza@email.com'),
('Ana Costa', 'ana.costa@email.com');

-- Inserir atendentes
INSERT INTO Atendente (nome) VALUES
('Carlos Lima'),
('Fernanda Alves'),
('Paulo Santos');

-- Inserir produtos
INSERT INTO Produto (nome, valor) VALUES
('Notebook', 3500.00),
('Mouse', 80.00),
('Teclado', 150.00);

-- Inserir compras
INSERT INTO Compra (id_cliente, id_atendente, data_compra, valor_total) VALUES
(1, 1, '2025-10-02', 3680.00),
(2, 2, '2025-09-25', 150.00),
(1, 3, '2025-11-05', 80.00);

-- Inserir itens das compras
INSERT INTO Item_Compra (id_compra, id_produto, quantidade, valor_parcial) VALUES
(1, 1, 1, 3500.00),
(1, 2, 1, 80.00),
(2, 3, 1, 150.00),
(3, 2, 1, 80.00);

-- nome do cliente, atendente e valor total
SELECT 
    c.nome AS cliente,
    a.nome AS atendente,
    co.valor_total
FROM Compra co
JOIN Cliente c ON co.id_cliente = c.id_cliente
JOIN Atendente a ON co.id_atendente = a.id_atendente;

-- prod. vendidos, quant. e valor parcial
SELECT 
    co.id_compra,
    p.nome AS produto,
    ic.quantidade,
    ic.valor_parcial
FROM Item_Compra ic
JOIN Produto p ON ic.id_produto = p.id_produto
JOIN Compra co ON ic.id_compra = co.id_compra;

-- compras apos 01/10/2025
SELECT * 
FROM Compra
WHERE data_compra > '2025-10-01';

-- client. realizaram mais de uma compra
SELECT 
    c.nome,
    COUNT(co.id_compra) AS total_compras
FROM Compra co
JOIN Cliente c ON co.id_cliente = c.id_cliente
GROUP BY c.nome
HAVING COUNT(co.id_compra) > 1;


-- update
UPDATE Produto SET Estoque = 100;

UPDATE Cliente
SET email = 'maria.silva@novoemail.com'
WHERE nome = 'Maria Silva';

-- alor total de vendas e iten mais caro
SELECT SUM(valor_total) AS total_geral_vendas FROM Compra;

SELECT nome, valor
FROM Produto
WHERE valor = (SELECT MAX(valor) FROM Produto);

-- atendentes e numeros de vendas registrados
SELECT 
    a.nome AS atendente,
    COUNT(co.id_compra) AS num_vendas
FROM Atendente a
LEFT JOIN Compra co ON a.id_atendente = co.id_atendente
GROUP BY a.nome;