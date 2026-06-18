# Sistema CRUD de Estudiantes (MVC)

Proyecto en Java con arquitectura **MVC** basado en los diagramas proporcionados:
- `Estudiante` (entidad)
- `RepositorioEstudiante` (persistencia en memoria)
- `ControlEstudiante` (lógica de negocio y validación)
- `FormularioCrudEstudiante` (interfaz gráfica Swing)

## Estructura

- `src/com/tallerjava/model`
- `src/com/tallerjava/repository`
- `src/com/tallerjava/controller`
- `src/com/tallerjava/view`
- `src/com/tallerjava/Main.java`

## Compilar

```bash
mkdir -p out
javac -d out $(find src -name "*.java")
```

## Ejecutar

```bash
java -cp out com.tallerjava.Main
```

## Funcionalidades implementadas

- Agregar estudiante
- Actualizar estudiante
- Eliminar estudiante
- Mostrar todos en tabla
- Validación de datos (ID, nombre y edad > 0)
