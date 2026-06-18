import { Transportista } from '../../domain/entities/Transportista';
import { ITransportistaRepository } from '../../domain/interfaces/ITransportistaRepository';
import { JsonStorage } from '../storage/JsonStorage';

/* 
 * PATRÓN ADAPTER: ADAPTADOR (CONCRETE ADAPTER)
 * ==========================================
 * Esta clase actúa como un traductor entre dos mundos incompatibles.
 * Por un lado, la capa de negocio espera un "ITransportistaRepository" con métodos estándar 
 * (create, update, delete). Por otro lado, JsonStorage sabe cómo manipular archivos físicos .json.
 * El Adapter "envuelve" a JsonStorage para que la capa de negocio pueda guardar datos
 * sin saber que está usando un archivo plano.
 *
 * NOTA DE MIGRACIÓN: 
 * Para migrar a una Base de Datos real como Prisma, solo debes crear un "PrismaTransportistaAdapter",
 * implementar la interfaz, y cambiar la inyección en el servicio. La lógica de negocio no se tocará.
 */
export class JsonTransportistaAdapter implements ITransportistaRepository {
  private storage: JsonStorage<Transportista>;

  constructor() {
    this.storage = new JsonStorage<Transportista>('transportistas.json');
  }

  async create(transportista: Transportista): Promise<Transportista> {
    const data = await this.storage.readAll();
    data.push(transportista);
    await this.storage.writeAll(data);
    return transportista;
  }

  async update(id: string, transportista: Partial<Transportista>): Promise<Transportista | null> {
    const data = await this.storage.readAll();
    const index = data.findIndex(t => t.id === id);
    if (index === -1) return null;

    const updated = { ...data[index], ...transportista };
    data[index] = updated;
    await this.storage.writeAll(data);
    return updated;
  }

  async delete(id: string): Promise<boolean> {
    const data = await this.storage.readAll();
    const index = data.findIndex(t => t.id === id);
    if (index === -1) return false;

    data.splice(index, 1);
    await this.storage.writeAll(data);
    return true;
  }

  async findById(id: string): Promise<Transportista | null> {
    const data = await this.storage.readAll();
    return data.find(t => t.id === id) || null;
  }

  async findAll(): Promise<Transportista[]> {
    return await this.storage.readAll();
  }
}
