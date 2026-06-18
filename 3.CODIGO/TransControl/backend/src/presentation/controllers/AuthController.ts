import { Request, Response } from 'express';
import { AuthService } from '../../business/services/AuthService';
import { loginSchema, registerSchema } from '../../business/validators/Schemas';

export class AuthController {
  private authService = new AuthService();

  register = async (req: Request, res: Response): Promise<void> => {
    try {
      const validatedData = registerSchema.parse(req.body);
      const result = await this.authService.register(validatedData);
      res.status(201).json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.issues || error.errors || error.message });
    }
  };

  login = async (req: Request, res: Response): Promise<void> => {
    try {
      const validatedData = loginSchema.parse(req.body);
      const result = await this.authService.login(validatedData.correo, validatedData.password);
      res.json(result);
    } catch (error: any) {
      res.status(401).json({ error: error.issues || error.errors || error.message });
    }
  };
}
