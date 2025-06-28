create database RESTO;
GO
USE RESTO;
go
CREATE TABLE TipoUsuarios (
	IdTipoUsuario int PRIMARY KEY NOT NULL identity(1,1),
	Tipo int NOT null
);
go
CREATE TABLE Usuarios (
	IdUsuario int PRIMARY KEY NOT NULL identity(1,1),
	Nombre varchar(50) not null,
	Apellido varchar(50) not null,
	Email varchar(50) NOT NULL unique,
	Contrasenia varchar(50) NOT NULL,
	IdTipoUsuario int FOREIGN KEY REFERENCES TipoUsuarios(IdTipoUsuario)
);
go
CREATE table Mesas (
	IdMesa int primary key NOT NULL identity(1,1),
	NumeroMesa int unique
);
go
create table Facturas (
	IdFactura int primary key not null identity(1,1),
	IdMesa int foreign key references Mesas(IdMesa),
	IdUsuario int foreign key references Usuarios (IdUsuario),
	Estado varchar(50) not null default('ABIERTA'),
	fecha date
)
go
CREATE TABLE Ventas (
    IdVenta INT PRIMARY KEY IDENTITY(1,1),
    IdFactura INT NOT NULL FOREIGN KEY REFERENCES Facturas(IdFactura),
    IdMesa INT NOT NULL FOREIGN KEY REFERENCES Mesas(IdMesa),
    FechaVenta DATETIME NOT NULL,
    SumaTotal MONEY NOT NULL
);
go
create table ItemsDelMenu (
	IdPlato int primary key NOT NULL identity(1,1),	
	Nombre varchar(50) not null unique,
	Precio money not null,
	stock int not null,
	Imagen varchar(500),
	estado bit not null,
	eliminado BIT NOT NULL DEFAULT 0
);
go
create table DetalleMesas (
	IdDetalle int primary key not null identity(1,1),
	IdPlato int foreign key references ItemsDelMenu(IdPlato),
	IdFactura int foreign key references Facturas(IdFactura),
	Precio money
);
go
create table MesasAsignadas(
	IdMesa int foreign key references Mesas(IdMesa),
	IdUsuario int foreign key references Usuarios (IdUsuario),
	Fecha date,
	primary key(IdMesa,Fecha)
);
go