use RESTO;
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

create or alter procedure sp_AsignarPlato(
	@IdPlato int,
	@IdMesa int
)as
begin
	DECLARE @IdFactura int
	declare @Stock int
	declare @Precio money
	
	select @IdFactura = IdFactura from Facturas f where @IdMesa = IdMesa and f.Estado = 'ABIERTA'
	
	select @Precio = m.Precio from ItemsDelMenu m 
	WHERE m.IdPlato = @IdPlato
	
	insert into DetalleMesas (IdPlato,IdFactura,Precio) values (@IdPlato,@IdFactura,@Precio)
	
	update ItemsDelMenu
	set stock = stock - 1
	where IdPlato = @IdPlato
	select @Stock = stock from ItemsDelMenu
	where IdPlato = @IdPlato
	if @Stock <= 0
	begin
		update ItemsDelMenu
		set Estado = 0, stock = 0
		where IdPlato = @IdPlato
	end
end
go
