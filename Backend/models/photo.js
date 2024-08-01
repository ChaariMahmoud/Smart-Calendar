// models/Photo.js

const mongoose = require('mongoose');


const photoSchema = new mongoose.Schema({
  taskId: {
    type : String,
  },
  userId: {
    type : String,
  },
  imageData: {
    type: String, // This will store the base64 encoded image data
  },
  action: {
    type: String,
    enum: ['add', 'update'],
  },
 
});

module.exports = mongoose.model('Photo', photoSchema);
