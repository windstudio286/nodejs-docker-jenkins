FROM node:14-alpine3.14

RUN mkdir -p /app
WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 8081

CMD ["npm", "start"]
