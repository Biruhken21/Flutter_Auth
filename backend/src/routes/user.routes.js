const express = require('express');
const { check } = require('express-validator');
const { 
  getUsers, 
  getUser, 
  updateUser, 
  followUser, 
  unfollowUser 
} = require('../controllers/user.controller');
const { protect, authorize } = require('../middleware/auth.middleware');

const router = express.Router();

// Apply protection to all routes
router.use(protect);

// Get all users - admin only
router.get('/', authorize('admin'), getUsers);

// Get single user
router.get('/:id', getUser);

// Update user with validation
router.put(
  '/:id',
  [
    check('fullName', 'Full name must be less than 50 characters').optional().isLength({ max: 50 }),
    check('bio', 'Bio must be less than 500 characters').optional().isLength({ max: 500 }),
    check('skills', 'Skills must be an array').optional().isArray(),
    check('interests', 'Interests must be an array').optional().isArray()
  ],
  updateUser
);

// Follow a user
router.put('/:id/follow', followUser);

// Unfollow a user
router.put('/:id/unfollow', unfollowUser);

module.exports = router;
