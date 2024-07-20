const Survey = require('../models/survey');

// Create a new survey response
const createSurvey = async (req, res) => {
  try {
    const survey = new Survey(req.body);
    await survey.save();
    res.status(201).send(survey);
  } catch (error) {
    res.status(400).send(error);
  }
};

// Get survey responses for a user
const getSurveyByUserId = async (req, res) => {
  try {
    const surveys = await Survey.find({ userId: req.params.userId });
    if (!surveys) {
      return res.status(404).send();
    }
    res.send(surveys);
  } catch (error) {
    res.status(500).send(error);
  }
};

// Get all surveys
const getAllSurveys = async (req, res) => {
    try {
      const surveys = await Survey.find({});
      res.send(surveys);
    } catch (error) {
      res.status(500).send(error);
    }
  };

// Delete survey by userId
const deleteSurveyByUserId = async (req, res) => {
    try {
      const result = await Survey.deleteMany({ userId: req.params.userId });
      if (result.deletedCount === 0) {
        return res.status(404).send({ message: 'No surveys found for this user' });
      }
      res.send({ message: 'Surveys deleted successfully' });
    } catch (error) {
      res.status(500).send(error);
    }
  };
  
  // Delete all surveys
  const deleteAllSurveys = async (req, res) => {
    try {
      await Survey.deleteMany({});
      res.send({ message: 'All surveys deleted successfully' });
    } catch (error) {
      res.status(500).send(error);
    }
  };

module.exports = {
  createSurvey,
  getSurveyByUserId,
  getAllSurveys,
  deleteSurveyByUserId,
  deleteAllSurveys,
};
