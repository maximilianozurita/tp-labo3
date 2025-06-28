USE RESTO;
go
CREATE TRIGGER TR_ValidarStockAlVender
ON DetalleMesas
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN ItemsDelMenu p ON i.IdPlato = p.IdPlato
        WHERE i.Precio > 0 AND p.Stock < 1
    )
    BEGIN
        RAISERROR('No hay stock suficiente para uno o más productos.', 16, 1);
        RETURN;
    END;

    INSERT INTO DetalleMesas (IdPlato, IdFactura, Precio)
    SELECT IdPlato, IdFactura, Precio
    FROM INSERTED;

    UPDATE p
    SET p.Stock = p.Stock - 1
    FROM ItemsDelMenu p
    JOIN INSERTED i ON p.IdPlato = i.IdPlato;
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
