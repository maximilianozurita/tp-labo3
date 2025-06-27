
CREATE VIEW vw_MesasAsignadasHoy AS
SELECT 
    m.IdMesa,
    m.NumeroMesa,
    u.Nombre + ' ' + u.Apellido AS NombreMozo,
    f.IdFactura,
    f.Estado AS EstadoFactura
FROM 
    MesasAsignadas ma
    JOIN Mesas m ON ma.IdMesa = m.IdMesa
    LEFT JOIN Usuario u ON ma.IdUsuario = u.IdUsuario
    LEFT JOIN factura f ON f.IdMesa = m.IdMesa AND f.Estado = 'ABIERTA'
WHERE 
    ma.Fecha = CAST(GETDATE() AS DATE);
go
CREATE VIEW vw_FacturacionDiariaDetallada AS
SELECT 
    f.IdFactura,
    f.IdMesa,
    m.NumeroMesa,
    u.Nombre + ' ' + u.Apellido AS NombreMozo,
    me.Nombre AS Plato,
    dm.Precio,
    f.Fecha
FROM 
    factura f
    JOIN Usuario u ON f.IdUsuario = u.IdUsuario
    JOIN DetalleMesa dm ON f.IdFactura = dm.IdFactura
    JOIN Menu me ON dm.IdPlato = me.IdPlato
    JOIN Mesas m ON f.IdMesa = m.IdMesa
WHERE 
    f.Fecha = CAST(GETDATE() AS DATE) AND f.Estado = 'CERRADO';
go
CREATE VIEW VW_MesasConMasFacturacion AS
SELECT 
    m.IdMesa,
    COUNT(v.ID) AS CantidadVentas,
    SUM(v.Suma_total) AS TotalFacturado
FROM Ventas v
JOIN Mesa m ON v.IdMesa = m.IdMesa
GROUP BY m.IdMesa
ORDER BY TotalFacturado DESC;
go
CREATE VIEW VW_PedidosPorDiaYHora AS
SELECT 
    CONVERT(date, v.Fecha_venta) AS Fecha,
    DATEPART(HOUR, v.Fecha_venta) AS Hora,
    COUNT(*) AS CantidadPedidos
FROM Ventas v
GROUP BY CONVERT(date, v.Fecha_venta), DATEPART(HOUR, v.Fecha_venta)
ORDER BY Fecha, Hora;
go
