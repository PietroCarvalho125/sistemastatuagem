CREATE DATABASE IF NOT EXISTS `estudio_tatuagem` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `estudio_tatuagem`;

DROP TABLE IF EXISTS `agendamento`;
DROP TABLE IF EXISTS `tatuador_estilo`;
DROP TABLE IF EXISTS `usuario`;
DROP TABLE IF EXISTS `tatuador`;
DROP TABLE IF EXISTS `cliente`;
DROP TABLE IF EXISTS `estilo`;
DROP TABLE IF EXISTS `senioridade`;

CREATE TABLE `senioridade` (
  `idsenioridade` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`idsenioridade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `senioridade` (`idsenioridade`, `nome`) VALUES
(1, 'Júnior'),
(2, 'Pleno'),
(3, 'Sênior');

CREATE TABLE `estilo` (
  `idestilo` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(50) NOT NULL,
  PRIMARY KEY (`idestilo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `estilo` (`idestilo`, `descricao`) VALUES
(1, 'Blackwork'),
(2, 'Aquarela'),
(3, 'Realismo'),
(4, 'Old School');

CREATE TABLE `cliente` (
  `idcliente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `datacadastro` date DEFAULT NULL,
  `cidade` varchar(80) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  PRIMARY KEY (`idcliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `cliente` (`idcliente`, `nome`, `cpf`, `telefone`, `datacadastro`, `cidade`, `uf`) VALUES
(1, 'Ana Silva', '12345678901', '(11) 99999-1111', '2024-01-10', 'São Paulo', 'SP'),
(2, 'Bruno Costa', '23456789012', '(11) 98888-2222', '2024-02-05', 'Campinas', 'SP'),
(3, 'Carla Dias', '34567890123', '(21) 97777-3333', '2024-03-15', 'Rio de Janeiro', 'RJ');

CREATE TABLE `tatuador` (
  `idtatuador` int NOT NULL AUTO_INCREMENT,
  `nometatuador` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `datacontratacao` date DEFAULT NULL,
  `idsenioridade` int DEFAULT NULL,
  PRIMARY KEY (`idtatuador`),
  KEY `fk_tatuador_senioridade` (`idsenioridade`),
  CONSTRAINT `fk_tatuador_senioridade` FOREIGN KEY (`idsenioridade`) REFERENCES `senioridade` (`idsenioridade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tatuador` (`idtatuador`, `nometatuador`, `cpf`, `email`, `telefone`, `datacontratacao`, `idsenioridade`) VALUES
(1, 'Lucas Mendes', '11122233344', 'lucas@estudio.com', '(11) 98888-4444', '2023-01-15', 3),
(2, 'Mateus Rocha', '22233344455', 'mateus@estudio.com', '(11) 97777-5555', '2023-05-21', 2),
(3, 'Nina Alves', '33344455566', 'nina@estudio.com', '(21) 96666-6666', '2024-01-05', 1);

CREATE TABLE `tatuador_estilo` (
  `idtatuador` int NOT NULL,
  `idestilo` int NOT NULL,
  `dataestilo` date DEFAULT NULL,
  PRIMARY KEY (`idtatuador`, `idestilo`),
  KEY `fk_tatuador_estilo_tatuador` (`idtatuador`),
  KEY `fk_tatuador_estilo_estilo` (`idestilo`),
  CONSTRAINT `fk_tatuador_estilo_tatuador` FOREIGN KEY (`idtatuador`) REFERENCES `tatuador` (`idtatuador`),
  CONSTRAINT `fk_tatuador_estilo_estilo` FOREIGN KEY (`idestilo`) REFERENCES `estilo` (`idestilo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tatuador_estilo` (`idtatuador`, `idestilo`, `dataestilo`) VALUES
(1, 1, '2024-01-10'),
(1, 3, '2024-01-11'),
(2, 2, '2024-02-16'),
(3, 4, '2024-03-12');

CREATE TABLE `agendamento` (
  `idagendamento` int NOT NULL AUTO_INCREMENT,
  `idcliente` int NOT NULL,
  `idtatuador` int NOT NULL,
  `dataagendamento` date NOT NULL,
  `horaagendamento` time NOT NULL,
  `descricaotatuagem` text,
  `valortatuagem` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pendente',
  `desenhoaprovado` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idagendamento`),
  KEY `fk_agendamento_cliente` (`idcliente`),
  KEY `fk_agendamento_tatuador` (`idtatuador`),
  CONSTRAINT `fk_agendamento_cliente` FOREIGN KEY (`idcliente`) REFERENCES `cliente` (`idcliente`),
  CONSTRAINT `fk_agendamento_tatuador` FOREIGN KEY (`idtatuador`) REFERENCES `tatuador` (`idtatuador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `agendamento` (`idagendamento`, `idcliente`, `idtatuador`, `dataagendamento`, `horaagendamento`, `descricaotatuagem`, `valortatuagem`, `status`, `desenhoaprovado`) VALUES
(1, 1, 1, '2024-05-10', '15:30:00', 'Fênix nas costas', 450.00, 'pendente', NULL),
(2, 2, 2, '2024-05-12', '10:00:00', 'Rosa e folhas', 380.00, 'confirmado', NULL),
(3, 3, 3, '2024-05-15', '18:00:00', 'Lobo em realismo', 700.00, 'concluido', NULL);

CREATE TABLE `usuario` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL UNIQUE,
  `senha` varchar(255) NOT NULL,
  `tipo` enum('admin','funcionario','cliente') NOT NULL DEFAULT 'funcionario',
  `idcliente` int DEFAULT NULL,
  PRIMARY KEY (`idusuario`),
  KEY `fk_usuario_cliente` (`idcliente`),
  CONSTRAINT `fk_usuario_cliente` FOREIGN KEY (`idcliente`) REFERENCES `cliente` (`idcliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `usuario` (`nome`, `email`, `senha`, `tipo`, `idcliente`) VALUES
('Administrador do Estúdio', 'admin@estudio.com', '$2b$12$Xy81naP8CAfUjddtDLk6AOKI.vlM5p2lvuLOzllTK5/g6asR6Cvhm', 'admin', NULL),
('Helena da Recepção', 'funcionario@estudio.com', '$2b$12$8zwAqfqm/cTvd/QwZh/E0uCbAm4htZpxMS1DrYrLQs1aiIFHxB8X2', 'funcionario', NULL),
('Ana Silva', 'cliente@estudio.com', '$2b$12$v01PGlNPwy9yDRDI2LMnSO0nZiv8kbbczhRrGL2weVSrQEQGonamG', 'cliente', 1);
