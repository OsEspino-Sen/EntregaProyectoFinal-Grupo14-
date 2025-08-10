-- creacion de base de datos
CREATE DATABASE IF NOT EXISTS biblioteca_db;
USE biblioteca_db;

-- creacion de tablas
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE autores (
    autor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_autor VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    fecha_nacimiento DATE
);

CREATE TABLE libros (
    libro_id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    categoria_id INT,
    observaciones VARCHAR(500) NULL,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

CREATE TABLE libros_autores (
    libro_id INT,
    autor_id INT,
    PRIMARY KEY (libro_id, autor_id),
    FOREIGN KEY (libro_id) REFERENCES libros (libro_id),
    FOREIGN KEY (autor_id) REFERENCES autores (autor_id)
);

CREATE TABLE ejemplares (
    ejemplar_id INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT,
    estado ENUM('Disponible', 'Prestado', 'Extraviado', 'Dado de Baja') DEFAULT 'Disponible',
    FOREIGN KEY (libro_id) REFERENCES libros (libro_id)
);

CREATE TABLE usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    identidad CHAR(13) UNIQUE NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    email VARCHAR(100),
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    dni VARCHAR(20)
);

CREATE TABLE empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    identidad CHAR(13) UNIQUE NOT NULL,
    nombre_completo VARCHAR(200) NOT NULL,
    cargo VARCHAR(100),
    telefono VARCHAR(12),
    email VARCHAR(100)
);

CREATE TABLE usuarios_login (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL,
    rol ENUM('admin', 'recepcionista') DEFAULT 'recepcionista' NOT NULL
);

CREATE TABLE prestamos (
    prestamo_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    empleado_id INT,
    ejemplar_id INT,
    fecha_prestamo DATE,
    fecha_limite DATE,
    obervaciones VARCHAR(200),
    FOREIGN KEY (usuario_id) REFERENCES usuarios (usuario_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados (empleado_id),
    FOREIGN KEY (ejemplar_id) REFERENCES ejemplares (ejemplar_id)
);

CREATE TABLE devoluciones (
    devolucion_id INT AUTO_INCREMENT PRIMARY KEY,
    prestamo_id INT,
    fecha_devolucion DATE,
    multa DECIMAL(8,2) DEFAULT 0,
    obervaciones VARCHAR(200),
    estado VARCHAR(50),
    FOREIGN KEY (prestamo_id) REFERENCES prestamos (prestamo_id)
);

CREATE TABLE historial_ejemplar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ejemplar_id INT,
    estado_anterior VARCHAR(20),
    estado_nuevo VARCHAR(20),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ejemplar_id) REFERENCES ejemplares(ejemplar_id)
);

CREATE TABLE auditoria_acciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_login_id INT,
    accion VARCHAR(10) NOT NULL,
    entidad_id INT NOT NULL, -- prestamo_id o devolucion_id
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_login_id) REFERENCES usuarios_login(id)
);

select * from autores;

select * from libros;

-- --------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- insercion de datos.
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
insert into categorias (nombre_categoria) values
("Novela"), 
("Ciencia"), 
("Historia"), 
("Tecnología"), 
("Filosofía"), 
("Arte"), 
("Biografía"), 
("Educación"), 
("Matemáticas"), 
("Infantil");

select * from categorias;

insert into autores (nombre_autor, nacionalidad) values
('Gabriel García Márquez', 'Colombiano'),
('Stephen Hawking', 'Británico'),
('Yuval Noah Harari', 'Israelí'),
('Bill Gates', 'Estadounidense'),
('Marco Aurelio', 'Romano'),
('Ernst Gombrich', 'Austríaco'),
('Walter Isaacson', 'Estadounidense'),
('Tony Buzan', 'Británico'),
('Gilbert Strang', 'Estadounidense'),
('Antoine de Saint-Exupéry', 'Francés');

select * from autores;

describe ejemplares; 
select * from libros;

insert into libros (titulo, categoria_id) values
('Cien años de soledad', 1),
('Breves respuestas a las grandes preguntas', 2),
('Sapiens', 3),
('Introducción a la informática', 4),
('Meditaciones', 5),
('Historia del arte', 6),
('La biografía de Steve Jobs', 7),
('Cómo aprender mejor', 8),
('Álgebra lineal para todos', 9),
('El principito', 10);

select * from libros;
select titulo from libros;
describe libros;
insert into libros_autores (libro_id, autor_id) values
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

select * from libros;
select * from libros_autores;

SELECT
    l.libro_id,
    l.titulo,
    c.nombre_categoria AS categoria,
    GROUP_CONCAT(a.nombre_autor SEPARATOR ', ') AS autores,
    l.observaciones
FROM
    libros l
JOIN
    categorias c ON l.categoria_id = c.categoria_id
LEFT JOIN
    libros_autores la ON l.libro_id = la.libro_id
LEFT JOIN
    autores a ON la.autor_id = a.autor_id
GROUP BY
    l.libro_id, l.titulo, c.nombre_categoria, l.observaciones
ORDER BY
    l.titulo;
    
    
insert into ejemplares (libro_id, estado) values
(1,'Disponible'),(1,'Prestado'),
(2,'Disponible'),(2,'Disponible'),
(3,'Disponible'),
(4,'Disponible'),
(5,'Disponible'),
(6,'Disponible'),
(7,'Disponible'),
(8,'Disponible'),
(9,'Disponible'),
(10,'Disponible');

select * from ejemplares;

insert into usuarios (identidad, nombre_completo, fecha_nacimiento, telefono, direccion, email) values
('0801199012345','Luis Martínez','1990-01-08','99990001','Col Centro, Tegucigalpa','lmartinez@mail.com'),
('0802199012346','Ana Gómez','1990-02-09','99990002','Col Kennedy, Tegucigalpa','agomez@mail.com'),
('0803199012347','Carlos Rivera','1990-03-10','99990003','Col Miraflores, Tegucigalpa','crivera@mail.com'),
('0804199012348','María López','1990-04-11','99990004','Col Alameda, Tegucigalpa','mlopez@mail.com'),
('0805199012349','José Fernández','1990-05-12','99990005','Col La Granja, Comayagua','jfernandez@mail.com'),
('0806199012350','Sofía Torres','1990-06-13','99990006','Col 3 de Mayo, SPS','storres@mail.com'),
('0807199012351','Miguel Cruz','1990-07-14','99990007','Col El Carmen, SPS','mcruz@mail.com'),
('0808199012352','Laura Morales','1990-08-15','99990008','Col San Juan, La Ceiba','lmorales@mail.com'),
('0809199012353','Pablo Castillo','1990-09-16','99990009','Col El Sauce, Choluteca','pcastillo@mail.com'),
('0810199012354','Andrea Ramos','1990-10-17','99990010','Col Santa Ana, SPS','aramos@mail.com');

select * from usuarios;

insert into empleados (identidad, nombre_completo, cargo, telefono, email) values
('0801198800001','Pedro Zelaya','Bibliotecario','88880001','pzelaya@mail.com'),
('0802198800002','Rosa Lanza','Auxiliar','88880002','rlanza@mail.com'),
('0803198800003','Samuel Andino','Encargado','88880003','sandino@mail.com'),
('0804198800004','Daniela López','Bibliotecaria','88880004','dlopez@mail.com'),
('0805198800005','Marco Paz','Asistente','88880005','mpaz@mail.com');

select * from empleados;

insert into prestamos (usuario_id, ejemplar_id, empleado_id, fecha_prestamo, fecha_limite, obervaciones) values
(1, 1, 1, '2025-06-01', '2025-06-10', 'Prestamo sin novedades'),
(2, 2, 2, '2025-06-02', '2025-06-11', 'Consulta para aula'),
(3, 3, 1, '2025-06-03', '2025-06-12', 'Prestamo rápido'),
(4, 4, 2, '2025-06-04', '2025-06-13', 'Sin observaciones'),
(5, 5, 1, '2025-06-05', '2025-06-14', 'Primera vez'),
(6, 6, 2, '2025-06-06', '2025-06-15', 'Renovado una vez'),
(7, 7, 1, '2025-06-07', '2025-06-16', 'Prestamo sin novedades'),
(8, 8, 2, '2025-06-08', '2025-06-17', 'Consulta para tarea'),
(9, 9, 1, '2025-06-09', '2025-06-18', 'Sin observaciones'),
(10, 10, 2, '2025-06-10', '2025-06-19', 'Prestamo normal');

select * from prestamos;

insert into devoluciones (prestamo_id, fecha_devolucion, multa, observaciones) values
(46, '2025-06-09', 0.00, 'Devolución en buen estado'),
(47, '2025-06-12', 5.00, 'Con portada arrugada'),
(48, '2025-06-13', 0.00, 'Sin novedades'),
(49, '2025-06-14', 0.00, 'Buen estado'),
(50, '2025-06-16', 10.00, 'Retraso de 2 días'),
(51, '2025-06-15', 0.00, 'Entregado sin bolsa'),
(52, '2025-06-20', 15.00, 'Retraso de 4 días'),
(53, '2025-06-19', 0.00, 'Devolución anticipada'),
(54, '2025-06-20', 0.00, 'Sin novedades'),
(55, '2025-06-22', 0.00, 'Buen estado');

select * from devoluciones;

INSERT INTO usuarios_login (username, password_hash, rol)
VALUES ('admin', '$2a$12$GuiFg4C.760KSfbArtFUYetkLl8XgdSDxPtDrMqvd2QKFIjOy4j2q', 'admin');

-- Insertar el usuario recepcionista con contraseña hasheada
-- La contraseña 'recep123' está hasheada con BCrypt
INSERT INTO usuarios_login (username, password_hash, rol)
VALUES ('recepcionista', '$2a$12$Ht0vQnZ5Wn.BSzQA.5.ZUOcnrJZQNe3PXQnOK9WoqMjqcYFTQ.Ntu', 'recepcionista');

-- Verificar que los usuarios se hayan insertado correctamente
SELECT * FROM usuarios_login;
-- Esto solo son consultas de algunos problemas que hemos tenido (Ignorar)

SELECT prestamo_id FROM prestamos;

-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- Indices
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------

create index idx_libros_titulo on libros(titulo);
create index idx_libros_categoria on libros (categoria_id);
create index idx_libros_autores_autor on libros_autores(autor_id);
create index idx_prestamos_usuario on prestamos (usuario_id); 
create index idx_prestamos_empleado on prestamos (empleado_id);
create index idx_prestamos_fecha on prestamos (fecha_prestamo);
create index idx_devoluciones_prestamo on devoluciones (prestamo_id);
create index idx_ejemplares_libro on ejemplares (libro_id);

CREATE INDEX idx_fecha_devolucion ON devoluciones(fecha_devolucion);
CREATE INDEX idx_estado_ejemplar ON ejemplares(estado);
CREATE INDEX idx_username ON usuarios_login(username);
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------
-- 12 consultas avanzadas. Aparte haremos lo de los explain como dos consultas aparte.
-- -----------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------

-- Lirbros prestados por usuarios

select u.nombre_completo, l.titulo, p.fecha_prestamo
from prestamos p
join usuarios u on p.usuario_id = u.usuario_id
join ejemplares e on p.ejemplar_id = e.ejemplar_id
join libros l on e.libro_id = l.libro_id
order by u.nombre_completo;

-- libros no devueltos despues de la fecha limite 

select p.prestamo_id, u.nombre_completo, l.titulo, p.fecha_limite 
from prestamos p
join usuarios u on p.usuario_id = u.usuario_id
join ejemplares e on p.ejemplar_id = e.ejemplar_id
join libros l on e.libro_id = l.libro_id;

	-- libros más populares (osea, los mas prestados)

	select l.titulo, count(p.prestamo_id) as cantidad_prestamos
	from prestamos p
	join ejemplares e on p.ejemplar_id = e.ejemplar_id
	join libros l on e.libro_id = l.libro_id
	group by l.titulo
	order by cantidad_prestamos desc;

	-- autores con más publicaciones 

	select a.nombre_autor, count(la.libro_id) as cantidad_publicaciones
	from autores a
	join libros_autores la on a.autor_id = la.autor_id
	group by a.nombre_autor
	order by cantidad_publicaciones desc;

	-- prestamos realizados por fecha

	select fecha_prestamo, count(prestamo_id) as total_prestamos
	from prestamos
	group by fecha_prestamo;

	-- total de libros prestados por categoria

	select c.nombre_categoria, count(p.prestamo_id) as total_prestamos
	from prestamos p
	join ejemplares e on p.ejemplar_id = e.ejemplar_id
	join libros l on e.libro_id = l.libro_id
	join categorias c on l.categoria_id = c.categoria_id
	group by c.categoria_id;

	-- libros disponibles en stock

	select l.titulo, count(e.ejemplar_id) as ejemplares_disponibles
	from ejemplares e
	join libros l on e.libro_id = l.libro_id
	where e.estado = 'Disponible'
	group by l.titulo;

	-- usuarios con más prestamos

	select u.nombre_completo, count(p.prestamo_id) as cantidad_prestamos
	from prestamos p
	join usuarios u on p.usuario_id = u.usuario_id
	group by u.nombre_completo
	order by cantidad_prestamos desc;

	-- libros con devoluciones tardias

	select l.titulo, d.fecha_devolucion, p.fecha_limite
	from devoluciones d
	join prestamos p on d.prestamo_id = p.prestamo_id
	join ejemplares e on p.ejemplar_id = e.ejemplar_id
	join libros l on e.libro_id = l.libro_id
	where d.fecha_devolucion > p.fecha_limite;

	-- promedio de multa por devolucion

	select round (avg(multa),2) as promedio_multa
	from devoluciones;

	-- detalles de prestamos y devoluciones por usuario

	select u.nombre_completo, p.fecha_prestamo, d.fecha_devolucion, d.multa
	from prestamos p
	join usuarios u on p.usuario_id = u.usuario_id
	left join devoluciones d on p.prestamo_id = d.prestamo_id
	order by u.nombre_completo;

	-- total de ejemplares de libros

	select l.titulo, count(e.ejemplar_id) as total_ejemplares
	from libros l
	join ejemplares e on l.libro_id = e.libro_id
	group by l.titulo;

	-- -----------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------
	-- consultas utilizando l0s explains
	-- -----------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------

	-- consulta de libros mas populares pero utilizando explain

	explain
	SELECT l.titulo, COUNT(p.prestamo_id) AS cantidad_prestamos
	FROM prestamos p
	JOIN ejemplares e ON p.ejemplar_id = e.ejemplar_id
	JOIN libros l ON e.libro_id = l.libro_id
	GROUP BY l.titulo
	ORDER BY cantidad_prestamos DESC;

	-- consulta de usuarios con mas libros prestados utilizando el explain

	explain
	SELECT u.nombre_completo, COUNT(p.prestamo_id) AS cantidad_prestamos
	FROM prestamos p
	JOIN usuarios u ON p.usuario_id = u.usuario_id
	GROUP BY u.nombre_completo
	ORDER BY cantidad_prestamos DESC;

	-- -----------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------
	-- PROCEDIMIENTOS PARA REGISTRAR PRESTAMOS, MULTAS, DEVOLUCIONES...
	-- -----------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------

	-- Para registrar un prestamo

	DELIMITER //

	create procedure registrar_prestamo(
	in p_usuario_id int,
	in p_empleado_id int,
	in p_ejemplar_id int,
	in p_fecha_prestamo date,
	in p_fecha_limite date,
	in p_observaciones varchar (200)
	)

	begin
		-- aca verificamos si el ejemplar esta disponible
		if (select estado from ejemplares where ejemplar_id = p_ejemplar_id) = 'Disponible' then
			-- aca insertamos el prestamo
			insert into prestamos (usuario_id, empleado_id, ejemplar_id, fecha_prestamo, fecha_limite, observaciones)
			values (p_usuario_id, p_empleado_id, p_ejemplar_id, p_fecha_prestamo, p_fecha_limite, p_observaciones);
			
			-- Una vez hecho actualizamos el estado del ejemplar a prestado
			update ejemplares set estado = 'Prestado' where ejemplar_id = p_ejemplar_id;
			
		else 
			
			-- si el ejemplar no esta disponible mostramos un mensaje
			signal sqlstate '45000'
			set message_text = 'El ejemplar no esta disponible para prestamo';
			
		end if;
	end //

	DELIMITER ;

	-- -----------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------

	-- Procedimiento para registrar una devolucion y si necesitamos cobrar una multa.
		
	DELIMITER //

	create procedure registrar_devolucion(
	in p_prestamo_id int,
	in p_fecha_devolucion date,
	in p_observaciones varchar (200)
	)

	begin 
		declare v_fecha_limite date;
		declare v_ejemplar_id int;
		declare v_multa decimal(8,2) default 0.00;
		
		-- obtenemos la fecha limite y el ejemplar del prestamo
		select fecha_limite, ejemplar_id into v_fecha_limite, v_ejemplar_id
		from prestamos where prestamo_id = p_prestamo_id;
		
		-- aca calcularemos la multa si hay retraso (son 5.00 lempiras por dia)
		if p_fecha_devolucion > v_fecha_limite then
		   set v_multa = datediff(p_fecha_devolucion, v_fecha_limite) * 5.00;
		end if;
		   
		-- registramos la devolucion
		
		insert into devoluciones (prestamo_id, fecha_devolucion, v_multa, p_observaciones)
		values (p_prestamo_id, p_fecha_devolucion, v_multa, p_observaciones);
		
		-- cambiamos el estado del ejemplar a disponible.
		update ejemplares set estado = 'Disponible' where ejemplar_id = v_ejemplar_id;
	end //

	DELIMITER ;  

	-- -----------------------------------------------------------------------------------------------
	-- -----------------------------------------------------------------------------------------------

	-- Consultas extras

	-- ejecutamos el procedimiento de prestamo
	call registrar_prestamo(3, 2, 5, '2025-06-15', '2025-06-22', 'Préstamo para proyecto final');

	-- para ver el nuevo prestamo insertado
	select * from prestamos order by prestamo_id desc limit 1;

	-- ver si el ejemplar cambio a 'Prestado'
	select * from ejemplares where ejemplar_id = 5;

	-- ver todos los prestamos por este usuario (osea, el usuario que elegimos)
	select * from prestamos WHERE usuario_id = 3;

	-----------------------------------------------------------------------------
	 
	-----------------------------------------------------------------------------

	call registrar_devolucion(56, '2025-06-20', 'Devuelto en buen estado');
	select * from devoluciones order by devolucion_id desc limit 1;
	select * from ejemplares where ejemplar_id = 5;


INSERT INTO auditoria_acciones (usuario_login_id, accion, entidad_id, fecha) VALUES
(3, 'LOGIN', 0, '2025-08-04 08:00:00'),
(3, 'INSERT', 201, '2025-08-04 08:10:00'),
(3, 'UPDATE', 202, '2025-08-04 09:15:00'),
(3, 'LOGOUT', 0, '2025-08-04 09:30:00');
