const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  _id: {
    type: String,
    required: false ,
  },
 
  userId: {
    type: String,
    required: false,
    unique: true,
    default: mongoose.Types.ObjectId.toString(),
  },
  name: {
    type: String,
    
  },
  email: {
    type: String,
    
    unique: true,
  },
  password: {
    type: String,
    
  },
  otp: {
    type: String,
  },
  jwtToken: {
    type: String,
  },
  photo: {
    type: String,
    default: '', // URL or base64 string of the user's photo
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
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, 10);
  }
  
  this._id = this.userId.toString();  
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('User', userSchema);
