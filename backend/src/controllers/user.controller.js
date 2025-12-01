const User = require('../models/user.model');
const { validationResult } = require('express-validator');

// @desc    Get all users
// @route   GET /api/users
// @access  Private/Admin
exports.getUsers = async (req, res, next) => {
  try {
    const users = await User.find();

    res.status(200).json({
      success: true,
      count: users.length,
      data: users
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single user
// @route   GET /api/users/:id
// @access  Private
exports.getUser = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    res.status(200).json({
      success: true,
      data: user
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update user
// @route   PUT /api/users/:id
// @access  Private
exports.updateUser = async (req, res, next) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    // Make sure user is updating their own profile
    if (req.params.id !== req.user.id) {
      return res.status(401).json({
        success: false,
        error: 'Not authorized to update this user'
      });
    }

    // Fields to update
    const fieldsToUpdate = {
      fullName: req.body.fullName,
      bio: req.body.bio,
      profileImageUrl: req.body.profileImageUrl,
      skills: req.body.skills,
      interests: req.body.interests
    };

    // Remove undefined fields
    Object.keys(fieldsToUpdate).forEach(key => 
      fieldsToUpdate[key] === undefined && delete fieldsToUpdate[key]
    );

    const user = await User.findByIdAndUpdate(
      req.params.id,
      fieldsToUpdate,
      {
        new: true,
        runValidators: true
      }
    );

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'User not found'
      });
    }

    res.status(200).json({
      success: true,
      data: user
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Follow a user
// @route   PUT /api/users/:id/follow
// @access  Private
exports.followUser = async (req, res, next) => {
  try {
    // Cannot follow yourself
    if (req.params.id === req.user.id) {
      return res.status(400).json({
        success: false,
        error: 'You cannot follow yourself'
      });
    }

    const userToFollow = await User.findById(req.params.id);
    const currentUser = await User.findById(req.user.id);

    if (!userToFollow) {
      return res.status(404).json({
        success: false,
        error: 'User to follow not found'
      });
    }

    // Check if already following
    if (userToFollow.followers.includes(req.user.id)) {
      return res.status(400).json({
        success: false,
        error: 'You are already following this user'
      });
    }

    // Add to followers and following lists
    await User.findByIdAndUpdate(req.params.id, {
      $push: { followers: req.user.id },
      $inc: { followerCount: 1 }
    });

    await User.findByIdAndUpdate(req.user.id, {
      $push: { following: req.params.id }
    });

    res.status(200).json({
      success: true,
      message: 'User followed successfully'
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Unfollow a user
// @route   PUT /api/users/:id/unfollow
// @access  Private
exports.unfollowUser = async (req, res, next) => {
  try {
    // Cannot unfollow yourself
    if (req.params.id === req.user.id) {
      return res.status(400).json({
        success: false,
        error: 'You cannot unfollow yourself'
      });
    }

    const userToUnfollow = await User.findById(req.params.id);
    const currentUser = await User.findById(req.user.id);

    if (!userToUnfollow) {
      return res.status(404).json({
        success: false,
        error: 'User to unfollow not found'
      });
    }

    // Check if not following
    if (!userToUnfollow.followers.includes(req.user.id)) {
      return res.status(400).json({
        success: false,
        error: 'You are not following this user'
      });
    }

    // Remove from followers and following lists
    await User.findByIdAndUpdate(req.params.id, {
      $pull: { followers: req.user.id },
      $inc: { followerCount: -1 }
    });

    await User.findByIdAndUpdate(req.user.id, {
      $pull: { following: req.params.id }
    });

    res.status(200).json({
      success: true,
      message: 'User unfollowed successfully'
    });
  } catch (err) {
    next(err);
  }
};
