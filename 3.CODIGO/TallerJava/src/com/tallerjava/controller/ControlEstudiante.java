package com.tallerjava.controller;

import com.tallerjava.model.Estudiante;
import com.tallerjava.model.Resultado;
import com.tallerjava.repository.RepositorioEstudiante;
import java.util.List;

public class ControlEstudiante {
    private final RepositorioEstudiante repositorio;

    public ControlEstudiante(RepositorioEstudiante repositorio) {
        this.repositorio = repositorio;
    }

    public Resultado agregarEstudiante(String id, String nombre, int edad) {
        if (!validarDatos(id, nombre, edad)) {
            return Resultado.error("Datos inválidos. Verifique ID, nombre y edad.");
        }

        if (repositorio.existeId(id)) {
            return Resultado.error("Ya existe un estudiante con ese ID.");
        }

        Estudiante estudiante = new Estudiante(id.trim(), nombre.trim(), edad);
        repositorio.guardar(estudiante);
        return Resultado.exito("Estudiante agregado correctamente.");
    }

    public Resultado actualizarEstudiante(String id, String nombre, int edad) {
        if (!validarDatos(id, nombre, edad)) {
            return Resultado.error("Datos inválidos. Verifique ID, nombre y edad.");
        }

        Estudiante existente = repositorio.buscarPorId(id.trim());
        if (existente == null) {
            return Resultado.error("No existe un estudiante con ese ID.");
        }

        Estudiante actualizado = new Estudiante(id.trim(), nombre.trim(), edad);
        repositorio.actualizar(actualizado);
        return Resultado.exito("Estudiante actualizado correctamente.");
    }

    public Resultado eliminarEstudiante(String id) {
        if (id == null || id.trim().isEmpty()) {
            return Resultado.error("El ID es obligatorio para eliminar.");
        }

        String idNormalizado = id.trim();
        Estudiante existente = repositorio.buscarPorId(idNormalizado);
        if (existente == null) {
            return Resultado.error("No existe un estudiante con ese ID.");
        }

        repositorio.eliminar(idNormalizado);
        return Resultado.exito("Estudiante eliminado correctamente.");
    }

    public List<Estudiante> mostrarTodos() {
        return repositorio.listarTodos();
    }

    public boolean validarDatos(String id, String nombre, int edad) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        if (nombre == null || nombre.trim().isEmpty()) {
            return false;
        }
        return edad > 0;
    }
}
