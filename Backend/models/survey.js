const mongoose = require('mongoose');

const surveySchema = new mongoose.Schema({

  userId: {
    type: String,
    required: true,
  },
  preferredWorkHours: {
    type: String, // e.g., "09:00 AM - 05:00 PM"
    required: true,
  },
  activeDays: {
    type: [String], // e.g., ["Monday", "Wednesday", "Friday"]
    required: true,
  },
  taskTypes: {
    type: [String], // e.g., ["Work", "Exercise", "Study"]
    required: true,
  },
  mood: {
    type: String, // e.g., "Happy", "Sad"
    required: true,
  },
  feelings: {
    type: String, // e.g., "Stressed", "Calm"
    required: true,
  },
  sleepHours: {
    type: Number, // e.g., 7.5
    required: true,
  },
  wakeUpTime: {
    type: String, // e.g., "06:30 AM"
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

surveySchema.pre('save', function (next) {
   
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Survey', surveySchema);
