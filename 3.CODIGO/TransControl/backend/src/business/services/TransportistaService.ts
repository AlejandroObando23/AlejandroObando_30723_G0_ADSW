import { Transportista } from '../../domain/entities/Transportista';
import { ITransportistaRepository } from '../../domain/interfaces/ITransportistaRepository';
import { v4 as uuidv4 } from 'uuid';

export class TransportistaService {
  private transportistaRepository: ITransportistaRepository;

  constructor(repository: ITransportistaRepository) {
    // Inyección de dependencias (Repository Pattern)
    this.transportistaRepository = repository;
  }

  async create(data: Omit<Transportista, 'id'>): Promise<Transportista> {
    const list = await this.transportistaRepository.findAll();
    
    if (list.some(t => t.cedula === data.cedula)) {
      throw new Error('La cédula ya está registrada para otro transportista');
    }
    if (list.some(t => t.telefono === data.telefono)) {
      throw new Error('El teléfono ya está registrado para otro transportista');
    }
    if (list.some(t => t.correo.toLowerCase() === data.correo.toLowerCase())) {
      throw new Error('El correo electrónico ya está registrado para otro transportista');
    }
    if (data.vehiculo?.placa) {
      if (list.some(t => t.vehiculo && t.vehiculo.placa.toUpperCase() === data.vehiculo!.placa.toUpperCase())) {
        throw new Error('La placa del vehículo ya está registrada para otro transportista');
      }
    }

    const nuevo: Transportista = {
      ...data,
      id: uuidv4(),
    };
    return await this.transportistaRepository.create(nuevo);
  }

  async getAll(): Promise<Transportista[]> {
    return await this.transportistaRepository.findAll();
  }

  async getById(id: string): Promise<Transportista | null> {
    return await this.transportistaRepository.findById(id);
  }

  async update(id: string, data: Partial<Transportista>): Promise<Transportista | null> {
    const list = await this.transportistaRepository.findAll();
    const otherDrivers = list.filter(t => t.id !== id);

    if (data.cedula && otherDrivers.some(t => t.cedula === data.cedula)) {
      throw new Error('La cédula ya está registrada para otro transportista');
    }
    if (data.telefono && otherDrivers.some(t => t.telefono === data.telefono)) {
      throw new Error('El teléfono ya está registrado para otro transportista');
    }
    if (data.correo && otherDrivers.some(t => t.correo.toLowerCase() === data.correo!.toLowerCase())) {
      throw new Error('El correo electrónico ya está registrado para otro transportista');
    }
    if (data.vehiculo?.placa) {
      if (otherDrivers.some(t => t.vehiculo && t.vehiculo.placa.toUpperCase() === data.vehiculo!.placa.toUpperCase())) {
        throw new Error('La placa del vehículo ya está registrada para otro transportista');
      }
    }

    return await this.transportistaRepository.update(id, data);
  }

  async delete(id: string): Promise<boolean> {
    return await this.transportistaRepository.delete(id);
  }
}
