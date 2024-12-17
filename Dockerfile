# Etapa Build
# Imagen de node.js
FROM node:latest AS build

# Directorio de trabajo del contenedor
WORKDIR /app

COPY package*.json ./

# Instalar las dependencias de la app
RUN npm ci

# Copiar el resto de codigo de la app
COPY . .

# Construir la app
RUN npm run build

# Etapa de ejecución
# Imagen de node.js
FROM node:latest AS runtime

# Directorio de trabajo del contenedor
WORKDIR /app

COPY package*.json ./

# Instalar las dependencias de la app (solo de producción)
RUN npm ci --only=production

# Copiar las carpetas creadas por build
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public

# Puerto donde exponer la app
EXPOSE 3000

# Ejecutar el contenedor como usuario sin privilegios
USER node

# Iniciar la app next.js
CMD ["npm", "start"]
