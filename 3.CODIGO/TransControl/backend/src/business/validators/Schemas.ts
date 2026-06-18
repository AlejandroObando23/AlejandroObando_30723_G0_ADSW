import { z } from 'zod';

function validarCedulaEcuatoriana(cedula: string): boolean {
  if (!/^\d{10}$/.test(cedula)) return false;

  const provincia = parseInt(cedula.substring(0, 2), 10);
  if (!((provincia >= 1 && provincia <= 24) || provincia === 30)) return false;

  const tercerDigito = parseInt(cedula.charAt(2), 10);
  if (tercerDigito >= 6) return false;

  const coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  let suma = 0;

  for (let i = 0; i < 9; i++) {
    let valor = parseInt(cedula.charAt(i), 10) * coeficientes[i];
    if (valor >= 9) valor -= 9;
    suma += valor;
  }

  const verificador = parseInt(cedula.charAt(9), 10);
  const decenaSuperior = Math.ceil(suma / 10) * 10;
  let digitoCalculado = decenaSuperior - suma;
  if (digitoCalculado === 10) digitoCalculado = 0;

  return digitoCalculado === verificador;
}

export const transportistaSchema = z.object({
  cedula: z.string()
    .length(10, 'La cédula debe tener exactamente 10 dígitos')
    .regex(/^\d+$/, 'La cédula solo debe contener números')
    .refine(validarCedulaEcuatoriana, 'La cédula ingresada no es una cédula ecuatoriana válida'),
  nombres: z.string()
    .min(2, 'Los nombres deben tener al menos 2 caracteres')
    .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, 'Los nombres solo deben contener letras'),
  apellidos: z.string()
    .min(2, 'Los apellidos deben tener al menos 2 caracteres')
    .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, 'Los apellidos solo deben contener letras'),
  correo: z.string().email('El correo electrónico no tiene un formato válido (ejemplo: usuario@dominio.com)'),
  telefono: z.string()
    .regex(/^(09\d{8}|0[2-7]\d{7})$/, 'El teléfono debe ser un celular válido (10 dígitos, empieza con 09) o un convencional (9 dígitos, empieza con 02-07)'),
  direccion: z.string().min(5, 'La dirección ingresada es muy corta (mínimo 5 caracteres)'),
  estado: z.enum(['Activo', 'Inactivo']).default('Activo'),
  vehiculo: z.object({
    tipo: z.string().min(1, 'El tipo de vehículo es requerido'),
    placa: z.string()
      .regex(/^[A-Z]{3}-\d{3,4}$/i, 'La placa debe tener un formato ecuatoriano válido (ejemplo: ABC-1234 o ABC-123)'),
    marca: z.string()
      .min(2, 'La marca debe tener al menos 2 caracteres')
      .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, 'La marca solo debe contener letras'),
    anio: z.coerce.number()
      .int('El año debe ser un número entero')
      .min(1950, 'El año del vehículo no puede ser anterior a 1950')
      .max(new Date().getFullYear() + 1, `El año del vehículo no puede ser mayor a ${new Date().getFullYear() + 1}`),
  }).nullable().optional()
});

export const viajeSchema = z.object({
  origen: z.string()
    .min(2, 'El origen debe tener al menos 2 caracteres')
    .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s-]+$/, 'El origen solo debe contener letras, espacios y guiones'),
  destino: z.string()
    .min(2, 'El destino debe tener al menos 2 caracteres')
    .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s-]+$/, 'El destino solo debe contener letras, espacios y guiones'),
  pesoCarga: z.number().positive('El peso debe ser mayor a 0'),
  tipoMercancia: z.string().min(2, 'Tipo de mercancía requerido'),
  contenedor: z.string()
    .regex(/^[A-Z]{4}\d{7}$/i, 'El contenedor debe tener un formato válido de 4 letras y 7 números (ejemplo: MSCU1234567)')
    .optional()
    .or(z.literal('')),
  observaciones: z.string().optional(),
  transportistaId: z.string().optional()
});

export const documentoSchema = z.object({
  tipo: z.enum(['Cedula', 'Licencia Profesional', 'Matricula', 'Revision Tecnica', 'SOAT'], {
    message: 'Tipo de documento no válido'
  }),
  transportistaId: z.string().min(1, 'El ID del transportista es requerido')
});

export const loginSchema = z.object({
  correo: z.string().email('El correo electrónico no tiene un formato válido (ejemplo: usuario@dominio.com)'),
  password: z.string().min(6, 'La contraseña debe tener al menos 6 caracteres')
});

export const registerSchema = z.object({
  nombres: z.string()
    .min(2, 'Los nombres deben tener al menos 2 caracteres')
    .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, 'Los nombres solo deben contener letras'),
  apellidos: z.string()
    .min(2, 'Los apellidos deben tener al menos 2 caracteres')
    .regex(/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, 'Los apellidos solo deben contener letras'),
  cedula: z.string()
    .length(10, 'La cédula debe tener exactamente 10 dígitos')
    .regex(/^\d+$/, 'La cédula solo debe contener números')
    .refine(validarCedulaEcuatoriana, 'La cédula ingresada no es una cédula ecuatoriana válida'),
  telefono: z.string()
    .regex(/^(09\d{8}|0[2-7]\d{7})$/, 'El teléfono debe ser un celular válido (10 dígitos, empieza con 09) o un convencional (9 dígitos, empieza con 02-07)'),
  correo: z.string().email('El correo electrónico no tiene un formato válido (ejemplo: usuario@dominio.com)'),
  password: z.string().min(6, 'La contraseña debe tener al menos 6 caracteres'),
  rolId: z.enum(['Gerente', 'Administrador', 'Transportista']).default('Transportista')
});
