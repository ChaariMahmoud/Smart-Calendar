const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({

  _id: {
    type: String,
    required: false ,
  },

  id: { 
    type: String,
    required: false,
    unique: true,
    default: mongoose.Types.ObjectId.toString(),
  },

  title: {
    type: String,
    required: true,
  },
  note: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    required: true,
  },
  date: {
    type: String, 
    required: true,
  },
  beginTime: {
    type: String,
    required: true,
  },
  endTime: {
    type: String,
    required: true,
  },
  priority: {
    type: Number,
    required: true,
    min: 1,
    max: 5,
  },
  difficulty: {
    type: Number,
    required: true,
    min: 1,
    max: 5,
  },
  userId: {
    type: String, 
    required: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
  color: {
    type: Number,
    default: 0,
  },
  successPercentage: {
    type: Number,
    required: true,
    min: 0,
    max: 100,
  },
});


taskSchema.pre('save', function (next) {
    this._id = this.id.toString(); 
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Task', taskSchema);
