const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const userRoutes = require('./routes /userRoute');
const taskRoutes = require('./routes /taskRoute');
const uploadRoutes = require('./routes /uploadRoute');
const surveyRoutes = require('./routes /surveyRoute');

const app = express();

const cors = require('cors');
app.use(cors());

// MongoDB connection
mongoose.connect('mongodb://0.0.0.0:27017/smart_calendar')
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Middleware
app.use(express.json());

// Routes
app.use('/api/users', userRoutes);
app.use('/api/tasks', taskRoutes);
app.use('/api', uploadRoutes); 
app.use('/api', surveyRoutes);
module.exports = app;
