CREATE DATABASE COPPEL
GO

USE COPPEL
GO

CREATE TABLE puestos(
    noPuesto INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    puesto VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150) NOT NULL
)
GO

CREATE TABLE centroTrabajo(
    noCentro VARCHAR(10) NOT NULL PRIMARY KEY,
    nombreCentro VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL
)
GO

CREATE TABLE Empleado(
    noEmpleado INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidoP VARCHAR(50) NOT NULL,
    apellidoM VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    RFC VARCHAR(13) NOT NULL,
    centroTrabajo VARCHAR(10) NOT NULL,
    puesto INT NOT NULL,
    descripcionPuesto VARCHAR(150) NOT NULL,
    directivo BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Empleado_CentroTrabajo
        FOREIGN KEY (centroTrabajo)
        REFERENCES centroTrabajo(noCentro),

    CONSTRAINT FK_Empleado_Puesto
        FOREIGN KEY (puesto)
        REFERENCES puestos(noPuesto)
)
GO

CREATE TABLE Directivos(
    noEmpleado INT NOT NULL PRIMARY KEY,
    numeroCentroSupervisa VARCHAR(10) NOT NULL,
    prestaciones BIT NOT NULL,

    CONSTRAINT FK_Directivos_Empleado
        FOREIGN KEY (noEmpleado)
        REFERENCES Empleado(noEmpleado),

    CONSTRAINT FK_Directivos_CentroTrabajo
        FOREIGN KEY (numeroCentroSupervisa)
        REFERENCES centroTrabajo(noCentro)
)
GO

INSERT INTO puestos (puesto, descripcion)
VALUES
('Asesor de Ventas', 'Encargado de orientar a los clientes en sus compras'),
('Jefe de Piso', 'Responsable de supervisar las actividades en tienda'),
('Encargado de Almacen', 'Administra entradas y salidas de mercancia'),
('Auxiliar Administrativo', 'Realiza actividades de oficina y control de documentos'),
('Cajero Principal', 'Coordina operaciones de cobro y arqueo de caja')
GO

INSERT INTO centroTrabajo (noCentro, nombreCentro, ciudad)
VALUES
('000201', 'Tiendas Angel Flores Ropa', 'Culiacan'),
('000202', 'Tiendas Angel Flores Muebles', 'Culiacan'),
('000203', 'Tiendas Angel Flores Cajas', 'Culiacan'),
('049001', 'La Primavera Ropa', 'Culiacan'),
('049002', 'La Primavera Muebles', 'Culiacan'),
('049003', 'La Primavera Cajas', 'Culiacan')
GO

INSERT INTO Empleado
(nombre, apellidoP, apellidoM, fechaNacimiento, RFC, centroTrabajo, puesto, descripcionPuesto, directivo)
VALUES
('Luis', 'Ramirez', 'Torres', '1990-04-12', 'RATL900412ABC', '000201', 1, 'Encargado de orientar a los clientes en sus compras', 0),
('Fernanda', 'Morales', 'Diaz', '1987-09-25', 'MODF870925XYZ', '000202', 2, 'Responsable de supervisar las actividades en tienda', 1),
('Ricardo', 'Sanchez', 'Lopez', '1993-02-18', 'SALR930218QWE', '000203', 3, 'Administra entradas y salidas de mercancia', 0),
('Patricia', 'Navarro', 'Cruz', '1985-11-30', 'NACP851130RTY', '049002', 5, 'Coordina operaciones de cobro y arqueo de caja', 1),
('Miguel', 'Ortega', 'Jimenez', '1998-06-07', 'OEJM980607UIO', '049003', 4, 'Realiza actividades de oficina y control de documentos', 0)
GO

INSERT INTO Directivos
(noEmpleado, numeroCentroSupervisa, prestaciones)
VALUES
(2, '000202', 1),
(4, '049002', 1)
GO

/*====================================================
  CONSULTA GENERAL DEL REPORTE
====================================================*/

SELECT
    E.noEmpleado AS [Numero de Empleado],
    E.nombre + ' ' + E.apellidoP + ' ' + E.apellidoM AS [Nombre Completo],
    CONVERT(VARCHAR, E.fechaNacimiento, 103) AS [Fecha de Nacimiento],
    E.RFC AS [RFC],
    C.nombreCentro AS [Nombre de Centro],
    E.descripcionPuesto AS [Descripcion del Puesto],
    CASE
        WHEN E.directivo = 1 THEN 'Si'
        ELSE 'No'
    END AS [Es Directivo]
FROM Empleado E
INNER JOIN centroTrabajo C
    ON E.centroTrabajo = C.noCentro
INNER JOIN puestos P
    ON E.puesto = P.noPuesto
ORDER BY E.noEmpleado
GO