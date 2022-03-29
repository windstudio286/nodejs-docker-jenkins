# nodejs-docker-jenkins
Example how to dockerizate application written by nodejs and use jenkins to CICD

Initialize nodejs project
```
npm init
npm install express --save
```

Create file main.js
```
var express = require('express')    //Load express module with `require` directive
var app = express() 
 
//Define request response in root URL (/)
app.get('/', function (req, res) {
  res.send('Hello Welcome to Automateinfra.com')
})
app.listen(8081, function () {
  console.log('app listening on port 8081!')
})
```
```
var express = require('express')    //Load express module with `require` directive
var app = express() 
 
//Define request response in root URL (/)
app.get('/', function (req, res) {
  res.send('Hello Welcome to Automateinfra.com')
})
app.listen(8081, function () {
  console.log('app listening on port 8081!')
})
```
Create Dockerfile
```
FROM node:alpine

RUN mkdir -p /app
WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 8081

CMD ["npm", "start"]
```

