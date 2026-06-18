import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { documentoSchema } from '../../business/validators/Schemas';

export class DocumentoController {
  upload = async (req: Request, res: Response): Promise<void> => {
    try {
      if (!req.file) {
        res.status(400).json({ error: 'No se subió ningún archivo' });
        return;
      }
      
      const validatedData = documentoSchema.parse(req.body);
      const doc = {
        id: uuidv4(),
        tipo: validatedData.tipo,
        estado: 'Pendiente',
        rutaArchivo: req.file.path,
        transportistaId: validatedData.transportistaId
      };
      
      // Aquí se usaría el DocumentoService y Adapter, pero devolvemos éxito para el MVP
      res.status(201).json({ message: 'Documento subido correctamente', documento: doc });
    } catch (error: any) {
      res.status(400).json({ error: error.issues || error.errors || error.message });
    }
  };
}
