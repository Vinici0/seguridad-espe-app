# ESPE Security: Aplicación Móvil y Web para la Gestión de Alertas Comunitarias

## Índice

- [Descripción General](#descripción-general)  
- [Características Principales](#características-principales)  
- [Arquitectura](#arquitectura)  
- [Tecnologías Utilizadas](#tecnologías-utilizadas)  
- [Instalación](#instalación)  
- [Uso](#uso)  
- [Pruebas y Resultados](#pruebas-y-resultados)  
- [Contribuciones](#contribuciones)  
- [Licencia](#licencia)  
- [Referencias](#referencias)

---

## Descripción General

Este repositorio contiene el proyecto **“ESPE Security”**, una aplicación móvil y web diseñada para la **gestión de alertas de emergencias comunitarias**.

La iniciativa surge a partir de un estudio llevado a cabo en la parroquia **Luz de América** en la provincia de **Santo Domingo de los Tsáchilas**, donde se determinó que el **87.95%** de la población encuestada desea contar con una aplicación que les permita reportar incidentes en tiempo real.

Las incidencias más reportadas incluyen:
- Accidentes de tránsito  
- Robos y delitos  
- Emergencias médicas  
- Personas sin hogar  

El objetivo principal es **facilitar y agilizar la notificación de eventos críticos** dentro de la comunidad, mejorando así la **coordinación** y la **respuesta inmediata** de las autoridades y miembros de la comunidad.

---

## Características Principales

1. **Reportes en tiempo real**: Los usuarios pueden crear reportes con detalles como ubicación, tipo de incidente y descripción.  
2. **Notificaciones instantáneas**: Alertas de emergencias enviadas a los dispositivos móviles de todos los usuarios cercanos al incidente.  
3. **Interfaz intuitiva**: Diseño centrado en la experiencia del usuario tanto en la versión web como en la aplicación móvil.  
4. **Monitoreo centralizado**: Panel de administración que permite a los encargados de la seguridad comunitaria supervisar todas las incidencias.  
5. **Estadísticas e informes**: Se generan datos estadísticos sobre los tipos de incidentes, zonas de mayor incidencia, entre otros.

---

## Arquitectura

La solución se compone de dos aplicaciones principales (móvil y web) que comparten la misma **base de datos** y la **API**:

```mermaid
flowchart LR
    subgraph Usuario
    A[App Móvil] -->|Reportes - Lectura/Escritura| C
    B[App Web] -->|Reportes - Lectura/Escritura| C
    end

    subgraph Servidor
    C[API Node.js] -->|Consultas| D[Base de Datos MongoDB]
    end
