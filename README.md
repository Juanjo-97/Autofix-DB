# Autofix-DB - Proyecto 3 de Base de Datos

Sistema propuesto para administrar servicios mecánicos en taller y a domicilio de Mecánica Integral &amp; Auxilio
Vial “AutoFix”. El caso incluye clientes, vehículos, órdenes, mecánicos, diagnósticos, presupuestos,
refacciones, facturación y garantías.
## Equipo
- Edgar Manjarrez: Scrum Master y Developer.
- Juan José García: Tech Lead y Developer.
- Daniel Pérez: clientes, vehículos y recepción.
- Luis Amezcua: órdenes, mecánicos, diagnósticos y presupuestos.
- Jesús Castro: refacciones, inventario, facturas y garantías.
## Organización
- docs/: acuerdos y documentación.
- modelo/: diagramas y modelo integrado.
- Archivo SQL final: modelo/autofix_final_corregido.sql.
## Trabajo en equipo
Cada integrante prepara su área; los cambios al modelo compartido se revisan antes de incorporarse a main.
Seguimiento en Jira SCRUM y requerimientos en Confluence: https://autofix-cesun-
equipo3.atlassian.net/wiki/x/CIAE
## Base de datos AutoFix

AutoFix es un sistema para administrar los servicios de un taller mecánico y la atención a domicilio.

### Tablas

El modelo incluye 12 tablas: cliente, vehiculo, recepcion_servicio, orden_trabajo, mecanico, diagnostico, presupuesto, inventario, refaccion, detalle_refaccion, factura y garantia.

### Archivo SQL

El archivo `modelo/autofix_final_corregido.sql` contiene la creación de las tablas, sus relaciones, datos de prueba y consultas de verificación. El modelo tiene 12 relaciones mediante llaves foráneas.

### Abrir el archivo en MySQL Workbench

1. Descarga `autofix_final_corregido.sql` desde la carpeta `modelo`.
2. En MySQL Workbench, abre el archivo SQL.
3. Ejecuta el script para revisar las tablas, relaciones y datos de prueba de la base `autofix`.

## Dashboard de seguimiento en Jira

Consulta el avance del proyecto AutoFix – Equipo 3, las actividades finalizadas y la distribución del trabajo entre los integrantes.

[Ver Dashboard de AutoFix en Jira](https://autofix-cesun-equipo3.atlassian.net/jira/dashboards/10001)
