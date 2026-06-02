package com.tallerjava.view;

import com.tallerjava.controller.ControlEstudiante;
import com.tallerjava.model.Estudiante;
import com.tallerjava.model.Resultado;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.util.List;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

public class FormularioCrudEstudiante extends JFrame {
    private final JTextField txtId;
    private final JTextField txtNombre;
    private final JTextField txtEdad;
    private final ControlEstudiante controlEstudiante;
    private final DefaultTableModel modeloTabla;

    public FormularioCrudEstudiante(ControlEstudiante controlEstudiante) {
        super("Sistema CRUD de Estudiantes");
        this.controlEstudiante = controlEstudiante;

        txtId = new JTextField();
        txtNombre = new JTextField();
        txtEdad = new JTextField();

        modeloTabla = new DefaultTableModel(new Object[] {"ID", "Nombre", "Edad"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        JTable tabla = new JTable(modeloTabla);
        tabla.setRowHeight(25);
        tabla.setFont(new Font("Arial", Font.PLAIN, 12));
        JTableHeader header = tabla.getTableHeader();
        header.setFont(new Font("Arial", Font.BOLD, 13));
        header.setBackground(new Color(70, 130, 180));
        header.setForeground(Color.WHITE);

        JButton btnAgregar = new JButton("Agregar");
        JButton btnActualizar = new JButton("Actualizar");
        JButton btnEliminar = new JButton("Eliminar");
        JButton btnMostrarTodo = new JButton("Mostrar Todo");

        Font fuente = new Font("Arial", Font.PLAIN, 11);
        for (JButton btn : new JButton[]{btnAgregar, btnActualizar, btnEliminar, btnMostrarTodo}) {
            btn.setFont(fuente);
            btn.setBackground(new Color(70, 130, 180));
            btn.setForeground(Color.WHITE);
            btn.setFocusPainted(false);
        }

        JPanel panelFormulario = new JPanel(new GridLayout(3, 2, 10, 12));
        panelFormulario.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createTitledBorder("Datos del Estudiante"),
            BorderFactory.createEmptyBorder(10, 15, 10, 15)
        ));
        panelFormulario.setBackground(new Color(240, 240, 240));

        Font labelFont = new Font("Arial", Font.BOLD, 12);
        JLabel lblId = new JLabel("ID:");
        lblId.setFont(labelFont);
        JLabel lblNombre = new JLabel("Nombre:");
        lblNombre.setFont(labelFont);
        JLabel lblEdad = new JLabel("Edad:");
        lblEdad.setFont(labelFont);

        panelFormulario.add(lblId);
        panelFormulario.add(txtId);
        panelFormulario.add(lblNombre);
        panelFormulario.add(txtNombre);
        panelFormulario.add(lblEdad);
        panelFormulario.add(txtEdad);

        JPanel panelBotones = new JPanel(new GridLayout(1, 4, 12, 8));
        panelBotones.setBorder(BorderFactory.createEmptyBorder(10, 15, 10, 15));
        panelBotones.setBackground(new Color(240, 240, 240));
        panelBotones.add(btnAgregar);
        panelBotones.add(btnActualizar);
        panelBotones.add(btnEliminar);
        panelBotones.add(btnMostrarTodo);

        JPanel panelTabla = new JPanel(new BorderLayout());
        panelTabla.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createTitledBorder("Listado de Estudiantes"),
            BorderFactory.createEmptyBorder(10, 10, 10, 10)
        ));
        panelTabla.add(new JScrollPane(tabla), BorderLayout.CENTER);

        setLayout(new BorderLayout(10, 10));
        add(panelFormulario, BorderLayout.NORTH);
        add(panelBotones, BorderLayout.CENTER);
        add(panelTabla, BorderLayout.SOUTH);

        btnAgregar.addActionListener(e -> clickAgregar());
        btnActualizar.addActionListener(e -> clickActualizar());
        btnEliminar.addActionListener(e -> clickEliminar());
        btnMostrarTodo.addActionListener(e -> clickMostrarTodo());

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1000, 700);
        setLocationRelativeTo(null);
        clickMostrarTodo();
    }

    public void clickAgregar() {
        Integer edad = obtenerEdadDesdeCampo();
        if (edad == null) {
            return;
        }

        Resultado resultado = controlEstudiante.agregarEstudiante(
                txtId.getText(),
                txtNombre.getText(),
                edad
        );
        mostrarMensaje(resultado.getMensaje());
        if (resultado.isExitoso()) {
            clickMostrarTodo();
            limpiarCampos();
        }
    }

    public void clickActualizar() {
        Integer edad = obtenerEdadDesdeCampo();
        if (edad == null) {
            return;
        }

        Resultado resultado = controlEstudiante.actualizarEstudiante(
                txtId.getText(),
                txtNombre.getText(),
                edad
        );
        mostrarMensaje(resultado.getMensaje());
        if (resultado.isExitoso()) {
            clickMostrarTodo();
            limpiarCampos();
        }
    }

    public void clickEliminar() {
        Resultado resultado = controlEstudiante.eliminarEstudiante(txtId.getText());
        mostrarMensaje(resultado.getMensaje());
        if (resultado.isExitoso()) {
            clickMostrarTodo();
            limpiarCampos();
        }
    }

    public void clickMostrarTodo() {
        List<Estudiante> estudiantes = controlEstudiante.mostrarTodos();
        mostrarTabla(estudiantes);
    }

    public void mostrarMensaje(String mensaje) {
        JOptionPane.showMessageDialog(this, mensaje);
    }

    public void mostrarTabla(List<Estudiante> estudiantes) {
        modeloTabla.setRowCount(0);
        for (Estudiante estudiante : estudiantes) {
            modeloTabla.addRow(new Object[] {
                    estudiante.getId(),
                    estudiante.getNombre(),
                    estudiante.getEdad()
            });
        }
    }

    private Integer obtenerEdadDesdeCampo() {
        String edadTexto = txtEdad.getText();
        try {
            return Integer.parseInt(edadTexto.trim());
        } catch (NumberFormatException ex) {
            mostrarMensaje("La edad debe ser un número entero positivo.");
            return null;
        }
    }

    private void limpiarCampos() {
        txtId.setText("");
        txtNombre.setText("");
        txtEdad.setText("");
    }

    public static void iniciar(ControlEstudiante controlEstudiante) {
        SwingUtilities.invokeLater(() -> {
            FormularioCrudEstudiante formulario = new FormularioCrudEstudiante(controlEstudiante);
            formulario.setVisible(true);
        });
    }
}
