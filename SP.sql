create procedure sp_IniciarSesion(
	@Email varchar(250), 
	@Contraseña varchar(50)
)as
begin
	select IdUsuario, Nombre, Apellido, Email, Contrasenia, IdTipoUsuario from Usuario WHERE Email = @Email and  Contrasenia = @Contraseña
end
go

create procedure sp_RegistarUsuariio(
	@Email varchar(250),
	@contraseña varchar(50),
	@Nombre varchar(50),
	@Apellido varchar(50)
)AS 
BEGIN 
	insert into Usuario (Email, Contrasenia, IdTipoUsuario,Nombre,Apellido)
	values (@Email,@contraseña,2,@Nombre,@Apellido)
END
go

create or alter procedure sp_BuscarUsuario(
	@Email varchar(250)
)AS 
BEGIN 
	select u.IdUsuario from Usuario u where u.Email = @Email
END
GO

create or alter procedure sp_ListarMesa(
	@IdUsuario int
)as
begin
	SELECT m.IdMesa as IdMesa , m.NumeroMesa, u.Nombre as NumeroMesa from Mesas m
	inner join MesasAsignadas ma on ma.IdMesa = m.IdMesa
	inner join Usuario u on u.IdUsuario = ma.IdUsuario
	where u.IdUsuario = @IdUsuario and ma.Fecha = CAST(GETDATE() AS DATE)
end
GO 

create or alter procedure sp_ListarMesasAsignadas
as
begin
	SELECT  m.NumeroMesa as NumeroMesa,  ma.IdUsuario as IdUsuario, u.Nombre as Nombre, ma.Fecha as fecha, m.IdMesa as IdMesa from Mesas m 
	left join (select * from MesasAsignadas ma2 where ma2.Fecha = CAST(GETDATE() AS DATE)) ma on m.IdMesa  = ma.IdMesa 
	left join Usuario u on u.IdUsuario = ma.IdUsuario
	select * from MesasAsignadas ma
end
GO 

create or alter procedure sp_listarUsuario
as
begin
	SELECT IdUsuario, Nombre from Usuario WHERE IdTipoUsuario = 2
end
go


create or alter procedure sp_AsignarMesero(
	@NumeroMesa int,
	@IdMesero int
)as
begin
	declare @IdMesa int;
	select @IdMesa = IdMesa from mesas where NumeroMesa = @NumeroMesa
	IF NOT EXISTS (SELECT * FROM MesasAsignadas WHERE IdMesa = @IdMesa AND fecha = CAST(GETDATE() AS DATE))
	BEGIN
	    INSERT INTO MesasAsignadas (IdMesa, IdUsuario, Fecha)
	    VALUES (@IdMesa, @IdMesero, GETDATE())
	END
	ELSE
	BEGIN
	    UPDATE MesasAsignadas
	    SET IdUsuario = @IdMesero
	    WHERE IdMesa = @IdMesa
	END
end
GO 


create or alter procedure sp_ExisteMesaAsignada(
	@IdMesa int
)as
begin
	select IdMesa from MesasAsignadas ma where Fecha = CAST(GETDATE() AS DATE) and IdMesa = @IdMesa
end
go

create or alter procedure sp_listaMenu
AS
BEGIN 
	select IdPlato, Nombre, Precio, Stock, Imagen, Estado from Menu where eliminado = 0
END
go

create or alter procedure sp_CantidadMesasAsignadas
AS 
BEGIN 
	select count(IdMesa) as MesasSinAsignar from MesasAsignadas ma where Fecha = CAST(GETDATE() AS DATE)
END
GO 

create or alter procedure sp_ListarDetalle(
	@IdMesa int,
	@IdFactura int
)AS 
BEGIN 
	select dm.IdDetalle as IdDetalle, m.Nombre as Nombre, m.Precio as Precio, f.IdMesa as IdMesa from DetalleMesa dm
	inner join factura f on f.IdFactura = dm.IdFactura 
	inner join Menu m on m.IdPlato = dm.IdPlato 
	where f.IdMesa = @IdMesa and dm.IdFactura = @IdFactura
END
go

create or alter procedure sp_AsignarPlato(
	@IdPlato int,
	@IdMesa int
)as
begin
	DECLARE @IdFactura int
	declare @Stock int
	declare @Precio money
	
	select @IdFactura = IdFactura from factura f where @IdMesa = IdMesa and f.Estado = 'ABIERTA'
	
	select @Precio = m.Precio from Menu m 
	WHERE m.IdPlato = @IdPlato
	
	insert into DetalleMesa (IdPlato,IdFactura,Precio) values (@IdPlato,@IdFactura,@Precio)
	
	update Menu
	set stock = stock - 1
	where IdPlato = @IdPlato
	select @Stock = stock from menu
	where IdPlato = @IdPlato
	if @Stock <= 0
	begin
		update Menu
		set Estado = 0, stock = 0
		where IdPlato = @IdPlato
	end
end
go
	
create or alter procedure sp_BuscarFactura(
	@IdMesa int
)as
begin
	select IdFactura FROM factura f where f.Estado = 'ABIERTA' and f.IdMesa  = @IdMesa
end
go

create or alter procedure sp_AgregarFactura(
	@IdMesa int,
	@IdUsuario int
)AS 
BEGIN 
	insert into factura (IdMesa,IdUsuario,fecha)
	values(@IdMesa,@IdUsuario,getdate())
END
go

CREATE or alter PROCEDURE sp_CerrarFactura(
	@IdMesa int
)AS 
BEGIN 
	declare @IdUsuario int;
	select @IdUsuario = IdUsuario from MesasAsignadas where @IdMesa = IdMesa
	UPDATE factura 
	set Estado = 'CERRADO'
	where IdMesa = @IdMesa
END
go


create or alter procedure sp_AgregarInsumo(
	@Precio int,
	@Stock int,
	@Nombre varchar(150),
	@Imagen varchar(250)
)as
begin
	INSERT INTO Menu (Nombre, Precio, stock,imagen,estado)
	VALUES (@Nombre,@Precio,@Stock,@Imagen,1)
	select * from Menu
end
go

create or alter procedure sp_eliminarInsumo(
	@IdInsumo int
)as
begin
	update Menu
	set eliminado = 1
	where IdPlato = @IdInsumo
end
go

create or alter procedure sp_CargarInsum(
	@IdInsumo int
)as
begin
	select Nombre, Precio, Stock, Imagen, Estado from Menu
	where IdPlato = @IdInsumo
end
go

create or alter procedure sp_ModificarInsumo(
	@Precio money,
	@IdInsumo int,
	@Estado bit,
	@Stock int
)as
begin
	update Menu
	set Precio = @Precio, Stock = @Stock, Estado = @Estado
	where IdPlato = @IdInsumo
end
go

create or alter procedure sp_ListarTotalRecaudado
as
begin
	select isnull(sum(precio),0) as total from detalleMesa dm
	inner join factura f on f.IdFactura = dm.IdFactura
	where f.Fecha  = CAST(GETDATE() AS DATE) and f.Estado = 'CERRADO';
end
go

create or alter procedure sp_DetalleMoso
as
begin
	SELECT u.nombre +' '+u.Apellido as Nombre , sum(dm.precio) as Total, count(distinct(f.IdFactura)) as cantidadAtendida from factura f
	inner join DetalleMesa dm on f.IdFactura = dm.IdFactura
	inner join Usuario u on f.IdUsuario = u.IdUsuario
	where f.fecha = CAST(GETDATE() AS DATE)
	group by u.Nombre, u.Apellido;
end
go

create or alter procedure sp_AgregarMesas(
	@NumeroMesa int
)as
begin
	INSERT INTO Mesas (NumeroMesa)
	values (@NumeroMesa);
end
go

create or alter procedure sp_TotalMensual
AS
BEGIN 
	select isnull(sum(precio),0) as total from detalleMesa dm
	inner join factura f on f.IdFactura = dm.IdFactura
	where MONTH(f.Fecha) = MONTH(GETDATE()) AND YEAR(f.Fecha) = YEAR(GETDATE()) AND f.Estado = 'CERRADO';
END
go

create or alter procedure sp_MesasCerradasMensual
AS 
BEGIN 
	select count((f.IdFactura)) as cantidadAtendida from factura f
	where MONTH(f.Fecha) = MONTH(GETDATE()) AND YEAR(f.Fecha) = YEAR(GETDATE()) AND f.Estado = 'CERRADO';
END
go

create or alter procedure sp_MesasCerradas
AS 
BEGIN 
	select count((f.IdFactura)) as cantidadAtendida from factura f
	where f.fecha = CAST(GETDATE() AS DATE) AND f.Estado = 'CERRADO';
END