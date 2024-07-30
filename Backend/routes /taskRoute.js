const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');

// Create a new task
router.post('/tasks', taskController.createTask);

// Get all tasks
router.get('/tasks', taskController.getTasks);

// Get a task by ID
router.get('/tasks/:id', taskController.getTaskById);

// Update a task by ID
router.put('/tasks/:id', taskController.updateTask);

// Delete a task by ID
router.delete('/tasks/:id', taskController.deleteTask);

// Delete all tasks
router.delete('/tasks', taskController.deleteAllTasks);

router.get('/tasks/user/:userId', taskController.getTasksByUserId);

module.exports = router;
