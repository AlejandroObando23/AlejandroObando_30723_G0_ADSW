import { INotificationStrategy } from '../../domain/interfaces/INotificationStrategy';

// ==========================================
// PATRÓN STRATEGY: ESTRATEGIAS CONCRETAS
// ==========================================
/**
 * Estas clases implementan diferentes formas (estrategias) de enviar notificaciones.
 * Al usar el patrón Strategy, el sistema puede cambiar entre Email, Push o SMS 
 * dinámicamente sin alterar la lógica de negocio que dispara la notificación.
 */
export class EmailNotificationStrategy implements INotificationStrategy {
  async send(to: string, message: string): Promise<void> {
    // Simular el envío mediante logs
    console.log(`[Email] Sending to ${to}: ${message}`);
  }
}

export class PushNotificationStrategy implements INotificationStrategy {
  async send(to: string, message: string): Promise<void> {
    console.log(`[Push] Sending to ${to}: ${message}`);
  }
}

export class SmsNotificationStrategy implements INotificationStrategy {
  async send(to: string, message: string): Promise<void> {
    console.log(`[SMS] Sending to ${to}: ${message}`);
  }
}
