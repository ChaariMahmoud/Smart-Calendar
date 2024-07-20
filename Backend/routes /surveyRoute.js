const express = require('express');
const router = express.Router();
const surveyController = require('../controllers/surveyController');

// Create a new survey response
router.post('/surveys', surveyController.createSurvey);

// Get survey responses by userId
router.get('/surveys/:userId', surveyController.getSurveyByUserId);

// Get all surveys
router.get('/surveys', surveyController.getAllSurveys);

// Delete surveys by userId
router.delete('/surveys/:userId', surveyController.deleteSurveyByUserId);

// Delete all surveys
router.delete('/surveys', surveyController.deleteAllSurveys);

module.exports = router;
