// ==========================================
// PATRÓN STRATEGY: INTERFAZ (STRATEGY)
// ==========================================
/**
 * Define el contrato común para todos los algoritmos de cálculo de rutas.
 * El patrón Strategy permite que el "Contexto" (RutaCalculadora) use esta interfaz
 * sin saber qué algoritmo específico se está utilizando.
 */
export interface RouteStrategy {
  calcularRuta(origen: string, destino: string): any;
}

// ==========================================
// PATRÓN STRATEGY: ESTRATEGIAS CONCRETAS
// ==========================================
/**
 * Cada clase "ConcreteStrategy" implementa un algoritmo distinto.
 * Al aislar estos algoritmos en clases separadas, evitamos usar bloques
 * enormes de if/else en la lógica principal y aplicamos el principio Abierto/Cerrado (OCP).
 */

export class RutaMasRapidaStrategy implements RouteStrategy {
  calcularRuta(origen: string, destino: string) {
    console.log(`Calculando la ruta MÁS RÁPIDA de ${origen} a ${destino}`);
    // Simulación de cálculo
    return {
      criterio: 'Rápida',
      tiempoEstimado: '4 horas',
      distancia: '350 km',
      peajes: 3,
      camino: `${origen} -> Autopista Principal -> ${destino}`
    };
  }
}

export class RutaMasSeguraStrategy implements RouteStrategy {
  calcularRuta(origen: string, destino: string) {
    console.log(`Calculando la ruta MÁS SEGURA de ${origen} a ${destino}`);
    // Simulación de cálculo
    return {
      criterio: 'Segura',
      tiempoEstimado: '5.5 horas',
      distancia: '400 km',
      peajes: 5,
      camino: `${origen} -> Vía Troncal Vigilada -> Destacamento Policial -> ${destino}`
    };
  }
}

export class RutaMenorDistanciaStrategy implements RouteStrategy {
  calcularRuta(origen: string, destino: string) {
    console.log(`Calculando la ruta de MENOR DISTANCIA de ${origen} a ${destino}`);
    // Simulación de cálculo
    return {
      criterio: 'Corta',
      tiempoEstimado: '4.5 horas',
      distancia: '280 km',
      peajes: 1,
      camino: `${origen} -> Carretera Secundaria Antigua -> ${destino}`
    };
  }
}

// ==========================================
// PATRÓN STRATEGY: CONTEXTO
// ==========================================
/**
 * RutaCalculadora es el "Contexto". No implementa el algoritmo de rutas por sí mismo,
 * sino que delega el trabajo al objeto "estrategia" que tiene asignado. 
 * Esto permite cambiar el algoritmo en pleno vuelo usando setEstrategia().
 */
export class RutaCalculadora {
  private estrategia: RouteStrategy;

  constructor(estrategia: RouteStrategy) {
    this.estrategia = estrategia;
  }

  setEstrategia(estrategia: RouteStrategy) {
    this.estrategia = estrategia;
  }

  ejecutarCalculo(origen: string, destino: string) {
    return this.estrategia.calcularRuta(origen, destino);
  }
}
