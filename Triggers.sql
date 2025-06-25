
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