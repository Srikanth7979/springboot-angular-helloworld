# Use the official Node.js image as the base image
FROM node:14 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install dependencies
RUN npm install

# Copy the entire project to the working directory
COPY . .

# Build the Angular app
RUN ng build --prod

# Stage 2: Use a lighter image for serving the Angular app
FROM nginx:alpine

# Copy the build output from the builder stage to the NGINX server's html directory
COPY --from=builder /app/dist/angular-app /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]

# Use the official OpenJDK image as the base image
FROM openjdk:11-jre-slim AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the packaged JAR file to the working directory
COPY target/*.jar app.jar

# Expose port 8081 to the outside world
EXPOSE 8081

# Run the JAR file
CMD ["java", "-jar", "app.jar"]
