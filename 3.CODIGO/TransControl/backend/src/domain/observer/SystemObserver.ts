// ==========================================
// PATRÓN OBSERVER: INTERFAZ BASE
// ==========================================
/**
 * Define la interfaz que todos los observadores del sistema deben implementar.
 * El método update se ejecuta automáticamente cuando el "Sujeto" notifica un cambio.
 */
export interface ISystemObserver {
  update(event: string, data: any): void;
}

// ==========================================
// PATRÓN OBSERVER: SUJETO BASE (SUBJECT)
// ==========================================
/**
 * Clase base para cualquier Sujeto (Subject) en el sistema.
 * Gestiona una lista genérica de observadores y contiene la lógica para 
 * suscribirlos (attach), desuscribirlos (detach) y notificarles (notify) 
 * cuando ocurre un evento importante.
 */
export class SystemSubject {
  private observers: ISystemObserver[] = [];

  attach(observer: ISystemObserver): void {
    const isExist = this.observers.includes(observer);
    if (isExist) {
      return console.log('Subject: Observer has been attached already.');
    }
    this.observers.push(observer);
  }

  detach(observer: ISystemObserver): void {
    const observerIndex = this.observers.indexOf(observer);
    if (observerIndex === -1) {
      return console.log('Subject: Nonexistent observer.');
    }
    this.observers.splice(observerIndex, 1);
  }

  notify(event: string, data: any): void {
    for (const observer of this.observers) {
      observer.update(event, data);
    }
  }
}
