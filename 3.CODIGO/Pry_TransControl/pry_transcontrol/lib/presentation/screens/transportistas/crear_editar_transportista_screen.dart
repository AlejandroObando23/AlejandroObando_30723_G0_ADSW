import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/entities/transportista.dart';
import '../../../business/entities/vehiculo.dart';
import '../../../business/services/service_locator.dart';

class CrearEditarTransportistaScreen extends ConsumerStatefulWidget {
  final Transportista? transportista;

  const CrearEditarTransportistaScreen({Key? key, this.transportista})
    : super(key: key);

  @override
  ConsumerState<CrearEditarTransportistaScreen> createState() =>
      _CrearEditarTransportistaScreenState();
}

class _CrearEditarTransportistaScreenState
    extends ConsumerState<CrearEditarTransportistaScreen> {
  late final _formKey = GlobalKey<FormState>();
  late final _nombresController = TextEditingController(
    text: widget.transportista?.nombres ?? '',
  );
  late final _apellidosController = TextEditingController(
    text: widget.transportista?.apellidos ?? '',
  );
  late final _cedulaController = TextEditingController(
    text: widget.transportista?.cedula ?? '',
  );
  late final _telefonoController = TextEditingController(
    text: widget.transportista?.telefono ?? '',
  );
  late final _correoController = TextEditingController(
    text: widget.transportista?.correo ?? '',
  );
  late final _licenciaController = TextEditingController(
    text: widget.transportista?.numeroLicencia ?? '',
  );

  late final _placaController = TextEditingController(
    text: widget.transportista?.vehiculo.placa ?? '',
  );
  late final _marcaController = TextEditingController(
    text: widget.transportista?.vehiculo.marca ?? '',
  );
  late final _modeloController = TextEditingController(
    text: widget.transportista?.vehiculo.modelo ?? '',
  );
  late final _yearController = TextEditingController(
    text: widget.transportista?.vehiculo.year.toString() ?? '',
  );
  late final _capacidadController = TextEditingController(
    text: widget.transportista?.vehiculo.capacidadToneladas.toString() ?? '',
  );

  late TipoVehiculo _tipoVehiculo;
  late EstadoTransportista _estado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tipoVehiculo = widget.transportista?.vehiculo.tipo ?? TipoVehiculo.camion;
    _estado = widget.transportista?.estado ?? EstadoTransportista.activo;
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _licenciaController.dispose();
    _placaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _yearController.dispose();
    _capacidadController.dispose();
    super.dispose();
  }

  Future<void> _handleGuardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final vehiculo =
          (widget.transportista?.vehiculo ??
                  Vehiculo(
                    id: 'VEH_${DateTime.now().millisecondsSinceEpoch}',
                    placa: _placaController.text,
                    tipo: _tipoVehiculo,
                    marca: _marcaController.text,
                    modelo: _modeloController.text,
                    year: int.parse(_yearController.text),
                    capacidadToneladas: double.parse(_capacidadController.text),
                    numeroMotor:
                        'MOTOR_${DateTime.now().millisecondsSinceEpoch}',
                    numeroChasis:
                        'CHASIS_${DateTime.now().millisecondsSinceEpoch}',
                  ))
              .copyWith(
                placa: _placaController.text,
                tipo: _tipoVehiculo,
                marca: _marcaController.text,
                modelo: _modeloController.text,
                year: int.parse(_yearController.text),
                capacidadToneladas: double.parse(_capacidadController.text),
              );

      final transportista =
          (widget.transportista ??
                  Transportista(
                    id: 'TRAN_${DateTime.now().millisecondsSinceEpoch}',
                    nombres: _nombresController.text,
                    apellidos: _apellidosController.text,
                    cedula: _cedulaController.text,
                    telefono: _telefonoController.text,
                    correo: _correoController.text,
                    numeroLicencia: _licenciaController.text,
                    vehiculo: vehiculo,
                    fechaRegistro: DateTime.now(),
                    usuarioId: 'USR002', // Usuario actual
                  ))
              .copyWith(
                nombres: _nombresController.text,
                apellidos: _apellidosController.text,
                cedula: _cedulaController.text,
                telefono: _telefonoController.text,
                correo: _correoController.text,
                numeroLicencia: _licenciaController.text,
                vehiculo: vehiculo,
                estado: _estado,
              );

      bool exito;
      if (widget.transportista == null) {
        exito = await serviceLocator.crearTransportistaUseCase(transportista);
      } else {
        exito = await serviceLocator.actualizarTransportistaUseCase(
          transportista,
        );
      }

      if (!mounted) return;

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.transportista == null
                  ? 'Transportista creado exitosamente'
                  : 'Transportista actualizado exitosamente',
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el transportista')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transportista != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Transportista' : 'Crear Transportista'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Datos Personales
                Text(
                  'Datos Personales',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nombresController,
                  decoration: InputDecoration(
                    labelText: 'Nombres',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _apellidosController,
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _cedulaController,
                  decoration: InputDecoration(
                    labelText: 'Cédula',
                    prefixIcon: const Icon(Icons.card_giftcard),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _correoController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _licenciaController,
                  decoration: InputDecoration(
                    labelText: 'Número de Licencia',
                    prefixIcon: const Icon(Icons.credit_card),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 24),

                // Datos del Vehículo
                Text(
                  'Datos del Vehículo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<TipoVehiculo>(
                  value: _tipoVehiculo,
                  onChanged: (TipoVehiculo? newValue) {
                    if (newValue != null) {
                      setState(() => _tipoVehiculo = newValue);
                    }
                  },
                  items: TipoVehiculo.values
                      .map<DropdownMenuItem<TipoVehiculo>>(
                        (TipoVehiculo value) => DropdownMenuItem<TipoVehiculo>(
                          value: value,
                          child: Text(
                            value.toString().split('.').last.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Tipo de Vehículo',
                    prefixIcon: const Icon(Icons.directions_car),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _placaController,
                  decoration: InputDecoration(
                    labelText: 'Placa',
                    prefixIcon: const Icon(Icons.directions_car),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _marcaController,
                  decoration: InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _modeloController,
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: InputDecoration(
                          labelText: 'Año',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _capacidadController,
                        decoration: InputDecoration(
                          labelText: 'Capacidad (ton)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Estado
                if (isEditing)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<EstadoTransportista>(
                        value: _estado,
                        onChanged: (EstadoTransportista? newValue) {
                          if (newValue != null) {
                            setState(() => _estado = newValue);
                          }
                        },
                        items: EstadoTransportista.values
                            .map<DropdownMenuItem<EstadoTransportista>>(
                              (EstadoTransportista value) =>
                                  DropdownMenuItem<EstadoTransportista>(
                                    value: value,
                                    child: Text(_getEstadoLabel(value)),
                                  ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Cancelar'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleGuardar,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(isEditing ? 'Guardar' : 'Crear'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getEstadoLabel(EstadoTransportista estado) {
    switch (estado) {
      case EstadoTransportista.activo:
        return 'Activo';
      case EstadoTransportista.inactivo:
        return 'Inactivo';
      case EstadoTransportista.suspendido:
        return 'Suspendido';
    }
  }
}
