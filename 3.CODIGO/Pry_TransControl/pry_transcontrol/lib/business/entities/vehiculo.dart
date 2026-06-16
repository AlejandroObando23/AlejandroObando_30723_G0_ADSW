import 'package:equatable/equatable.dart';

enum TipoVehiculo { camion, remolque, tractomula }

class Vehiculo extends Equatable {
  final String id;
  final String placa;
  final TipoVehiculo tipo;
  final String marca;
  final String modelo;
  final int year;
  final double capacidadToneladas;
  final String numeroMotor;
  final String numeroChasis;
  final DateTime? fechaVencimientoTecnicomecanica;
  final DateTime? fechaVencimientoSeguro;
  final bool activo;

  const Vehiculo({
    required this.id,
    required this.placa,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.year,
    required this.capacidadToneladas,
    required this.numeroMotor,
    required this.numeroChasis,
    this.fechaVencimientoTecnicomecanica,
    this.fechaVencimientoSeguro,
    this.activo = true,
  });

  bool get documentosVigentes {
    final ahora = DateTime.now();
    final tecnicoVigente =
        fechaVencimientoTecnicomecanica == null ||
        fechaVencimientoTecnicomecanica!.isAfter(ahora);
    final seguroVigente =
        fechaVencimientoSeguro == null ||
        fechaVencimientoSeguro!.isAfter(ahora);
    return tecnicoVigente && seguroVigente;
  }

  Vehiculo copyWith({
    String? id,
    String? placa,
    TipoVehiculo? tipo,
    String? marca,
    String? modelo,
    int? year,
    double? capacidadToneladas,
    String? numeroMotor,
    String? numeroChasis,
    DateTime? fechaVencimientoTecnicomecanica,
    DateTime? fechaVencimientoSeguro,
    bool? activo,
  }) {
    return Vehiculo(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      tipo: tipo ?? this.tipo,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      year: year ?? this.year,
      capacidadToneladas: capacidadToneladas ?? this.capacidadToneladas,
      numeroMotor: numeroMotor ?? this.numeroMotor,
      numeroChasis: numeroChasis ?? this.numeroChasis,
      fechaVencimientoTecnicomecanica:
          fechaVencimientoTecnicomecanica ??
          this.fechaVencimientoTecnicomecanica,
      fechaVencimientoSeguro:
          fechaVencimientoSeguro ?? this.fechaVencimientoSeguro,
      activo: activo ?? this.activo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    placa,
    tipo,
    marca,
    modelo,
    year,
    capacidadToneladas,
    numeroMotor,
    numeroChasis,
    fechaVencimientoTecnicomecanica,
    fechaVencimientoSeguro,
    activo,
  ];
}
