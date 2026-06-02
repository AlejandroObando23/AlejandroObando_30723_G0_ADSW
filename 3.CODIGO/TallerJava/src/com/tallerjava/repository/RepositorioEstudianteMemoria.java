package com.tallerjava.repository;

import com.tallerjava.model.Estudiante;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class RepositorioEstudianteMemoria implements RepositorioEstudiante {
    private final Map<String, Estudiante> estudiantes = new LinkedHashMap<>();

    @Override
    public boolean existeId(String id) {
        return estudiantes.containsKey(id);
    }

    @Override
    public void guardar(Estudiante estudiante) {
        estudiantes.put(estudiante.getId(), estudiante);
    }

    @Override
    public Estudiante buscarPorId(String id) {
        return estudiantes.get(id);
    }

    @Override
    public void actualizar(Estudiante estudiante) {
        estudiantes.put(estudiante.getId(), estudiante);
    }

    @Override
    public void eliminar(String id) {
        estudiantes.remove(id);
    }

    @Override
    public List<Estudiante> listarTodos() {
        return new ArrayList<>(estudiantes.values());
    }
}
