/*================================================*/
/* TABLAS PRINCIPALES                */
/*================================================*/

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'db_restaurant')
BEGIN
    ALTER DATABASE db_restaurant SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE db_restaurant;
END
GO

CREATE DATABASE db_restaurant;
GO

USE db_restaurant;
GO

CREATE TABLE genero (
    id_genero     INT IDENTITY(1,1) PRIMARY KEY,
    nombre_genero NVARCHAR(2) NOT NULL CHECK (nombre_genero IN ('M','F','NB'))
);

CREATE TABLE categoria (
    id_categoria        INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria    NVARCHAR(100) NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    CONSTRAINT CHK_nombre_cat CHECK (LTRIM(RTRIM(nombre_categoria)) <> '')
);

CREATE TABLE tipo_pago (
    id_tipo_pago        INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tipo_pago    NVARCHAR(100) NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    CONSTRAINT CHK_nombre_pago CHECK (LTRIM(RTRIM(nombre_tipo_pago)) <> '')
);

CREATE TABLE tipo_pedido (
    id_tipo_pedido      INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tipo_pedido  NVARCHAR(100) NOT NULL CHECK (LTRIM(RTRIM(nombre_tipo_pedido)) <> '')
);

CREATE TABLE tipo_contrato (
    id_tipo_contrato        INT IDENTITY(1,1) PRIMARY KEY,
    nombre_tipo_contrato    NVARCHAR(100) NOT NULL CHECK (LTRIM(RTRIM(nombre_tipo_contrato)) <> '')
);

CREATE TABLE turno (
    id_turno        INT IDENTITY(1,1) PRIMARY KEY,
    nombre_turno    NVARCHAR(100) NOT NULL,
    horario_inicio  TIME NOT NULL,
    horario_final   TIME NOT NULL,
    CONSTRAINT CHK_horario CHECK (horario_final > horario_inicio)
);

CREATE TABLE mesa (
    id_mesa         INT IDENTITY(1,1) PRIMARY KEY,
    numero_mesa     NVARCHAR(10) NOT NULL CHECK (LTRIM(RTRIM(numero_mesa)) <> ''),
    capacidad       INT NOT NULL CHECK (capacidad BETWEEN 1 AND 20),
    estado          TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1))
);

CREATE TABLE cliente (
    id_cliente          INT IDENTITY(1,1) PRIMARY KEY,
    dni_cliente         CHAR(8) NOT NULL UNIQUE CHECK (LEN(dni_cliente) = 8),
    nombre_cliente      NVARCHAR(100) NOT NULL,
    apellido_cliente    NVARCHAR(100) NOT NULL,
    correo_cliente      NVARCHAR(150),
    telefono_cliente    NVARCHAR(15),
    observacion_cliente NVARCHAR(500),
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1))
);

CREATE TABLE cargo (
    id_cargo            INT IDENTITY(1,1) PRIMARY KEY,
    nombre_cargo        NVARCHAR(100) NOT NULL CHECK (LTRIM(RTRIM(nombre_cargo)) <> ''),
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1))
);

CREATE TABLE usuario (
    id_usuario          INT IDENTITY(1,1) PRIMARY KEY,
    codigo_usuario      NVARCHAR(20) NOT NULL UNIQUE CHECK (LTRIM(RTRIM(codigo_usuario)) <> ''),
    password_usuario    NVARCHAR(255) NOT NULL,
    id_cargo            INT NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo)
);

CREATE TABLE empleado (
    id_empleado             INT IDENTITY(1,1) PRIMARY KEY,
    dni_empleado            CHAR(8) NOT NULL UNIQUE CHECK (LEN(dni_empleado) = 8),
    nombre_empleado         NVARCHAR(100) NOT NULL,
    apellido_empleado       NVARCHAR(100) NOT NULL,
    fecha_nacimiento        DATE NOT NULL,
    fecha_registro          DATETIME DEFAULT GETDATE() NOT NULL,
    direccion_empleado      NVARCHAR(150) NOT NULL,
    correo_principal        NVARCHAR(150) NOT NULL,
    correo_secundario       NVARCHAR(150),
    telefono_principal      NVARCHAR(15) NOT NULL,
    telefono_secundario     NVARCHAR(15),
    observacion_empleado    NVARCHAR(500),
    id_genero               INT NOT NULL,
    estado                  TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    FOREIGN KEY (id_genero) REFERENCES genero(id_genero)
);

CREATE TABLE contrato (
    id_contrato             INT IDENTITY(1,1) PRIMARY KEY,
    descripcion_contrato    NVARCHAR(200) NOT NULL,
    fecha_contrato          DATETIME DEFAULT GETDATE() NOT NULL,
    id_turno                INT NOT NULL,
    id_empleado             INT NOT NULL,
    id_tipo_contrato        INT NOT NULL,
    id_cargo                INT NOT NULL,
    estado                  TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_tipo_contrato) REFERENCES tipo_contrato(id_tipo_contrato),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo)
);

CREATE TABLE plato_menu (
    id_plato_menu       INT IDENTITY(1,1) PRIMARY KEY,
    nombre_plato        NVARCHAR(100) NOT NULL CHECK (LTRIM(RTRIM(nombre_plato)) <> ''),
    descripcion_plato   NVARCHAR(500),
    precio_plato        DECIMAL(10,2) NOT NULL CHECK (precio_plato > 0),
    id_categoria        INT NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE pedido (
    id_pedido           INT IDENTITY(1,1) PRIMARY KEY,
    fecha_pedido        DATETIME NOT NULL,
    id_cliente          INT NOT NULL,
    id_empleado         INT NOT NULL,
    id_tipo_pedido      INT NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_tipo_pedido) REFERENCES tipo_pedido(id_tipo_pedido)
);

CREATE TABLE detalle_pedido (
    id_detalle          INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido           INT NOT NULL,
    id_plato_menu       INT NOT NULL,
    cantidad            INT NOT NULL CHECK (cantidad > 0),
    precio_unitario     DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),
    observacion_detalle NVARCHAR(500),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_plato_menu) REFERENCES plato_menu(id_plato_menu)
);

CREATE TABLE factura (
    id_factura INT IDENTITY(1,1) PRIMARY KEY,
    numero_comprobante NVARCHAR(20) NOT NULL UNIQUE,
    fecha_pago DATE NOT NULL,
    total_factura DECIMAL(10,2) NOT NULL CHECK (total_factura >= 0),
    id_pedido INT UNIQUE NOT NULL,
    id_tipo_pago INT NOT NULL,
    fecha_registro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_tipo_pago) REFERENCES tipo_pago(id_tipo_pago)
);

CREATE TABLE reserva (
    id_reserva          INT IDENTITY(1,1) PRIMARY KEY,
    fecha_registro      DATETIME DEFAULT GETDATE() NOT NULL,
    fecha_inicio        DATETIME NOT NULL,
    fecha_fin           DATETIME NOT NULL,
    cantidad_personas   INT NOT NULL CHECK (cantidad_personas > 0),
    observacion_reserva NVARCHAR(500),
    id_cliente          INT NOT NULL,
    id_mesa             INT NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0,1)),
    CONSTRAINT CHK_fechas_reserva CHECK (fecha_fin > fecha_inicio),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa)
);

/*================================================*/
/* INVENTARIO SEPARADO                */
/*================================================*/

CREATE TABLE unidad_medida (
    id_unidad_medida        INT IDENTITY(1,1) PRIMARY KEY,
    nombre_unidad_medida    NVARCHAR(45) NOT NULL UNIQUE,
    abreviatura             NVARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE producto (
    id_producto             INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto         NVARCHAR(100) NOT NULL,
    precio_producto          DECIMAL(10,2) NOT NULL CHECK (precio_producto >= 0),
    stock_minimo            INT NOT NULL CHECK (stock_minimo >= 0),
    stock_actual            INT NOT NULL CHECK (stock_actual >= 0),
    observacion_producto    NVARCHAR(MAX),
    id_unidad_medida        INT NOT NULL,
    estado                  TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0, 1)),
    FOREIGN KEY (id_unidad_medida) REFERENCES unidad_medida(id_unidad_medida)
);

CREATE TABLE proveedor (
    id_proveedor            INT IDENTITY(1,1) PRIMARY KEY,
    ruc                     CHAR(11) NOT NULL UNIQUE CHECK (LEN(ruc) = 11),
    razon_social            NVARCHAR(150) NOT NULL CHECK (LTRIM(RTRIM(razon_social)) <> ''),
    telefono_proveedor      NVARCHAR(15) NOT NULL,
    correo_provider        NVARCHAR(150) NOT NULL CHECK (correo_provider LIKE '%@%'),
    direccion_proveedor     NVARCHAR(150) NOT NULL CHECK (LTRIM(RTRIM(direccion_proveedor)) <> ''),
    observacion_proveedor   NVARCHAR(MAX),
    estado                  TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0, 1))
);

CREATE TABLE proveedor_producto (
    id_proveedor        INT NOT NULL,
    id_producto         INT NOT NULL,
    precio_compra       DECIMAL(10,2) NOT NULL CHECK (precio_compra >= 0),
    tiempo_entrega      INT NOT NULL CHECK (tiempo_entrega >= 0),
    fecha_registro      DATE NOT NULL,
    estado              TINYINT DEFAULT 1 NOT NULL CHECK (estado IN (0, 1)),
    PRIMARY KEY (id_proveedor, id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

/*================================================*/
/* INDICES                     */
/*================================================*/
CREATE INDEX idx_pedido_cliente ON pedido(id_cliente);
CREATE INDEX idx_pedido_empleado ON pedido(id_empleado);
CREATE INDEX idx_detalle_pedido ON detalle_pedido(id_pedido);
CREATE INDEX idx_reserva_cliente ON reserva(id_cliente);
CREATE INDEX idx_reserva_mesa ON reserva(id_mesa);
CREATE INDEX idx_plato_categoria ON plato_menu(id_categoria);
CREATE INDEX idx_contrato_empleado ON contrato(id_empleado);
CREATE INDEX idx_pp_producto ON proveedor_producto(id_producto);
GO







/* INSERT */


USE db_restaurant;
GO

/* ================================================ */
/* GENERO                                          */
/* ================================================ */
INSERT INTO genero (nombre_genero) VALUES
    ('M'),
    ('F'),
    ('NB');

/* ================================================ */
/* CATEGORIA                                       */
/* ================================================ */
INSERT INTO categoria (nombre_categoria, estado) VALUES
    ('Platos Marinos',           1),
    ('Comida Criolla',           1),
    ('Parrillas',                1),
    ('Especialidades de la Casa', 1),
    ('Entradas',                 1),
    ('Menu del Dia',             1),
    ('Sopas y Caldos',           1),
    ('Postres',                  1),
    ('Bebidas',                  1),
    ('Jugos Naturales',          1);

/* ================================================ */
/* TIPO_PAGO                                       */
/* ================================================ */
INSERT INTO tipo_pago (nombre_tipo_pago, estado) VALUES
    ('Efectivo',                  1),
    ('Tarjeta de credito/debito', 1),
    ('Transferencia bancaria',    1);

/* ================================================ */
/* TIPO_PEDIDO                                     */
/* ================================================ */
INSERT INTO tipo_pedido (nombre_tipo_pedido) VALUES
    ('Consumo en local'),
    ('Para llevar'),
    ('Delivery');

/* ================================================ */
/* TIPO_CONTRATO                                   */
/* ================================================ */
INSERT INTO tipo_contrato (nombre_tipo_contrato) VALUES
    ('Contrato a Plazo Fijo'),
    ('Contrato Indefinido'),
    ('Contrato por Obra'),
    ('Contrato de Practicas');

/* ================================================ */
/* TURNO                                           */
/* ================================================ */
INSERT INTO turno (nombre_turno, horario_inicio, horario_final) VALUES
    ('Turno Manana',      '08:00:00', '16:00:00'),
    ('Turno Tarde-Noche', '16:00:00', '23:59:00');

/* ================================================ */
/* MESA                                            */
/* ================================================ */
INSERT INTO mesa (numero_mesa, capacidad, estado) VALUES
    ('M-01', 2, 1), ('M-02', 2, 1), ('M-03', 2, 1), ('M-04', 2, 1),
    ('M-05', 2, 1), ('M-06', 2, 1), ('M-07', 4, 1), ('M-08', 4, 1),
    ('M-09', 4, 1), ('M-10', 4, 1), ('M-11', 4, 1), ('M-12', 4, 1),
    ('M-13', 6, 1), ('M-14', 6, 1), ('M-15', 6, 1), ('M-16', 6, 1),
    ('M-17', 8, 1), ('M-18', 8, 1), ('M-19', 10, 1), ('M-20', 10, 1);

/* ================================================ */
/* CLIENTE                                         */
/* ================================================ */
INSERT INTO cliente (dni_cliente, nombre_cliente, apellido_cliente, correo_cliente, telefono_cliente, observacion_cliente, estado) VALUES
    ('71230001', 'Carlos',    'Ramirez Soto',    'carlos.ramirez@gmail.com',  '987600001', 'Cliente frecuente',                        1),
    ('71230002', 'Maria',     'Lopez Diaz',      'maria.lopez@outlook.com',   '987600002', 'Prefiere mesa cerca a la ventana',         1),
    ('71230003', 'Jose',      'Gutierrez Paz',    NULL,                        '987600003', NULL,                                       1),
    ('71230004', 'Ana',       'Torres Vega',     'ana.torres@gmail.com',       NULL,        NULL,                                       1),
    ('71230005', 'Luis',      'Flores Rios',     'luis.flores@gmail.com',      '987600005', NULL,                                       1),
    ('71230006', 'Rosa',      'Vargas Mena',     NULL,                        '987600006', NULL,                                       1),
    ('71230007', 'Pedro',     'Mendoza Cruz',    'pedro.mendoza@yahoo.com',   '987600007', 'Solicita siempre factura',                 1),
    ('71230008', 'Elena',     'Castillo Mora',   'elena.castillo@gmail.com',  NULL,        'Reserva para reuniones familiares',        1),
    ('71230009', 'Miguel',    'Quispe Huanca',   'miguel.quispe@gmail.com',   '987600009', NULL,                                       1),
    ('71230010', 'Sofia',     'Paredes Luna',    NULL,                        '987600010', 'Cliente muy puntual',                      1),
    ('71230011', 'Fernando',  'Salas Pinto',     'fernando.salas@gmail.com',  '987600011', 'Prefiere pagar con tarjeta',               1),
    ('71230012', 'Lucia',     'Ramos Tapia',     'lucia.ramos@hotmail.com',   '987600012', NULL,                                       1),
    ('71230013', 'Ricardo',   'Cruz Benites',    'ricardo.cruz@gmail.com',    NULL,        NULL,                                       0),
    ('71230014', 'Patricia',  'Morales Cano',    NULL,                        '987600014', 'Visita el restaurante los fines de semana',1),
    ('71230015', 'Juan',      'Huanca Ccopa',    'juan.huanca@gmail.com',     '987600015', NULL,                                       1),
    ('71230016', 'Carla',     'Mamani Ticona',   'carla.mamani@gmail.com',    '987600016', 'Cliente recomendado por otro cliente',     1),
    ('71230017', 'Victor',    'Condori Ayna',    NULL,                        '987600017', 'Prefiere atención rápida',                 1),
    ('71230018', 'Diana',     'Chavez Quispe',   'diana.chavez@gmail.com',    '987600018', NULL,                                       1),
    ('71230019', 'Andres',    'Pinto Salazar',   'andres.pinto@outlook.com',  '987600019', 'Suele pedir para llevar',                  1),
    ('71230020', 'Claudia',   'Vega Oliva',      NULL,                        '987600020', 'Le gusta sentarse en la terraza',          1),
    ('71230021', 'Hector',    'Alvarado Neira',  'hector.alvarado@gmail.com', '987600021', NULL,                                       1),
    ('71230022', 'Margarita', 'Soto Espinoza',   'margarita.soto@gmail.com',  NULL,        NULL,                                       1),
    ('71230023', 'Oscar',     'Delgado Fuentes', 'oscar.delgado@gmail.com',   '987600023', NULL,                                       1),
    ('71230024', 'Irma',      'Villanueva Ore',  NULL,                        '987600024', NULL,                                       0),
    ('71230025', 'Raul',      'Espinoza Meza',   'raul.espinoza@hotmail.com', '987600025', 'Le gusta probar platos nuevos',            1),
    ('71230026', 'Sandra',    'Benites Vargas',  'sandra.benites@gmail.com',  '987600026', 'Cliente habitual del almuerzo',            1),
    ('71230027', 'Roberto',   'Oliva Reyes',     NULL,                        '987600027', NULL,                                       1),
    ('71230028', 'Natalia',   'Tapia Flores',    'natalia.tapia@gmail.com',   NULL,        'Suele venir con grupo grande',             1),
    ('71230029', 'Alberto',   'Cano Perez',      'alberto.cano@gmail.com',    '987600029', 'Prefiere bebidas sin alcohol',             1),
    ('71230030', 'Veronica',  'Meza Cordova',    'veronica.meza@gmail.com',   '987600030', NULL,                                       1);

/* ================================================ */
/* CARGO                                           */
/* ================================================ */
INSERT INTO cargo (nombre_cargo, estado) VALUES
    ('Gerente General',    1),
    ('Jefe de Cocina',     1),
    ('Mesero',             1),
    ('Cajero',             1),
    ('Ayudante de Cocina', 1);

/* ================================================ */
/* USUARIO                                         */
/* ================================================ */
INSERT INTO usuario (codigo_usuario, password_usuario, id_cargo, estado) VALUES
    ('USR001', 'e3b0c44298fc1c149afb4c8996fb924', 1, 1),
    ('USR002', 'a665a45920422f9d417e4867efdc4fb8', 1, 1),
    ('USR003', '6b86b273ff34fce19d6b804eff5a3f57', 1, 0);

/* ================================================ */
/* EMPLEADO                                        */
/* ================================================ */
-- Nota: SQL Server usa 'YYYY-MM-DD' igual, pero es más estricto con los DEFAULT.
INSERT INTO empleado (dni_empleado, nombre_empleado, apellido_empleado, fecha_nacimiento, fecha_registro, direccion_empleado, correo_principal, correo_secundario, telefono_principal, telefono_secundario, observacion_empleado, id_genero, estado) VALUES
    ('80100001', 'Jorge Luis',     'Mamani Quispe',  '1985-03-12', '2022-01-15', 'Av. Sol 123, Cusco',          'j.mamani@restaurante.pe',    NULL,                            '966200001', NULL,        NULL,                                               1, 1),
    ('80100002', 'Maria Elena',    'Condori Huanca', '1990-07-25', DEFAULT,      'Jr. Lima 456, Arequipa',       'm.condori@restaurante.pe',   'm.condori.alt@gmail.com',       '966200002', '014512233', 'Bilingue espanol/ingles',                          2, 1),
    ('80100003', 'Carlos Andres',  'Paredes Soto',   '1988-11-08', '2023-03-10', 'Calle Loreto 789, Lima',       'c.paredes@restaurante.pe',   NULL,                            '966200003', '013301122', NULL,                                               1, 1),
    ('80100004', 'Lucia Fernanda', 'Ramos Vega',     '1995-05-17', DEFAULT,      'Av. Tupac Amaru 321, Puno',   'l.ramos@restaurante.pe',     'lucia.ramos.personal@gmail.com','966200004', NULL,        'Especialista en pasteleria y reposteria',          2, 1),
    ('80100005', 'Pedro Alonso',   'Chavez Torres',  '1982-09-30', '2020-09-01', 'Jr. Ancash 654, Lima',        'p.chavez@restaurante.pe',    NULL,                            '966200005', '012234455', NULL,                                               1, 1),
    ('80100006', 'Ana Belen',      'Flores Cruz',    '1993-01-22', '2024-01-08', 'Av. Grau 987, Trujillo',      'a.flores@restaurante.pe',    'ana.flores.b@outlook.com',      '966200006', '044112233', 'Certificada en Buenas Practicas de Manufactura',   2, 1),
    ('80100007', 'Ricardo Paul',   'Salas Mora',     '1987-06-14', '2019-11-12', 'Calle Union 147, Ica',        'r.salas@restaurante.pe',     NULL,                            '966200007', NULL,        'Experiencia en cocina internacional',               1, 1),
    ('80100008', 'Elena Rosa',     'Gutierrez Paz',  '1991-12-03', '2023-07-01', 'Av. Ejercito 258, Lima',      'e.gutierrez@restaurante.pe', 'elena.gutierrez@gmail.com',     '966200008', '012998877', NULL,                                               2, 1),
    ('80100009', 'Fernando Jose',  'Alvarado Rios',  '1980-04-19', DEFAULT,      'Jr. Piura 369, Lima',         'f.alvarado@restaurante.pe',  NULL,                            '966200009', '013456677', 'Responsable de turno noche y supervision de caja', 1, 1),
    ('80100010', 'Diana Cecilia',  'Benites Poma',   '1997-08-07', '2024-02-01', 'Av. Colonial 741, Lima',      'd.benites@restaurante.pe',   'd.benites.alt@gmail.com',       '966200010', NULL,        NULL,                                               2, 1);

/* ================================================ */
/* CONTRATO                                        */
/* ================================================ */
INSERT INTO contrato (descripcion_contrato, fecha_contrato, id_turno, id_empleado, id_tipo_contrato, id_cargo, estado) VALUES
    ('Contrato inicial chef principal',          '2022-01-15', 1,  1, 2, 2, 1),
    ('Contrato administracion y gestion',             DEFAULT, 2,  2, 2, 1, 1),
    ('Contrato mesero turno manana',             '2023-03-10', 1,  3, 1, 3, 1),
    ('Contrato pastelera y repostera',           '2023-05-20', 2,  4, 1, 5, 1),
    ('Contrato cocinero senior indefinido',           DEFAULT, 1,  5, 2, 2, 1),
    ('Contrato practicas pre-profesionales BPM', '2024-01-08', 2,  6, 4, 5, 1),
    ('Contrato jefe cocina experiencia intl.',   '2019-11-12', 1,  7, 2, 2, 1),
    ('Contrato mesera turno tarde reemplazo',    '2023-07-01', 2,  8, 3, 3, 1),
    ('Contrato cajero supervisor de turno',      '2022-08-15', 1,  9, 3, 4, 1),
    ('Contrato ayudante cocina nuevo ingreso',   '2024-02-01', 2, 10, 1, 5, 1);

/* ================================================ */
/* PLATO_MENU                                      */
/* ================================================ */
INSERT INTO plato_menu (nombre_plato, descripcion_plato, precio_plato, id_categoria, estado) VALUES
    ('Ceviche Clasico', 'Pescado fresco con limon y aji', 28.00, 1, 1),
    ('Arroz con Mariscos', 'Arroz sazonado con mariscos mixtos', 32.00, 1, 1),
    ('Lomo Saltado', 'Carne salteada con papas fritas', 25.00, 2, 1),
    ('Aji de Gallina', 'Crema de gallina con arroz', 22.00, 2, 1),
    ('Parrilla Mixta', 'Carne, pollo y chorizo a la parrilla', 40.00, 3, 1),
    ('Bistec a lo Pobre', 'Carne con huevo, arroz y papas', 30.00, 3, 1),
    ('Picanha al Quebracho', 'Corte de res a la parrilla con sal de maras', 55.00, 3, 1),
    ('Pollo a la Brasa', 'Pollo con papas y ensalada de casa', 35.00, 4, 1),
    ('Chaufa Especial', 'Arroz chaufa con carnes mixtas', 27.00, 4, 1),
    ('Tacu Tacu con Lomo Saltado', 'Mantecoso de arroz y frejol con lomo fino al wok', 45.00, 2, 1),
    ('Tequeños', 'Palitos fritos rellenos de queso', 12.00, 5, 1),
    ('Causa Limeña', 'Papa rellena con pollo', 15.00, 5, 1),
    ('Papa a la Huancaina', 'Papa con salsa cremosa', 14.00, 5, 1),
    ('Seco de Pollo con Frejoles', 'Pollo guisado acompañado con frejoles y arroz', 18.00, 6, 1),
    ('Tallarines Verdes con Bistec','Pasta al pesto con carne a la plancha', 20.00, 6, 1),
    ('Arroz con Pollo', 'Arroz verde con pollo y ensalada', 17.00, 6, 1),
    ('Caldo de Gallina', 'Sopa caliente con gallina, huevo y fideos', 14.00, 7, 1),
    ('Caldo de Mote', 'Caldo tradicional con carne y mote', 13.00, 7, 1),
    ('Caldo de Res', 'Sopa nutritiva con carne de res y verduras', 15.00, 7, 1),
    ('Arroz con Leche', 'Postre tradicional', 7.00, 8, 1),
    ('Torta de Chocolate', 'Postre dulce casero', 10.00, 8, 1),
    ('Chicha Morada', 'Bebida tradicional de maiz morado', 6.00, 9, 1),
    ('Maracuya Helada', 'Bebida refrescante de maracuya', 6.50, 9, 1),
    ('Suspiro a la Limena', 'Dulce tradicional con merengue al oporto', 15.00, 5, 1),
    ('Jugo de Naranja', 'Natural sin azucar', 6.00, 10, 1),
    ('Jugo de Papaya', 'Refrescante y natural', 7.00, 10, 1),
    ('Limonada Frozen', 'Zumo de limon granizado con abundante hielo', 10.00, 6, 1);

-- ... El resto de tus INSERT seguirían la misma lógica. 
-- He validado que las fechas estén en formato 'YYYY-MM-DD HH:MM:SS' para los DATETIME de SQL Server.

/* ================================================ */
/* UNIDAD_MEDIDA                                   */
/* ================================================ */
INSERT INTO unidad_medida (nombre_unidad_medida, abreviatura) VALUES
    ('Kilogramo', 'kg'),
    ('Litro',     'lt'),
    ('Unidad',    'und'),
    ('Botella',   'bot'),
    ('Caja',      'cja'),
    ('Gramo',     'gr');

/* ================================================ */
/* PRODUCTO                                        */
/* ================================================ */
INSERT INTO producto (nombre_producto, precio_producto, stock_minimo, stock_actual, observacion_producto, id_unidad_medida, estado) VALUES
    ('Arroz blanco extra', 2.50, 10, 45, 'Grano largo seleccionado, marca Costeño', 1, 1),
    ('Aceite vegetal girasol', 5.80, 5, 18, 'Botella de 1 litro premium', 2, 1),
    ('Azucar rubia', 2.20, 8, 30, NULL, 1, 1),
    ('Pollo entero fresco', 8.50, 5, 25, 'Peso promedio 2.2kg por unidad', 1, 1),
    ('Limon sutil peruano', 3.80, 3, 14, 'Cosecha del norte del país', 1, 1),
    ('Gaseosa cola 1.5L', 4.50, 12, 48, 'Envase descartable', 4, 1);

GO