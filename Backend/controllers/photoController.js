// controllers/photoController.js

const Photo = require('../models/photo');

exports.uploadPhoto = async (req, res) => {
  try {
    const { taskId, userId, action, imageData } = req.body;

    // Validate the base64 data
    if (!imageData || !/^data:image\/[a-z]+;base64,/.test(imageData)) {
      return res.status(400).json({ error: 'Invalid image data.' });
    }

    const newPhoto = new Photo({
      taskId,
      userId,
      imageData,
      action,
    });

    await newPhoto.save();
    res.status(200).json({ message: 'Photo uploaded successfully.' });
  } catch (error) {
    res.status(500).json({ error: 'Error saving photo metadata.' });
  }
};

exports.getPhoto = async (req, res) => {
  try {
    const { id } = req.params;
    const photo = await Photo.findById(id);

    if (!photo) {
      return res.status(404).json({ error: 'Photo not found.' });
    }

    // Send the base64 data as a response
    res.status(200).json({ imageData: photo.imageData });
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving photo.' });
  }
};

exports.getPhotosByTaskId = async (req, res) => {
  try {
    const { taskId } = req.params;
    const photos = await Photo.find({ taskId });

    if (!photos || photos.length === 0) {
      return res.status(404).json({ error: 'No photos found for this task.' });
    }

    res.status(200).json(photos);
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving photos.' });
  }
};

exports.getPhotosByUserId = async (req, res) => {
  try {
    const { userId } = req.params;
    const photos = await Photo.find({ userId });

    if (!photos || photos.length === 0) {
      return res.status(404).json({ error: 'No photos found for this user.' });
    }

    res.status(200).json(photos);
  } catch (error) {
    res.status(500).json({ error: 'Error retrieving photos.' });
  }
};

///////////////////////////////////////////////////////////////////////////////////
exports.getAllPhotos = async (req, res) => {
    try {
        
        const photos = await Photo.find({});
    
        if (!photos || photos.length === 0) {
          return res.status(404).json({ error: 'No photos found.' });
        }
    
        res.status(200).json(photos);
      } catch (error) {
        res.status(500).json({ error: 'Error retrieving photos.' });
      }
  };
  exports.deleteAllPhotos = async (req, res) => {
    try {
        await Photo.deleteMany({});
        res.send({ message: 'All photos deleted successfully' });
      } catch (error) {
        res.status(500).send(error);
      }
  };

  exports.deletePhotosByUserId = async (req, res) => {
    const { userId } = req.params;
  
    try {
        await Photo.deleteMany({userId});
        res.send({ message: 'All photos deleted successfully' });
      } catch (error) {
        res.status(500).send(error);
      }
  };

  exports.deletePhotosByTaskId = async (req, res) => {
    const { taskId } = req.params;
  
    try {
        await Photo.deleteMany({taskId});
        res.send({ message: 'All photos deleted successfully' });
      } catch (error) {
        res.status(500).send(error);
      }
  };