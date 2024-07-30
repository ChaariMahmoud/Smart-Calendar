const express = require('express');
const { registerUser, loginUser, sendOtp, verifyOtp ,reset_password } = require('../controllers/authController');

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/send-otp', sendOtp);
router.post('/verify-otp', verifyOtp);
router.post('/reset-password', reset_password);

module.exports = router;
