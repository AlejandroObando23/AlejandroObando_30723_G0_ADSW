import { useState, useEffect } from 'react';
import { Container, Row, Col, Form, Badge } from 'react-bootstrap';
import { api } from '../services/api';

interface Point {
  x: number;
  y: number;
}

interface Vehicle {
  tipo: string;
  placa: string;
  marca: string;
  anio: number;
}

interface Transportista {
  id: string;
  nombres: string;
  apellidos: string;
  telefono: string;
  vehiculo?: Vehicle | null;
}

interface Viaje {
  id: string;
  origen: string;
  destino: string;
  pesoCarga: number;
  tipoMercancia: string;
  contenedor?: string;
  observaciones?: string;
  estado: string;
  transportista?: Transportista | null;
}

const CITY_COORDS: { [key: string]: Point } = {
  Quito: { x: 300, y: 80 },
  Guayaquil: { x: 120, y: 280 },
  Cuenca: { x: 220, y: 340 },
  Ambato: { x: 270, y: 180 },
  Riobamba: { x: 260, y: 220 },
  Manta: { x: 60, y: 200 },
  SantoDomingo: { x: 210, y: 130 },
  Esmeraldas: { x: 180, y: 40 },
};

const CITY_GEO: { [key: string]: { lat: number; lng: number } } = {
  Quito: { lat: -0.1807, lng: -78.4678 },
  Guayaquil: { lat: -2.1894, lng: -79.8890 },
  Cuenca: { lat: -2.9001, lng: -79.0059 },
  Ambato: { lat: -1.2491, lng: -78.6272 },
  Riobamba: { lat: -1.6709, lng: -78.6471 },
  Manta: { lat: -0.9677, lng: -80.7089 },
  SantoDomingo: { lat: -0.2530, lng: -79.1754 },
  Esmeraldas: { lat: 0.9682, lng: -79.6517 },
};

const PATHS: { [key: string]: Point[] } = {
  'Quito-Guayaquil': [
    { x: 300, y: 80 }, // Quito
    { x: 210, y: 130 }, // Santo Domingo
    { x: 140, y: 220 }, // Quevedo
    { x: 120, y: 280 }  // Guayaquil
  ],
  'Guayaquil-Quito': [
    { x: 120, y: 280 },
    { x: 140, y: 220 },
    { x: 210, y: 130 },
    { x: 300, y: 80 }
  ],
  'Quito-Ambato': [
    { x: 300, y: 80 },
    { x: 280, y: 130 }, // Latacunga
    { x: 270, y: 180 }  // Ambato
  ],
  'Ambato-Quito': [
    { x: 270, y: 180 },
    { x: 280, y: 130 },
    { x: 300, y: 80 }
  ],
  'Cuenca-Ambato': [
    { x: 220, y: 340 }, // Cuenca
    { x: 230, y: 300 }, // Azogues
    { x: 260, y: 220 }, // Riobamba
    { x: 270, y: 180 }  // Ambato
  ],
  'Ambato-Cuenca': [
    { x: 270, y: 180 },
    { x: 260, y: 220 },
    { x: 230, y: 300 },
    { x: 220, y: 340 }
  ],
  'Cuenca-Guayaquil': [
    { x: 220, y: 340 },
    { x: 160, y: 310 }, // Naranjal
    { x: 120, y: 280 }
  ],
  'Guayaquil-Cuenca': [
    { x: 120, y: 280 },
    { x: 160, y: 310 },
    { x: 220, y: 340 }
  ]
};

const fallbackViajes: Viaje[] = [
  {
    id: 'f1',
    origen: 'Quito',
    destino: 'Guayaquil',
    pesoCarga: 15,
    tipoMercancia: 'Alimentos Perecederos',
    contenedor: 'MSCU8392019',
    observaciones: 'Mantener refrigerado a 4°C',
    estado: 'EnCurso',
    transportista: {
      id: 'd1',
      nombres: 'Luis Fernando',
      apellidos: 'Mendoza',
      telefono: '0991234567',
      vehiculo: { tipo: 'Camión Sencillo', placa: 'PBA-1234', marca: 'Chevrolet', anio: 2022 }
    }
  },
  {
    id: 'f2',
    origen: 'Cuenca',
    destino: 'Ambato',
    pesoCarga: 8.5,
    tipoMercancia: 'Materiales Construcción',
    contenedor: 'TOLU7483920',
    observaciones: 'Entregar en obra norte',
    estado: 'EnCurso',
    transportista: {
      id: 'd2',
      nombres: 'Carlos',
      apellidos: 'Zambrano',
      telefono: '0987654321',
      vehiculo: { tipo: 'Furgón', placa: 'GBA-4567', marca: 'Hino', anio: 2020 }
    }
  }
];

function getPointAlongPath(points: Point[], t: number): Point {
  if (points.length === 0) return { x: 0, y: 0 };
  if (points.length === 1) return points[0];
  if (t <= 0) return points[0];
  if (t >= 1) return points[points.length - 1];

  const totalSegments = points.length - 1;
  const segmentWeight = 1 / totalSegments;
  const segmentIndex = Math.min(Math.floor(t / segmentWeight), totalSegments - 1);
  
  const startPoint = points[segmentIndex];
  const endPoint = points[segmentIndex + 1];
  
  const segmentT = (t - segmentIndex * segmentWeight) / segmentWeight;
  
  return {
    x: startPoint.x + (endPoint.x - startPoint.x) * segmentT,
    y: startPoint.y + (endPoint.y - startPoint.y) * segmentT
  };
}

export function Monitoreo() {
  const [viajes, setViajes] = useState<Viaje[]>([]);
  const [selectedViajeId, setSelectedViajeId] = useState<string>('');
  const [progress, setProgress] = useState<number>(0);
  const [speed, setSpeed] = useState<number>(70);
  const [events, setEvents] = useState<string[]>([]);
  const [isDriver, setIsDriver] = useState(false);

  useEffect(() => {
    const fetchMonitoreoData = async () => {
      try {
        const userStr = localStorage.getItem('user');
        const currentUser = userStr ? JSON.parse(userStr) : null;
        const role = currentUser?.rol?.toLowerCase() || '';
        setIsDriver(role === 'transportista');

        const tripsResponse = await api.get('/viajes');
        const driversResponse = await api.get('/transportistas');
        const drivers = driversResponse.data;

        // Filtrar viajes que tengan transportista asignado
        let trips = tripsResponse.data
          .filter((v: any) => v.estado !== 'Finalizado' && v.estado !== 'Cancelado')
          .map((v: any) => {
            const driver = drivers.find((d: any) => d.id === v.transportistaId);
            return {
              ...v,
              transportista: driver || null
            };
          });

        // Filtrar si es conductor
        if (role === 'transportista' && currentUser) {
          const matchedDriver = drivers.find((d: any) => d.cedula === currentUser.cedula);
          if (matchedDriver) {
            trips = trips.filter((v: any) => v.transportistaId === matchedDriver.id);
          } else {
            trips = [];
          }
        }

        // Si no hay viajes activos en el sistema, usar los mock de fallback
        if (trips.length === 0) {
          setViajes(fallbackViajes);
          setSelectedViajeId(fallbackViajes[0].id);
        } else {
          setViajes(trips);
          setSelectedViajeId(trips[0].id);
        }
      } catch (error) {
        console.error('Error loading monitoring data:', error);
        setViajes(fallbackViajes);
        setSelectedViajeId(fallbackViajes[0].id);
      }
    };

    fetchMonitoreoData();
  }, []);

  const activeViaje = viajes.find(v => v.id === selectedViajeId) || viajes[0];

  // Simulación de movimiento del camión
  useEffect(() => {
    setProgress(0);
    setSpeed(Math.floor(Math.random() * 20) + 65); // 65-85 km/h
    
    if (!activeViaje) return;

    // Generar logs de eventos aleatorios iniciales
    setEvents([
      `[${new Date().toLocaleTimeString()}] Iniciando GPS del camión ${activeViaje.transportista?.vehiculo?.placa || 'PBA-1234'}`,
      `[${new Date(Date.now() - 600000).toLocaleTimeString()}] Salida desde terminal de carga en ${activeViaje.origen}`,
      `[${new Date(Date.now() - 300000).toLocaleTimeString()}] Conexión satelital establecida.`
    ]);

    const timer = setInterval(() => {
      setProgress(prev => {
        if (prev >= 100) {
          return 0; // Reiniciar simulación
        }
        
        // Simular velocidad fluctuante
        setSpeed(s => Math.max(40, Math.min(95, s + (Math.random() * 10 - 5))));
        
        // Disparar eventos ocasionales según progreso
        const nextProgress = prev + 1;
        if (nextProgress === 25) {
          setEvents(e => [`[${new Date().toLocaleTimeString()}] Reporte: Paso por peaje intermedio.`, ...e]);
        } else if (nextProgress === 50) {
          setEvents(e => [`[${new Date().toLocaleTimeString()}] Reporte: Estado del motor OK, carga estable.`, ...e]);
        } else if (nextProgress === 75) {
          setEvents(e => [`[${new Date().toLocaleTimeString()}] Reporte: Camión aproximándose a destino final.`, ...e]);
        } else if (nextProgress === 99) {
          setEvents(e => [`[${new Date().toLocaleTimeString()}] Reporte: Llegada a terminal de destino en ${activeViaje.destino}.`, ...e]);
        }
        return nextProgress;
      });
    }, 800);

    return () => clearInterval(timer);
  }, [selectedViajeId, activeViaje]);

  if (!activeViaje) {
    return (
      <Container className="p-4 text-center">
        <h5 className="text-muted">No tienes viajes activos asignados para monitorear.</h5>
      </Container>
    );
  }

  // Obtener puntos de ruta
  const routeKey = `${activeViaje.origen}-${activeViaje.destino}`;
  const routePoints = PATHS[routeKey] || [
    CITY_COORDS[activeViaje.origen] || { x: 100, y: 100 },
    CITY_COORDS[activeViaje.destino] || { x: 300, y: 300 }
  ];

  // Posición actual del camión
  const truckPos = getPointAlongPath(routePoints, progress / 100);

  // Coordenadas GPS en tiempo real
  const startGeo = CITY_GEO[activeViaje.origen] || { lat: -0.1807, lng: -78.4678 };
  const endGeo = CITY_GEO[activeViaje.destino] || { lat: -2.1894, lng: -79.8890 };
  const currentLat = startGeo.lat + (endGeo.lat - startGeo.lat) * (progress / 100);
  const currentLng = startGeo.lng + (endGeo.lng - startGeo.lng) * (progress / 100);

  // Estimación de tiempo restante (ETA)
  const remainingHours = ((100 - progress) * 0.06).toFixed(1); // ej. 6 horas máximo

  return (
    <Container className="p-4" style={{ maxWidth: '1000px' }}>
      
      <style>{`
        .map-container {
          background-color: #0b111e;
          border-radius: 12px;
          position: relative;
          overflow: hidden;
          box-shadow: inset 0 0 40px rgba(0, 0, 0, 0.6), 0 10px 30px rgba(0,0,0,0.15);
          border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .beacon {
          animation: pulse 2s infinite;
        }
        @keyframes pulse {
          0% { r: 5; opacity: 1; stroke-width: 1; }
          100% { r: 15; opacity: 0; stroke-width: 3; }
        }
        .radar-sweep {
          animation: sweep 10s linear infinite;
          transform-origin: center;
        }
        @keyframes sweep {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
        .events-panel {
          max-height: 140px;
          overflow-y: auto;
          font-family: monospace;
          font-size: 0.8rem;
          background: #111827;
          border: 1px solid #1f2937;
          border-radius: 8px;
          padding: 10px;
          color: #10B981;
        }
      `}</style>

      {/* Selectores */}
      <div className="tc-card mb-4">
        <Row className="align-items-center">
          <Col md={6}>
            <h5 className="fw-bold text-tc-blue m-0">Centro de Monitoreo de Viajes</h5>
            <p className="text-muted small m-0">
              {isDriver ? 'Monitoreo satelital de tu viaje asignado en tiempo real' : 'Monitoreo satelital de la flota activa'}
            </p>
          </Col>
          <Col md={6} className="mt-3 mt-md-0">
            <Form.Group className="d-flex align-items-center">
              <label className="text-muted small fw-bold me-3 text-nowrap">Viaje Activo:</label>
              <Form.Select 
                className="custom-input bg-white" 
                value={selectedViajeId} 
                onChange={e => setSelectedViajeId(e.target.value)}
                disabled={isDriver && viajes.length <= 1}
              >
                {viajes.map(v => (
                  <option key={v.id} value={v.id}>
                    {v.origen} → {v.destino} ({v.transportista?.vehiculo?.placa || 'Sin Placa'})
                  </option>
                ))}
              </Form.Select>
            </Form.Group>
          </Col>
        </Row>
      </div>

      <Row className="g-4">
        {/* Mapa SVG */}
        <Col lg={7}>
          <div className="map-container p-0">
            <svg width="100%" height="400" viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg">
              <defs>
                <pattern id="mapGrid" width="25" height="25" patternUnits="userSpaceOnUse">
                  <path d="M 25 0 L 0 0 0 25" fill="none" stroke="rgba(255, 255, 255, 0.04)" strokeWidth="0.8" />
                </pattern>
                <radialGradient id="radarGrad" cx="50%" cy="50%" r="50%">
                  <stop offset="0%" stopColor="rgba(242, 106, 33, 0.15)" />
                  <stop offset="100%" stopColor="rgba(242, 106, 33, 0)" />
                </radialGradient>
              </defs>

              {/* Grid de fondo */}
              <rect width="100%" height="100%" fill="url(#mapGrid)" />

              {/* Simulación del Barrido de Radar */}
              <circle cx="250" cy="200" r="180" fill="url(#radarGrad)" className="radar-sweep" />
              <circle cx="250" cy="200" r="180" fill="none" stroke="rgba(242,106,33,0.08)" strokeWidth="1" />
              <circle cx="250" cy="200" r="100" fill="none" stroke="rgba(242,106,33,0.05)" strokeWidth="1" />

              {/* Dibujo de todas las carreteras secundarias de fondo en gris */}
              {Object.keys(PATHS).map((key) => (
                <path 
                  key={`road-${key}`}
                  d={`M ${PATHS[key].map(p => `${p.x} ${p.y}`).join(' L ')}`}
                  fill="none"
                  stroke="rgba(255, 255, 255, 0.08)"
                  strokeWidth="2"
                  strokeDasharray="4,4"
                />
              ))}

              {/* Ruta Activa (Brillante) */}
              {routePoints && (
                <>
                  <path 
                    d={`M ${routePoints.map(p => `${p.x} ${p.y}`).join(' L ')}`}
                    fill="none"
                    stroke="rgba(242, 106, 33, 0.2)"
                    strokeWidth="6"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                  <path 
                    d={`M ${routePoints.map(p => `${p.x} ${p.y}`).join(' L ')}`}
                    fill="none"
                    stroke="var(--tc-orange-primary)"
                    strokeWidth="3.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeDasharray="8,8"
                  />
                </>
              )}

              {/* Ciudades Beacons */}
              {Object.keys(CITY_COORDS).map((name) => {
                const c = CITY_COORDS[name];
                const isActiveNode = name === activeViaje.origen || name === activeViaje.destino;
                
                return (
                  <g key={`city-${name}`}>
                    {isActiveNode && (
                      <circle cx={c.x} cy={c.y} r="8" fill="none" stroke="rgba(242, 106, 33, 0.8)" className="beacon" />
                    )}
                    <circle cx={c.x} cy={c.y} r="4.5" fill={isActiveNode ? 'var(--tc-orange-primary)' : 'rgba(255,255,255,0.4)'} />
                    <text 
                      x={c.x + 8} 
                      y={c.y + 4} 
                      fill={isActiveNode ? 'white' : 'rgba(255,255,255,0.35)'} 
                      fontSize="9.5" 
                      fontWeight={isActiveNode ? 'bold' : 'normal'}
                      fontFamily="sans-serif"
                    >
                      {name}
                    </text>
                  </g>
                );
              })}

              {/* Marcador del Camión (🚚) animado */}
              {truckPos && (
                <g transform={`translate(${truckPos.x - 12}, ${truckPos.y - 12})`}>
                  <circle cx="12" cy="12" r="14" fill="rgba(242, 106, 33, 0.25)" />
                  <circle cx="12" cy="12" r="8" fill="var(--tc-orange-primary)" />
                  <text x="6" y="16" fontSize="11" fill="white">🚚</text>
                  <rect x="-10" y="-12" width="44" height="10" rx="3" fill="#0b111e" stroke="var(--tc-orange-primary)" strokeWidth="0.8" />
                  <text x="-7" y="-5" fontSize="7" fontWeight="bold" fill="white" fontFamily="monospace">
                    {activeViaje.transportista?.vehiculo?.placa || 'PBA-1234'}
                  </text>
                </g>
              )}
            </svg>
          </div>
        </Col>

        {/* Panel Telemétrico de Datos */}
        <Col lg={5}>
          <div className="tc-card h-100 d-flex flex-column justify-content-between p-4" style={{ minHeight: '400px' }}>
            <div>
              <div className="d-flex justify-content-between align-items-center mb-3">
                <Badge bg="warning" className="text-dark py-2 px-3 fw-bold" style={{ fontSize: '0.8rem' }}>
                  <i className="bi bi-broadcast me-1"></i> EN TRÁNSITO ({progress}%)
                </Badge>
                <span className="small text-muted fw-bold">ID: {activeViaje.id.substring(0, 8)}...</span>
              </div>

              <h5 className="fw-bold text-tc-blue mb-3">{activeViaje.origen} <i className="bi bi-arrow-right mx-1 text-tc-orange"></i> {activeViaje.destino}</h5>
              
              <div className="mb-4">
                <label className="text-muted small fw-bold mb-1">Progreso de la Ruta</label>
                <div className="progress" style={{ height: '8px', borderRadius: '4px', background: '#e9ecef' }}>
                  <div className="progress-bar progress-bar-striped progress-bar-animated bg-warning" role="progressbar" style={{ width: `${progress}%` }}></div>
                </div>
              </div>

              <Row className="g-3 mb-4">
                <Col xs={6}>
                  <div className="p-2 border rounded bg-light">
                    <span className="text-muted d-block small">Velocidad</span>
                    <strong className="text-tc-blue fs-5">{speed.toFixed(0)} km/h</strong>
                  </div>
                </Col>
                <Col xs={6}>
                  <div className="p-2 border rounded bg-light">
                    <span className="text-muted d-block small">ETA Destino</span>
                    <strong className="text-tc-blue fs-5">{remainingHours} h</strong>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="p-2 border rounded bg-light" style={{ fontFamily: 'monospace' }}>
                    <span className="text-muted d-block small">Coordenadas GPS (WGS84)</span>
                    <strong className="text-tc-blue small">{currentLat.toFixed(6)}, {currentLng.toFixed(6)}</strong>
                  </div>
                </Col>
              </Row>

              <div className="small border-top pt-3">
                <p className="mb-2"><strong className="text-muted me-2">Conductor:</strong> {activeViaje.transportista ? `${activeViaje.transportista.nombres} ${activeViaje.transportista.apellidos}` : 'No asignado'}</p>
                <p className="mb-2"><strong className="text-muted me-2">Teléfono:</strong> {activeViaje.transportista?.telefono || 'N/A'}</p>
                <p className="mb-2"><strong className="text-muted me-2">Vehículo:</strong> {activeViaje.transportista?.vehiculo ? `${activeViaje.transportista.vehiculo.marca} (${activeViaje.transportista.vehiculo.tipo})` : 'N/A'}</p>
                <p className="mb-2"><strong className="text-muted me-2">Carga:</strong> {activeViaje.tipoMercancia} | {activeViaje.pesoCarga} Toneladas</p>
                {activeViaje.contenedor && <p className="mb-0"><strong className="text-muted me-2">Contenedor:</strong> {activeViaje.contenedor}</p>}
              </div>
            </div>

            <div className="mt-4">
              <label className="text-muted small fw-bold mb-2"><i className="bi bi-clock-history me-1"></i>Bitácora de Eventos Recientes</label>
              <div className="events-panel">
                {events.map((ev, i) => (
                  <div key={i} className="mb-1">{ev}</div>
                ))}
              </div>
            </div>
          </div>
        </Col>
      </Row>

    </Container>
  );
}
