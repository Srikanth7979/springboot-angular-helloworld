# Stage 1: Build Angular app
FROM node:14 AS angular-builder

WORKDIR /app

COPY package*.json ./
RUN npm install -g @angular/cli
RUN npm install
COPY . .
RUN ng build --prod

# Stage 2: Build Spring Boot app
FROM maven:3.8.1-jdk-11 AS spring-builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests

# Stage 3: Use a lightweight image for serving Angular app
FROM nginx:alpine

COPY --from=angular-builder /app/dist/angular-app /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

# Stage 4: Use a lightweight image for running Spring Boot app
FROM openjdk:11-jre-slim

COPY --from=spring-builder /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
