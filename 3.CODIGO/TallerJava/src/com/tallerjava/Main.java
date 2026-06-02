package com.tallerjava;

import com.tallerjava.controller.ControlEstudiante;
import com.tallerjava.repository.RepositorioEstudiante;
import com.tallerjava.repository.RepositorioEstudianteMemoria;
import com.tallerjava.view.FormularioCrudEstudiante;

public class Main {
    public static void main(String[] args) {
        RepositorioEstudiante repositorio = new RepositorioEstudianteMemoria();
        ControlEstudiante controlEstudiante = new ControlEstudiante(repositorio);
        FormularioCrudEstudiante.iniciar(controlEstudiante);
    }
}
