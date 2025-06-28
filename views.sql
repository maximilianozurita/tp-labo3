
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
    LEFT JOIN Usuarios u ON ma.IdUsuario = u.IdUsuario
    LEFT JOIN Facturas f ON f.IdMesa = m.IdMesa AND f.Estado = 'ABIERTA'
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
    Facturas f
    JOIN Usuarios u ON f.IdUsuario = u.IdUsuario
    JOIN DetalleMesas dm ON f.IdFactura = dm.IdFactura
    JOIN ItemsDelMenu me ON dm.IdPlato = me.IdPlato
    JOIN Mesas m ON f.IdMesa = m.IdMesa
WHERE 
    f.Fecha = CAST(GETDATE() AS DATE) AND f.Estado = 'CERRADO';
go
CREATE VIEW VW_MesasConMasFacturacion AS
SELECT 
    m.IdMesa,
    COUNT(v.ID) AS CantidadVentas,
    SUM(v.SumaTotal) AS TotalFacturado
FROM Ventas v
JOIN Mesa m ON v.IdMesa = m.IdMesa
GROUP BY m.IdMesa
ORDER BY TotalFacturado DESC;
go
CREATE VIEW VW_PedidosPorDiaYHora AS
SELECT 
    CONVERT(date, v.FechaVenta) AS Fecha,
    DATEPART(HOUR, v.FechaVenta) AS Hora,
    COUNT(*) AS CantidadPedidos
FROM Ventas v
GROUP BY CONVERT(date, v.FechaVenta), DATEPART(HOUR, v.FechaVenta)
ORDER BY Fecha, Hora;
go
