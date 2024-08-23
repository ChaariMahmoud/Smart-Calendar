const User = require('../models/user');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const nodemailer = require('nodemailer');

const registerUser = async (req, res) => {
  try {
    const { userId, name, email, password } = req.body;

    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }
    if (!name) {
      return res.status(400).json({ error: 'Name is required' });
    }
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }
    if (!password) {
      return res.status(400).json({ error: 'Password is required' });
    }

    // Check for existing user
    const existingUser = await User.findOne({ $or: [{ userId }, { email }] });
    if (existingUser) {
      return res.status(400).json({ error: 'User with this ID or email already exists' });
    }

    const user = new User({ userId, name, email, password });
    await user.save();

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    console.error('Error during user registration:', error);  // Log the error for debugging
    res.status(500).json({ error: 'An error occurred while registering the user. Please try again.' });
  }
};

const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }
    if (!password) {
      return res.status(400).json({ error: 'Password is required' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }
  
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    user.jwtToken = token;
    await user.save();

    res.status(200).json({userId: user._id, name: user.name, email: user.email, token ,photo :user.photo});
  } catch (error) {
    console.error('Error during user login:', error);  // Log the error for debugging
    res.status(500).json({ error: 'An error occurred while logging in. Please try again.' });
  }
};

const sendOtp = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: 'User not found' });
    }

    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    user.otp = otp;
    await user.save();

    // Send OTP via email
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL,
        pass: process.env.EMAIL_PASSWORD,
      },
    });

    const mailOptions = {
      from: process.env.EMAIL,
      to: email,
      subject: 'Your OTP Code',
      text: `Your OTP code is ${otp}`,
    };

    await transporter.sendMail(mailOptions);

    res.status(200).json({ message: 'OTP sent' });
  } catch (error) {
    console.error('Error during OTP send:', error);  // Log the error for debugging
    res.status(500).json({ error: 'An error occurred while sending the OTP. Please try again.' });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;

    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }
    if (!otp) {
      return res.status(400).json({ error: 'OTP is required' });
    }

    const user = await User.findOne({ email, otp });
    if (!user) {
      return res.status(400).json({ error: 'Invalid OTP' });
    }

    user.otp = null; // Clear OTP after verification
    await user.save();

    res.status(200).json({ message: 'OTP verified' });
  } catch (error) {
    console.error('Error during OTP verification:', error);  // Log the error for debugging
    res.status(500).json({ error: 'An error occurred while verifying the OTP. Please try again.' });
  }


};


const reset_password = async (req, res) => {
  const { email, newPassword } = req.body;

  try {
    // Find user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Hash the new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update user's password
    user.password = newPassword;
    await user.save();

    // Send success response
    res.status(200).json({ message: 'Password reset successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};


module.exports = { registerUser, loginUser, sendOtp, verifyOtp ,reset_password};
