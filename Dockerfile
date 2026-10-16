# Usar una imagen ligera de Python
FROM python:3.11-slim

# Evitar que Python genere archivos .pyc y asegurar logs en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copiar e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- MEDIDAS DE SEGURIDAD ---
# Crear un usuario y grupo del sistema sin privilegios
RUN addgroup --system appgroup && adduser --system --group appuser

# Copiar el código del proyecto
COPY . .

# Cambiar la propiedad de los archivos al nuevo usuario
RUN chown -R appuser:appgroup /app

# Instruir a Docker para que use este usuario
USER appuser
# -----------------------------

EXPOSE 8000

# Ejecutar el servidor
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]