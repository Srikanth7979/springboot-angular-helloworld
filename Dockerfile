FROM node:latest
WORKDIR /app
RUN npm install -g @angular/cli
COPY package*.json ./
RUN npm install
COPY . .
RUN ng build --
EXPOSE 5000
CMD ["ng", "server", "--host", "0.0.0.0", "--port", "5000", "--disable-host-check"]
