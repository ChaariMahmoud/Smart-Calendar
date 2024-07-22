const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');


const userSchema = new mongoose.Schema({
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

  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  otp: {
    type: String,
  },
  jwtToken: {
    type: String,
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

userSchema.pre('save', async function (next) {
  this._id = this.id.toString(); 
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, 10);
  }
  
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('User', userSchema);
