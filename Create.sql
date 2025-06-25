create database RESTO
GO
USE RESTO
go

CREATE TABLE TipoUsuario(
	IdTipoUsuario int PRIMARY KEY NOT NULL identity(1,1),
	Tipo int NOT null
);
go

CREATE TABLE Usuario(
	IdUsuario int PRIMARY KEY NOT NULL identity(1,1),
	Nombre varchar(50) not null,
	Apellido varchar(50) not null,
	Email varchar(50) NOT NULL unique,
	Contrasenia varchar(50) NOT NULL,
	IdTipoUsuario int FOREIGN KEY REFERENCES TipoUsuario(IdTipoUsuario)
);
go

CREATE table Mesas(
	IdMesa int primary key NOT NULL identity(1,1),
	NumeroMesa int unique
);
go

create table Menu(
	IdPlato int primary key NOT NULL identity(1,1),	
	Nombre varchar(50) not null unique,
	Precio money not null,
	stock int not null,
	Imagen varchar(500),
	estado bit not null,
	eliminado BIT NOT NULL DEFAULT 0
);
go

create table MesasAsignadas(
	IdMesa int foreign key references Mesas(IdMesa),
	IdUsuario int foreign key references Usuario(IdUsuario),
	Fecha date,
	primary key(IdMesa,Fecha)
)
go

create table factura(
	IdFactura int primary key not null identity(1,1),
	IdMesa int foreign key references Mesas(IdMesa),
	IdUsuario int foreign key references Usuario(IdUsuario),
	Estado varchar(50) not null default('ABIERTA'),
	fecha date
)
go

create table DetalleMesa(
	IdDetalle int primary key not null identity(1,1),
	IdPlato int foreign key references Menu(IdPlato),
	IdFactura int foreign key references factura(IdFactura),
	Precio money
)
go