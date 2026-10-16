# 1. Imagen base: Usamos la versión oficial, ligera (slim) y compatible con tu entorno
FROM python:3.12-slim

# 2. Directorio de trabajo: Todo lo que hagamos a partir de aquí será dentro de la carpeta /app del contenedor
WORKDIR /app

# 3. Optimización de caché: Copiamos solo el requirements.txt primero. 
# Esto evita que Docker reinstale todas las librerías si solo cambiaste un archivo de código.
COPY requirements.txt .

# 4. Instalación de dependencias: Instalamos sin guardar la caché de pip para reducir el peso final
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar el código: Llevamos tu main.py, la carpeta alembic y alembic.ini hacia el contenedor
COPY . .

# 6. Exponer puerto: Le indicamos a Docker que el contenedor escuchará tráfico en el puerto 8000
EXPOSE 8000

# 7. Comando de arranque: La instrucción exacta para encender Uvicorn dentro del contenedor.
# Usamos 0.0.0.0 para que acepte conexiones desde fuera de su propia red interna.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
