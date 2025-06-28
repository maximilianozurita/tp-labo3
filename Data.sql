USE RESTO;
go
INSERT INTO TipoUsuarios (Tipo) VALUES (1), (2); 
go
INSERT INTO Usuarios (Nombre, Apellido, Email, Contrasenia, IdTipoUsuario) VALUES
('Juan', 'Pérez', 'juan@example.com', '1234', 1),
('Ana', 'Gómez', 'ana@example.com', 'abcd', 2);
go
INSERT INTO Mesas (NumeroMesa) VALUES (1), (2), (3);
go
INSERT INTO Facturas (IdMesa, IdUsuario, Estado, Fecha) VALUES
(1, 1, 'ABIERTA', '2025-06-28'),
(2, 2, 'CERRADA', '2025-06-27');
go
INSERT INTO ItemsDelMenu (Nombre, Precio, Stock, Imagen, Estado, Eliminado) VALUES
('Hamburguesa', 1500, 10, 'hamburguesa.jpg', 1, 0),
('Cerveza', 800, 25, 'cerveza.jpg', 1, 0),
('Ensalada', 1200, 5, 'ensalada.jpg', 1, 0);
go
INSERT INTO DetalleMesas (IdPlato, IdFactura, Precio) VALUES
(1, 1, 1500),
(2, 1, 800),
(3, 2, 1200);
go
INSERT INTO Ventas (IdFactura, IdMesa, FechaVenta, SumaTotal) VALUES
(1, 1, '2025-06-28 13:45:00', 2300),
(2, 2, '2025-06-27 20:15:00', 1200);
go
INSERT INTO MesasAsignadas (IdMesa, IdUsuario, Fecha) VALUES
(1, 2, '2025-06-28'),
(2, 2, '2025-06-27');
go