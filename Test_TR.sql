use RESTO
go
-- Verificar valores
SELECT * FROM Ventas WHERE IdFactura = 1;
go
SELECT * FROM DetalleMesas WHERE IdFactura = 1;
go
SELECT * FROM ItemsDelMenu WHERE IdPlato = 1;
go
-- ejecutar TR_ValidarStockAlVender
INSERT INTO DetalleMesas (IdPlato, IdFactura, Precio)
VALUES (1, 1, 1500);
go
-- ejecutar trg_InsertVentaOnFacturaCerrada
UPDATE Facturas
SET Estado = 'CERRADO'
WHERE IdFactura = 1;
go

-- Verificar valores
SELECT * FROM Ventas WHERE IdFactura = 1;
go
SELECT * FROM DetalleMesas WHERE IdFactura = 1;
go
SELECT * FROM ItemsDelMenu WHERE IdPlato = 1;
go