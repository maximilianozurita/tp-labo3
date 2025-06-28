use RESTO;
GO
EXEC sp_AsignarMesero @NumeroMesa = 3, @IdMesero = 1;
GO
SELECT * FROM DetalleMesas WHERE IdFactura = 1;
go
SELECT Stock, Estado FROM ItemsDelMenu WHERE IdPlato = 1;
GO

EXEC sp_AsignarPlato @IdPlato = 1, @IdMesa = 1;
go
SELECT * FROM Ventas WHERE IdFactura = 1;
go