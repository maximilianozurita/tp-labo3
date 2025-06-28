CREATE TRIGGER TR_ValidarStockAlVender
ON VentaProducto
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Producto p ON i.IdProducto = p.IdProducto
        WHERE i.Cantidad > p.Stock
    )
    BEGIN
        RAISERROR('No hay stock suficiente para uno o más productos.', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        -- Insertar venta y actualizar stock
        INSERT INTO VentaProducto (IdVenta, IdProducto, Cantidad)
        SELECT IdVenta, IdProducto, Cantidad
        FROM INSERTED;

        UPDATE p
        SET p.Stock = p.Stock - i.Cantidad
        FROM Producto p
        JOIN INSERTED i ON p.IdProducto = i.IdProducto;
    END
END;
go
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
    WHERE 
        i.Estado = 'CERRADO' AND 
        EXISTS (
            SELECT 1 FROM deleted d 
            WHERE d.IdFactura = i.IdFactura AND d.Estado <> 'CERRADO'
        )
    GROUP BY f.IdFactura, f.IdMesa, f.Fecha;
END;
GO
