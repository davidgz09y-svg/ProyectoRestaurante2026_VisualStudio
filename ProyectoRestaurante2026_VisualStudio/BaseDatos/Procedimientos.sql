/*----------------------------   MANTENIMIENTO A LA TABLA PLATO_MENU   ----------------------------*/




/* ============================================================
   1. PROCEDURE INSERTAR/NUEVO
   ============================================================ */
GO

CREATE OR ALTER PROCEDURE insertar_cliente
(
    @p_dni           CHAR(8),
    @p_nombre        NVARCHAR(100),
    @p_apellido      NVARCHAR(100),
    @p_correo        NVARCHAR(150),
    @p_telefono      NVARCHAR(15),
    @p_observacion   NVARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_count INT

    -- Limpiar espacios y null
    SET @p_correo = NULLIF(LTRIM(RTRIM(@p_correo)), '');
    SET @p_telefono = NULLIF(LTRIM(RTRIM(@p_telefono)), '');
    SET @p_observacion = NULLIF(LTRIM(RTRIM(@p_observacion)), '');

    -- Validar Dni
    IF @p_dni IS NULL OR LEN(LTRIM(RTRIM(@p_dni))) <> 8
    BEGIN
        THROW 50001, 'El DNI debe tener exactamente 8 caracteres.', 1;
    END;

    -- Validar solo números en el DNI
    IF @p_dni NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        THROW 50002, 'El DNI solo debe contener números.', 1;
    END;

    -- Validar nombre
    IF @p_nombre IS NULL OR LTRIM(RTRIM(@p_nombre)) = ''
    BEGIN
        THROW 50003, 'El nombre del cliente no puede estar vacío.', 1;
    END;

    -- Validar apellido
    IF @p_apellido IS NULL OR LTRIM(RTRIM(@p_apellido)) = ''
    BEGIN
        THROW 50004, 'El apellido del cliente no puede estar vacío.', 1;
    END;

    -- Validar correo
    IF @p_correo IS NOT NULL
       AND @p_correo NOT LIKE '%_@_%._%'
    BEGIN
        THROW 50005, 'El correo electrónico no tiene un formato válido.', 1;
    END;

    -- Validar télefono
    IF @p_telefono IS NOT NULL
    BEGIN

        -- Solo números
        IF @p_telefono LIKE '%[^0-9]%'
        BEGIN
            THROW 50006, 'El teléfono solo debe contener números.', 1;
        END;

        -- Exactamente 9 dígitos
        IF LEN(@p_telefono) <> 9
        BEGIN
            THROW 50007, 'El teléfono debe tener exactamente 9 dígitos.', 1;
        END;

    END;
   
    -- Validar dni duplicado
    SELECT @v_count = COUNT(*)
    FROM cliente
    WHERE dni_cliente = @p_dni;

    IF @v_count > 0
    BEGIN
        THROW 50008, 'Ya existe un cliente registrado con ese DNI.', 1;
    END;

    -- Insertar
    INSERT INTO cliente
    (
        dni_cliente,
        nombre_cliente,
        apellido_cliente,
        correo_cliente,
        telefono_cliente,
        observacion_cliente,
        estado
    )
    VALUES
    (
        @p_dni,
        @p_nombre,
        @p_apellido,
        @p_correo,
        @p_telefono,
        @p_observacion,
        DEFAULT
    );

    SELECT 'Cliente registrado exitosamente.' AS mensaje;

END;
GO



/* ============================================================
   2. PROCEDURE BUSCAR/SEARCH
   ============================================================ */
GO

CREATE OR ALTER PROCEDURE buscar_cliente
(
    @p_param VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM vista_cliente
    WHERE [Nombres] LIKE '%' + @p_param + '%'
       OR [Apellidos] LIKE '%' + @p_param + '%'
       OR [DNI] LIKE '%' + @p_param + '%'
       OR [Correo] LIKE '%' + @p_param + '%'
       OR [Teléfono] LIKE '%' + @p_param + '%'
END;
GO



/* ============================================================
   3. PROCEDURE UPDATE/MODIFICAR
   ============================================================ */
GO

CREATE OR ALTER PROCEDURE actualizar_cliente
(
    @p_id_cliente INT,
    @p_dni            CHAR(8),
    @p_nombre NVARCHAR(100),
    @p_apellido NVARCHAR(100),
    @p_correo NVARCHAR(150),
    @p_telefono NVARCHAR(15),
    @p_observacion NVARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_count INT;

    -- 1. Validar ID
    IF @p_id_cliente IS NULL
    BEGIN
        THROW 50009, 'El ID del cliente no puede ser NULL.', 1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM cliente
        WHERE id_cliente = @p_id_cliente
    )
    BEGIN
        THROW 50010, 'No existe el cliente con el ID proporcionado.', 1;
    END;

    -- 2. Validar Dni
    IF @p_dni IS NULL OR LEN(LTRIM(RTRIM(@p_dni))) <> 8
    BEGIN
        THROW 50011, 'El DNI debe tener exactamente 8 caracteres.', 1;
    END;

    -- 3. Validar solo números en el DNI
    IF @p_dni NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        THROW 50012, 'El DNI solo debe contener números.', 1;
    END;

    -- 4. Validar nombre
    IF @p_nombre IS NULL OR LTRIM(RTRIM(@p_nombre)) = ''
    BEGIN
        THROW 50013, 'El nombre del cliente no puede estar vacío.', 1;
    END;

    -- 5. Validar apellido
    IF @p_apellido IS NULL OR LTRIM(RTRIM(@p_apellido)) = ''
    BEGIN
        THROW 50014, 'El apellido del cliente no puede estar vacío.', 1;
    END;

    -- 6. Validar correo
    IF @p_correo IS NOT NULL
       AND @p_correo NOT LIKE '%_@_%._%'
    BEGIN
        THROW 50015, 'El correo electrónico no tiene un formato válido.', 1;
    END;

    -- 7. Validar télefono
    IF @p_telefono IS NOT NULL
    BEGIN

        -- Solo números
        IF @p_telefono LIKE '%[^0-9]%'
        BEGIN
            THROW 50017, 'El teléfono solo debe contener números.', 1;
        END;

        -- Exactamente 9 dígitos
        IF LEN(@p_telefono) <> 9
        BEGIN
            THROW 50018, 'El teléfono debe tener exactamente 9 dígitos.', 1;
        END;

    END;

    -- 8. Validar dni duplicado
    SELECT @v_count = COUNT(*)
    FROM cliente
    WHERE dni_cliente = @p_dni
      AND id_cliente <> @p_id_cliente;

    IF @v_count > 0
    BEGIN
        THROW 50019, 'Ya existe otro cliente con ese DNI.', 1;
    END;

    -- Actualizar
    UPDATE cliente
    SET
        dni_cliente = @p_dni,
        nombre_cliente = @p_nombre,
        apellido_cliente = @p_apellido,
        correo_cliente = @p_correo,
        telefono_cliente = @p_telefono,
        observacion_cliente = @p_observacion
    WHERE id_cliente = @p_id_cliente;

    -- Validar cambios
    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50020, 'No se realizaron cambios en el registro.', 1;
    END;

    SELECT 'Cliente actualizado correctamente.' AS Resultado;

END;
GO



/* ============================================================
   4. PROCEDURE DESACTIVAR/ACTIVAR
   ============================================================ */
GO

CREATE OR ALTER PROCEDURE desactivar_cliente
(
    @p_id_cliente INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_existencia INT = 0;

    -- Validar existencia
    SELECT @v_existencia = COUNT(*)
    FROM cliente
    WHERE id_cliente = @p_id_cliente;

    IF @v_existencia = 0
    BEGIN
        THROW 50020, 'El cliente no existe.', 1;
    END;

    -- Desactivar cliente
    UPDATE cliente
    SET estado = 0
    WHERE id_cliente = @p_id_cliente;

    -- Validar desactivación
    IF @@ROWCOUNT = 0
    BEGIN
        THROW 50021, 'No se pudo desactivar el cliente.', 1;
    END;

    SELECT 'Cliente desactivado correctamente.' AS Resultado;

END;
GO
