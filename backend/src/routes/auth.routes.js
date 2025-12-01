const express = require('express');
const { check } = require('express-validator');
const { register, login, getMe, logout } = require('../controllers/auth.controller');
const { protect } = require('../middleware/auth.middleware');

const router = express.Router();

// Register route with validation
router.post(
  '/register',
  [
    check('fullName', 'Full name is required').not().isEmpty(),
    check('username', 'Username is required').not().isEmpty(),
    check('email', 'Please include a valid email').isEmail(),
    check('password', 'Please enter a password with 6 or more characters').isLength({ min: 6 }),
    check('role', 'Role must be one of: startup, developer, investor, mentor, user').optional().isIn([
      'startup', 'developer', 'investor', 'mentor', 'user'
    ])
  ],
  register
);

// Login route with validation
router.post(
  '/login',
  [
    check('email', 'Please include a valid email').isEmail(),
    check('password', 'Password is required').exists()
  ],
  login
);

// Get current user route (protected)
router.get('/me', protect, getMe);

// Logout route
router.get('/logout', protect, logout);

module.exports = router;
