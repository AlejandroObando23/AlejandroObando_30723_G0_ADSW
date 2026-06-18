import { Auditoria } from '../../domain/entities/Auditoria';
import { JsonStorage } from '../storage/JsonStorage';
import { ISystemObserver } from '../../domain/observer/SystemObserver';
import { v4 as uuidv4 } from 'uuid';

/*
 * PATRÓN ADAPTER / OBSERVER
 * ==========================================
 * Esta clase actúa simultáneamente como un Adaptador (Adapter) para guardar los 
 * registros en 'auditoria.json' usando JsonStorage, y también implementa 
 * ISystemObserver (Patrón Observer) para escuchar pasivamente los eventos del sistema
 * y guardarlos como logs de auditoría sin intervenir en la lógica principal.
 */
export class JsonAuditoriaAdapter implements ISystemObserver {
  private storage: JsonStorage<Auditoria>;

  constructor() {
    this.storage = new JsonStorage('auditoria.json');
  }

  async log(accion: string, modulo: string, usuario: string = 'Sistema') {
    const data = await this.storage.readAll();
    data.push({
      id: uuidv4(),
      accion,
      modulo,
      fecha: new Date(),
      usuario
    });
    await this.storage.writeAll(data);
  }

  update(event: string, data: any): void {
    this.log(`Evento disparado: ${event}`, 'SistemaObserver');
  }
}
