const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const userRoutes = require('./routes /userRoute');
const taskRoutes = require('./routes /taskRoute');

const app = express();

// MongoDB connection
mongoose.connect('mongodb://0.0.0.0:27017/smart_calendar')
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Middleware
app.use(express.json());

// Routes
app.use('/api/users', userRoutes);
app.use('/api/tasks', taskRoutes);

module.exports = app;
