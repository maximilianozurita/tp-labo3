USE RESTO;
go
Select * FROM DetalleMesas;
go
Select * FROM Ventas;
go
Select * FROM MesasAsignadas;
go
Select * FROM Facturas;
go
Select * FROM ItemsDelMenu;
go
Select * FROM Usuarios;
go
Select * FROM Mesas;
go
Select * FROM TipoUsuarios;
go
-- Triggers
SELECT 
    name AS TriggerName,
    OBJECT_SCHEMA_NAME(parent_id) AS TableSchema,
    OBJECT_NAME(parent_id) AS TableName,
    create_date,
    modify_date,
    is_instead_of_trigger,
    is_disabled
FROM sys.triggers
WHERE parent_class_desc = 'OBJECT_OR_COLUMN'
ORDER BY TableName, TriggerName;
go
-- Vistas
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
ORDER BY TABLE_SCHEMA, TABLE_NAME;
go
SELECT name AS ProcedureName FROM sys.procedures;
go
