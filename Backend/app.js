const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const userRoutes = require('./routes /userRoute');
const taskRoutes = require('./routes /taskRoute');
const surveyRoutes = require('./routes /surveyRoute');
const authRoutes = require('./routes /authRoute');
const photoRoutes = require('./routes /photoRoute');

const app = express();
require('dotenv').config();
const cors = require('cors');
app.use(bodyParser.json({ limit: '50mb' }));
app.use(cors());

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

// Middleware
app.use(express.json());
const authenticateToken = require('./middlewares/auth');
const errorHandler = require('./middlewares/error');
// Routes
app.use('/api/users',authenticateToken, userRoutes);
app.use('/api/tasks', taskRoutes);
app.use('/api/photo', photoRoutes);
app.use('/api/surveys',authenticateToken, surveyRoutes);
app.use('/api/auth', authRoutes);


module.exports = app;
