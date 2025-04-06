# Base image for building
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Set environment variable
ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install  --force

# Copy the rest of the application
COPY . .

# Build the project
RUN npm run build


# ---------------------------------

# Use a minimal Nginx image
FROM nginx:alpine

# Copy the build artifacts from the builder stage
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
