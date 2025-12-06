# Shorten URL Application

Aplicación web para acortar URLs desarrollada con ASP.NET Core 8.0

## Estructura del Proyecto

```
lab-2025-ii-si784-u1-04-csharp-diegocastillo12/
├── infra/                          # Infraestructura como código (Terraform)
│   └── main.tf                     # Configuración de recursos Azure
├── src/                            # Código fuente de la aplicación
│   ├── Areas/
│   │   ├── Domain/                 # Capa de dominio
│   │   │   ├── UrlMapping.cs       # Entidad de mapeo de URLs
│   │   │   └── ShortenContext.cs   # Contexto de base de datos
│   │   └── Identity/               # Identidad y autenticación
│   │       └── Data/
│   │           └── ShortenIdentityDbContext.cs
│   ├── Pages/                      # Razor Pages
│   │   └── Shared/
│   │       └── _Layout.cshtml      # Layout principal
│   ├── Program.cs                  # Punto de entrada de la aplicación
│   ├── appsettings.json           # Configuración de la aplicación
│   └── Shorten.csproj             # Archivo de proyecto .NET
├── .github/
│   └── workflows/
│       ├── deploy.yml              # Pipeline de infraestructura
│       └── ci-cd.yml               # Pipeline de CI/CD con SonarCloud
├── Dockerfile                      # Configuración de contenedor Docker
└── sonar-project.properties        # Configuración de SonarCloud

## Tecnologías Utilizadas

- **Backend**: ASP.NET Core 8.0
- **Base de datos**: Azure SQL Database
- **ORM**: Entity Framework Core 8.0
- **Autenticación**: ASP.NET Core Identity
- **IaC**: Terraform
- **Cloud**: Microsoft Azure
- **Containerización**: Docker
- **CI/CD**: GitHub Actions
- **Análisis de código**: SonarCloud, TFSec
- **Visualización**: Terramaid, Inframap, Infracost

## Características de Seguridad Implementadas

### Infraestructura (Terraform)
- ✅ HTTPS obligatorio en la aplicación web
- ✅ TLS mínimo 1.2 para SQL Server y Web App
- ✅ Identidad administrada del sistema para Web App
- ✅ Logging detallado habilitado
- ✅ Encriptación transparente de datos (TDE) para SQL Database
- ✅ Políticas de detección de amenazas en SQL Database
- ✅ Políticas de retención de respaldo
- ✅ Variables sensibles marcadas como `sensitive`

### Aplicación
- ✅ Autenticación de usuarios con ASP.NET Core Identity
- ✅ Conexión segura a base de datos con encriptación
- ✅ Validación de entrada en modelos de dominio

## Pipelines de CI/CD

### Pipeline de Infraestructura (deploy.yml)
1. **Análisis de seguridad con TFSec**: Escaneo de vulnerabilidades en código Terraform
2. **Validación de Terraform**: Verificación de sintaxis y plan de despliegue
3. **Visualización con Terramaid**: Generación de diagramas de arquitectura
4. **Análisis con Inframap**: Generación de diagramas de infraestructura
5. **Estimación de costos con Infracost**: Cálculo de costos de recursos Azure
6. **Despliegue**: Aplicación de cambios en Azure

### Pipeline de Aplicación (ci-cd.yml)
1. **Análisis de código con SonarCloud**: Detección de code smells, bugs y vulnerabilidades
2. **Build de imagen Docker**: Construcción de contenedor de la aplicación
3. **Push a GitHub Container Registry**: Publicación de imagen
4. **Despliegue en Azure Web App**: Actualización de la aplicación en producción

## Configuración Requerida

### Secrets de GitHub
- `AZURE_USERNAME`: Usuario de Azure
- `AZURE_PASSWORD`: Contraseña de Azure
- `SUSCRIPTION_ID`: ID de suscripción de Azure
- `SQL_USER`: Usuario administrador de SQL
- `SQL_PASS`: Contraseña de SQL
- `AZURE_WEBAPP_PUBLISH_PROFILE`: Perfil de publicación de Azure Web App
- `SONAR_TOKEN`: Token de autenticación de SonarCloud
- `INFRACOST_API_KEY`: API Key de Infracost

## Comandos de Desarrollo

### Ejecutar localmente
```bash
cd src
dotnet restore
dotnet run
```

### Crear migraciones
```bash
cd src
dotnet ef migrations add MigrationName --context ShortenContext
dotnet ef database update --context ShortenContext
```

### Construir Docker
```bash
docker build -t shorten:latest .
docker run -p 8080:80 shorten:latest
```

## Actividades del Laboratorio Completadas

1. ✅ Creación de infraestructura con Terraform
2. ✅ Resolución de vulnerabilidades detectadas por TFSec
3. ✅ Integración de SonarCloud en el pipeline
4. ✅ Construcción de aplicación ASP.NET Core
5. ✅ Dockerización de la aplicación
6. ✅ Despliegue automatizado en Azure

## Próximos Pasos

1. Configurar los secrets en GitHub
2. Ejecutar el workflow de deploy.yml para crear la infraestructura
3. Obtener la URL de la aplicación web creada
4. Actualizar `AZURE_WEBAPP_NAME` en ci-cd.yml con el nombre de la aplicación
5. Actualizar la cadena de conexión en appsettings.json
6. Ejecutar el workflow de ci-cd.yml para desplegar la aplicación
7. Descargar el diagrama inframap_azure.svg de los artifacts
8. Ejecutar comando de métricas de Azure Monitor
9. Exportar plantilla ARM con `az group export`

## Autor

Diego Castillo - UPT FAING EPIS

## Licencia

Este proyecto es parte del laboratorio 04 de la asignatura SI784.
```
