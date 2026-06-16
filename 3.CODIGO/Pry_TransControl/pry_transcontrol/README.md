# 🚛 Pry_TransControl

> **Sistema de gestión y monitoreo de transporte** desarrollado con Flutter

---

## 📋 Descripción del Proyecto

**Pry_TransControl** es una aplicación móvil/desktop construida con **Flutter** que permite gestionar y monitorear operaciones de transporte de carga. La aplicación cubre el ciclo completo: desde la autenticación de usuarios hasta el seguimiento en tiempo real de viajes, gestión de transportistas, vehículos, documentos y notificaciones.

---

## 👥 Equipo de Desarrollo

| Nombre | Rama Git | Rol |
|--------|----------|-----|
| Alejandro Obando | `Alejandro` | Modelado/ Integración / Testing  |
| Juan | `Juan` |Backend / Frontend / UI |
| Steven | `Steven` | Líder del proyecto/ Integración / Testing |

---

## 🏗️ Arquitectura

El proyecto sigue una arquitectura en capas basada en **Clean Architecture** con los siguientes módulos:

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── business/                    # Capa de negocio
│   ├── entities/                # Entidades del dominio
│   │   ├── viaje.dart
│   │   ├── transportista.dart
│   │   ├── vehiculo.dart
│   │   ├── documento.dart
│   │   ├── notificacion.dart
│   │   ├── ruta.dart
│   │   └── usuario.dart
│   ├── observers/               # Patrón Observer
│   ├── providers/               # Providers de estado
│   ├── services/                # Servicios de negocio
│   ├── strategies/              # Patrón Strategy
│   └── usecases/                # Casos de uso
├── data/                        # Capa de datos
├── presentation/                # Capa de presentación
│   ├── screens/                 # Pantallas de la app
│   │   ├── auth/                # Login / Crear cuenta
│   │   ├── dashboard/           # Panel principal
│   │   ├── viajes/              # Gestión de viajes
│   │   ├── transportistas/      # Gestión de transportistas
│   │   ├── monitoreo/           # Monitoreo en tiempo real
│   │   ├── documentos/          # Gestión de documentos
│   │   └── notificaciones/      # Notificaciones
│   ├── theme/                   # Tema de la aplicación
│   ├── widgets/                 # Widgets reutilizables
│   ├── providers/               # Providers de UI
│   └── navigation/              # Configuración de rutas
└── utils/                       # Utilidades generales
```

---

## 🛠️ Tecnologías Utilizadas

| Tecnología | Versión | Uso |
|------------|---------|-----|
| **Flutter** | ≥3.11.4 | Framework principal |
| **Dart** | ^3.11.4 | Lenguaje de programación |
| **Flutter Riverpod** | ^2.4.10 | Gestión de estado |
| **Equatable** | ^2.0.5 | Comparación de entidades |
| **Google Fonts** | ^8.1.0 | Tipografía |
| **Flutter Animate** | ^4.0.0 | Animaciones |

---

## 🚀 Cómo Ejecutar el Proyecto

### Requisitos previos
- Flutter SDK instalado ([Guía oficial](https://docs.flutter.dev/get-started/install))
- Dart SDK ^3.11.4
- Git

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/AlejandroObando23/AlejandroObando_30723_G0_ADSW.git

# 2. Navegar a la carpeta del proyecto
cd 3.CODIGO/Pry_TransControl/pry_transcontrol

# 3. Instalar dependencias
flutter pub get

# 4. Verificar configuración
flutter doctor

# 5. Ver dispositivos disponibles
flutter devices

# 6. Ejecutar la aplicación
flutter run

# Plataformas específicas
flutter run -d windows   # Escritorio Windows
flutter run -d chrome    # Navegador web
flutter run -d android   # Emulador Android
```

---

## 📱 Funcionalidades Principales

- ✅ **Autenticación** — Login y registro de usuarios
- ✅ **Dashboard** — Panel principal con resumen de operaciones
- ✅ **Gestión de Viajes** — Crear, ver y administrar viajes
- ✅ **Detalle de Viaje** — Información completa por viaje
- ✅ **Gestión de Transportistas** — Crear, editar y listar transportistas
- ✅ **Monitoreo** — Seguimiento de unidades en tiempo real
- ✅ **Documentos** — Gestión de documentación de transporte
- ✅ **Notificaciones** — Sistema de alertas y notificaciones
- ✅ **Tema personalizado** — Soporte para modo oscuro/claro

---

## 📌 Historial de Versiones

| Versión | Fecha | Rama | Descripción de cambios |
|---------|-------|------|------------------------|
| `v1.0.0` | 2026-06-15 | `main` | 🎉 **Versión inicial del proyecto.** Estructura base de la aplicación Flutter con arquitectura Clean Architecture. Se incluyen las entidades del dominio (Viaje, Transportista, Vehículo, Documento, Notificación, Ruta, Usuario), pantallas principales (Auth, Dashboard, Viajes, Transportistas, Monitoreo, Documentos, Notificaciones), gestión de estado con Riverpod, tema personalizado, patrón Observer y patrón Strategy. |

---

## 🌿 Estructura de Ramas

| Rama | Descripción |
|------|-------------|
| `main` | Rama principal con el código estable y versionado |
| `Juan` | Rama de desarrollo de Juan |
| `Alejandro` | Rama de desarrollo de Alejandro |
| `Steven` | Rama de desarrollo de Steven |

---

## 📄 Licencia

Proyecto académico — Universidad. Todos los derechos reservados © 2026.
