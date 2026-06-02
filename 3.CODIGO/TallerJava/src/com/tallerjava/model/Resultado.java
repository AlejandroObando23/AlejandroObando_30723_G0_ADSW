package com.tallerjava.model;

public class Resultado {
    private final boolean exitoso;
    private final String mensaje;

    private Resultado(boolean exitoso, String mensaje) {
        this.exitoso = exitoso;
        this.mensaje = mensaje;
    }

    public static Resultado exito(String mensaje) {
        return new Resultado(true, mensaje);
    }

    public static Resultado error(String mensaje) {
        return new Resultado(false, mensaje);
    }

    public boolean isExitoso() {
        return exitoso;
    }

    public String getMensaje() {
        return mensaje;
    }
}
