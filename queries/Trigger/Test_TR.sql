use RESTO
go
-- Verificar valores
SELECT * FROM Ventas WHERE IdFactura = 1;
go
SELECT * FROM Facturas;
go
SELECT * FROM ItemsDelMenu WHERE IdPlato = 1;
go
-- ejecutar TR_PrevenirFacturasDuplicadasAbiertas
INSERT INTO Facturas (IdMesa, IdUsuario, Estado, Fecha)
VALUES (1, 100, 'ABIERTA', GETDATE());
go
-- ejecutar trg_InsertVentaOnFacturaCerrada
UPDATE Facturas
SET Estado = 'CERRADO'
WHERE IdFactura = 1;
go

-- Verificar valores
SELECT * FROM Ventas WHERE IdFactura = 1;
go
SELECT * FROM Facturas;
go
SELECT * FROM ItemsDelMenu WHERE IdPlato = 1;
go