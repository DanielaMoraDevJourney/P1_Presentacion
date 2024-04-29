
-----------------------------------------------------------------


CREATE TABLE Roles(
    RolId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Nombre VARCHAR(50)
)
 
INSERT INTO Roles VALUES ('Administrador')
INSERT INTO Roles VALUES ('Usuario')

GO

CREATE PROCEDURE ListarRoles
AS BEGIN
    SELECT * FROM Roles
END

GO

--------------------------------------------------------------------
CREATE TABLE Usuarios(
    UsuarioId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Correo VARCHAR(100) UNIQUE,
    Contrasenia VARCHAR(max),
    RolId INT,
    NombreUsuario VARCHAR(50) UNIQUE,
    Estado BIT,
    Token VARCHAR(max),
    FechaExpiracion DATETIME
)
GO

CREATE PROCEDURE ObtenerUsuarioPorId
@UsuarioId INT
AS BEGIN
SELECT * FROM Usuarios WHERE UsuarioId=@UsuarioId
END
GO

CREATE PROCEDURE RegistrarUsuario
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Correo VARCHAR(100) ,
    @Contrasenia VARCHAR(max),
    @RolId INT=2,
    @NombreUsuario VARCHAR(50),
    @Estado BIT=0,
    @Token VARCHAR(max),
    @FechaExpiracion DATETIME
AS 
BEGIN
    INSERT INTO Usuarios 
    VALUES (@Nombre, @Apellido, @Correo, @Contrasenia, @RolId, @NombreUsuario, @Token, @FechaExpiracion )
END
GO

CREATE PROCEDURE ActivarCuenta
@Token VARCHAR(MAX),
@Fecha DATETIME
AS BEGIN
 
DECLARE @Correo VARCHAR(100)
DECLARE @FechaExpiracion DATETIME
 
SET @Correo = (SELECT Correo FROM Usuarios WHERE Token=@Token)
SET @FechaExpiracion = (SELECT FechaExpiracion FROM Usuarios WHERE Token=@Token)
 
IF @FechaExpiracion<@Fecha
BEGIN
UPDATE Usuarios SET Estado=1 WHERE Token=@Token
UPDATE Usuarios SET Token=NULL WHERE Correo=@Correo
SELECT 1 AS Resultado
    END
    ELSE
    BEGIN
        SELECT 0 AS Resultado
    END
END
GO

ALTER PROCEDURE ValidarUsuario
@Correo VARCHAR(100)
AS BEGIN
SELECT * FROM Usuarios WHERE Correo=@Correo
END
GO
 
CREATE PROCEDURE ActualizarToken
@Correo VARCHAR(100),
@Fecha DATETIME,
@Token VARCHAR(MAX)
AS BEGIN
UPDATE Usuarios SET Token=@Token, FechaExpiracion=@Fecha WHERE Correo=@Correo
END
GO

CREATE PROCEDURE ActualizarPerfil
(@UsuarioId INT,
@Nombre VARCHAR(50),
@Apellido VARCHAR(50),
@Correo VARCHAR(100))
AS BEGIN
UPDATE Usuarios SET Nombre=@Nombre, Apellido=@Apellido, Correo=@Correo WHERE UsuarioId=@UsuarioId
END
GO

CREATE PROCEDURE ActualizarUsuario
@UsuarioId INT,
@Nombre VARCHAR(50),
@Apellido VARCHAR(50),
@RolId INT,
@Estado BIT
AS BEGIN
UPDATE Usuarios SET Nombre=@Nombre, Apellido=@Apellido, RolId=@RolId, Estado=@Estado WHERE UsuarioId = @UsuarioId
END
GO

CREATE PROCEDURE EliminarUsuario
@UsuarioId INT
AS BEGIN
DELETE FROM Usuarios WHERE UsuarioId=@UsuarioId
END
GO

--------------------------------------------------------------------

CREATE TABLE Post(
    PostId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Titulo VARCHAR(500),
    Contenido VARCHAR(MAX),
    Categoria VARCHAR(100),
    FechaCreacion DATETIME
)
GO

CREATE PROCEDURE InsertarPost
    @Titulo VARCHAR(500),
    @Contenido VARCHAR(MAX),
    @Categoria VARCHAR(100),
    @FechaCreacion DATETIME
    AS 
    BEGIN
    INSERT INTO Post 
        VALUES
            (@Titulo, @Contenido, @Categoria, @FechaCreacion )
 END
 GO


CREATE PROCEDURE ActualizarPost
    @PostId INT,
    @Titulo VARCHAR(500),
    @Contenido VARCHAR(MAX),
    @Categoria VARCHAR(100)
    AS
    BEGIN
    UPDATE Post SET Titulo=@Titulo, Contenido=@Contenido, Categoria=@Categoria WHERE PostId=@PostId
END
GO

CREATE PROCEDURE ObtenerTodosLosPost
AS
BEGIN
    SELECT *
    FROM Post
END
GO
 





 
CREATE PROCEDURE EliminarPost
@PostId INT
AS
BEGIN
    DELETE Post WHERE PostId=@Postid 
END
GO

CREATE PROCEDURE ObtenerPostPorCategoria
    @Categoria VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Post
    WHERE Categoria=@Categoria
END
GO
CREATE PROCEDURE ObtenerPostPorTitulo
    @Titulo VARCHAR(500)
AS
BEGIN
    SELECT *
    FROM Post
    WHERE Titulo LIKE '%' + @Titulo + '%'
END
GO

------------------------------------------------------------------
CREATE TABLE Comentario
(
    ComentarioId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Contenido VARCHAR(MAX),
    FechaCreacion DATETIME,
    UsuarioId INT,
    PostId INT,
    ComentarioPadreId INT NULL,
    CONSTRAINT FK_Comentario_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId) ON DELETE CASCADE,
    CONSTRAINT FK_Comentario_PostId FOREIGN KEY (PostID) REFERENCES Post(PostID) ON DELETE CASCADE,
    CONSTRAINT FK_Comentario_ComentarioPadreID FOREIGN KEY (ComentarioPadreID) REFERENCES Comentario(ComentarioID) ON DELETE NO ACTION
)
GO

CREATE TRIGGER TR_EliminarComentariosHijos ON Comentario
AFTER DELETE
AS BEGIN
    DELETE FROM Comentario WHERE ComentarioPadreId IN (SELECT ComentarioId FROM DELETED)
END
GO

CREATE PROCEDURE ObtenerComentariosPorPostId
    @PostId INT
 AS
 BEGIN
    SELECT C.ComentarioId, C.Contenido, C.FechaCreacion, C.UsuarioId, C.PostId, U.NombreUsuario
    FROM Comentario C
    INNER JOIN Usuarios U ON U.UsuarioId=C.UsuarioId
    WHERE C.PostId=@PostId AND C.ComentarioPadreId IS NULL
END
GO

CREATE PROCEDURE ObtenerComentariosHijosPorComentarioId
@ComentarioId INT
AS
BEGIN
    SELECT c.ComentarioId, c.Contenido, c.FechaCreacion, c.UsuarioId, c.PostId, u.NombreUsuario
    FROM Comentario c
    INNER JOIN Usuarios u ON u.UsuarioId=c.UsuarioId
    WHERE c.ComentarioPadreId=@ComentarioId
END
GO
CREATE PROCEDURE AgregarComentario
@Contenido VARCHAR(MAX),
@FechaCreacion DATETIME,
@UsuarioId INT,
@PostId INT,
@ComentarioPadreId INT = NULL
AS
BEGIN
    INSERT INTO Comentario
    VALUES (@Contenido, @FechaCreacion, @UsuarioId, @PostId, @ComentarioPadreId)
END
GO

