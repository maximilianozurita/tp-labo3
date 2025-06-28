USE RESTO;
go
DELETE FROM DetalleMesas;
go
DELETE FROM Ventas;
go
DELETE FROM MesasAsignadas;
go
DELETE FROM Facturas;
go
DELETE FROM ItemsDelMenu;
go
DELETE FROM Usuarios;
go
DELETE FROM Mesas;
go
DELETE FROM TipoUsuarios;
go
use eCommerce;
go
-- Eliminar triggers
DROP TRIGGER TR_ValidarStockAlVender;
go
DROP TRIGGER trg_InsertVentaOnFacturaCerrada;
go
-- Eliminar vistas
DROP VIEW vw_MesasAsignadasHoy;
go
DROP VIEW vw_FacturacionDiariaDetallada;
go
DROP VIEW VW_MesasConMasFacturacion;
go
DROP VIEW VW_PedidosPorDiaYHora;
go
DROP PROCEDURE sp_AsignarMesero;
GO
DROP PROCEDURE sp_AsignarPlato;
go
DROP DATABASE RESTO;
go
