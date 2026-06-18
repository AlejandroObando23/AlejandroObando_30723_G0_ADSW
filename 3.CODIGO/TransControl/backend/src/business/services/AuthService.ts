import { JsonUsuarioAdapter } from '../../data/adapters/JsonUsuarioAdapter';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';

export class AuthService {
  private adapter = new JsonUsuarioAdapter();
  private secret = 'super-secret-jwt-key'; // En producción, usar variables de entorno

  async register(data: any) {
    const list = await this.adapter.findAll();
    
    if (list.some(u => u.cedula === data.cedula)) {
      throw new Error('La cédula ya está registrada para otro usuario');
    }
    if (list.some(u => u.telefono === data.telefono)) {
      throw new Error('El teléfono ya está registrado para otro usuario');
    }
    if (list.some(u => u.correo.toLowerCase() === data.correo.toLowerCase())) {
      throw new Error('El correo electrónico ya está registrado para otro usuario');
    }

    const passwordHash = await bcrypt.hash(data.password, 10);
    const usuario = {
      id: uuidv4(),
      nombres: data.nombres,
      apellidos: data.apellidos,
      cedula: data.cedula,
      telefono: data.telefono,
      correo: data.correo,
      rolId: data.rolId || 'Transportista',
      passwordHash
    };

    return await this.adapter.create(usuario);
  }

  async login(correo: string, password: string) {
    const user = await this.adapter.findByCorreo(correo);
    if (!user) throw new Error('Credenciales inválidas');

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) throw new Error('Credenciales inválidas');

    const token = jwt.sign({ id: user.id, rol: user.rolId }, this.secret, { expiresIn: '8h' });
    
    return {
      token,
      usuario: { id: user.id, nombres: user.nombres, correo: user.correo, rol: user.rolId }
    };
  }
}
