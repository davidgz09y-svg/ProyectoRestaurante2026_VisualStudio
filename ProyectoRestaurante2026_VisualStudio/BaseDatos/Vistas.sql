

/* ============================================================
   1. VISTA CLIENTE (PK)
   ============================================================ */
GO

CREATE OR ALTER VIEW vista_cliente
AS
SELECT
    c.id_cliente AS [ID],
    c.dni_cliente AS [DNI],
    c.nombre_cliente AS [Nombres],
    c.apellido_cliente AS [Apellidos],
    ISNULL(NULLIF(c.correo_cliente, ''), '-') AS [Correo],

    ISNULL(NULLIF(c.telefono_cliente, ''), '-') AS [Teléfono],

    ISNULL(NULLIF(c.observacion_cliente, ''), '-') AS [Observaciones]
FROM cliente c
WHERE c.estado = 1;
GO