const express = require('express');
const peticionesRoutes = require('./routes/peticiones');
const app = express();


app.use('/peticiones', peticionesRoutes); 

module.exports = app;