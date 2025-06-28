USE RESTO;
go
CREATE OR ALTER TRIGGER TR_PrevenirFacturasDuplicadasAbiertas
ON Facturas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Facturas f ON i.IdMesa = f.IdMesa
        WHERE i.Estado = 'ABIERTA' AND f.Estado = 'ABIERTA'
    )
    BEGIN
        RAISERROR('Ya existe una factura ABIERTA para esta mesa.', 16, 1);
        RETURN;
    END

    INSERT INTO Facturas (IdMesa, IdUsuario, Estado, Fecha)
    SELECT IdMesa, IdUsuario, Estado, Fecha
    FROM inserted;
END;
GO


CREATE TRIGGER trg_InsertVentaOnFacturaCerrada
ON Facturas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Ventas (IdFactura, IdMesa, FechaVenta, SumaTotal)
    SELECT 
        f.IdFactura,
        f.IdMesa,
        f.Fecha,
        ISNULL(SUM(dm.Precio), 0)
    FROM 
        inserted i
        JOIN Facturas f ON i.IdFactura = f.IdFactura
        LEFT JOIN DetalleMesas dm ON dm.IdFactura = f.IdFactura
        JOIN deleted d ON d.IdFactura = i.IdFactura
    WHERE 
        i.Estado = 'CERRADO' AND d.Estado <> 'CERRADO'
        AND NOT EXISTS (
            SELECT 1 FROM Ventas v WHERE v.IdFactura = i.IdFactura
        )
    GROUP BY f.IdFactura, f.IdMesa, f.Fecha;
END;
GO
