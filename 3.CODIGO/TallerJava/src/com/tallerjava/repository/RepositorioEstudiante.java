package com.tallerjava.repository;

import com.tallerjava.model.Estudiante;
import java.util.List;

public interface RepositorioEstudiante {
    boolean existeId(String id);

    void guardar(Estudiante estudiante);

    Estudiante buscarPorId(String id);

    void actualizar(Estudiante estudiante);

    void eliminar(String id);

    List<Estudiante> listarTodos();
}
