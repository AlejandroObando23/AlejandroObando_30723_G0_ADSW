export interface Transportista {
  id: string;
  cedula: string;
  nombres: string;
  apellidos: string;
  correo: string;
  telefono: string;
  direccion: string;
  estado: 'Activo' | 'Inactivo';
  vehiculo?: {
    tipo: string;
    placa: string;
    marca: string;
    anio: number;
  } | null;
}
