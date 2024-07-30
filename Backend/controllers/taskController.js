const Task = require('../models/task');

exports.createTask = async (req, res) => {
  try {
    const existingTask = await Task.findOne({ id: req.body.id });
    if (existingTask) {
      return res.status(409).send({ error: 'Task with this ID already exists' });
    }
    const task = new Task(req.body);
    await task.save();
    res.status(201).send(task);
  } catch (error) {
    res.status(400).send(error);
  }
};

exports.getTasks = async (req, res) => {
  try {
    const tasks = await Task.find();
    res.status(200).send(tasks);
  } catch (error) {
    res.status(500).send(error);
  }
};

exports.getTaskById = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) {
      return res.status(404).send();
    }
    res.status(200).send(task);
  } catch (error) {
    res.status(500).send(error);
  }
};

exports.updateTask = async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!task) {
      return res.status(404).send();
    }
    res.status(200).send(task);
  } catch (error) {
    res.status(400).send(error);
  }
};

exports.deleteTask = async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) {
      return res.status(404).send();
    }
    res.status(200).send(task);
  } catch (error) {
    res.status(500).send(error);
  }
};

exports.deleteAllTasks = async (req, res) => {
  try {
    const result = await Task.deleteMany({});
    res.status(200).send({ message: 'All tasks deleted successfully', deletedCount: result.deletedCount });
  } catch (error) {
    res.status(500).send({ error: 'Failed to delete all tasks' });
  }
};
exports.getTasksByUserId = async (req, res) => {
  try {
    const tasks = await Task.find({ userId: req.params.userId });
    if (!tasks) {
      return res.status(404).send();
    }
    res.status(200).send(tasks);
  } catch (error) {
    res.status(500).send(error);
  }
};