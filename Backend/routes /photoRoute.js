const express = require('express');
const router = express.Router();
const photoController = require('../controllers/photoController');

// Route for uploading a photo
router.post('/upload', photoController.uploadPhoto);

// Route for retrieving a photo by filename
router.get('/:filename', photoController.getPhoto);

// Route for retrieving all photos by taskId
router.get('/task/:taskId', photoController.getPhotosByTaskId);

// Route for retrieving all photos by taskId
router.get('/user/:userId', photoController.getPhotosByUserId);
// Route for retrieving all photos
router.get('/', photoController.getAllPhotos);
// Route for deleting all photos
router.delete('/', photoController.deleteAllPhotos);
// Route for deleting photos by user ID
router.delete('/user/:userId', photoController.deletePhotosByUserId);
// Route for deleting photos by task ID
router.delete('/task/:taskId', photoController.deletePhotosByTaskId);
module.exports = router;
