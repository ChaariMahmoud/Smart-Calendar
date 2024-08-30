# IA Calendar Backend

This folder contains the Node.js backend code for the IA Calendar app. The backend provides a robust and secure API for managing users, tasks, surveys, and photos.

## Table of Contents

- [Technologies](#technologies)
- [Installation](#installation)
- [Installing MongoDB on Linux](#installing-mongodb-on-linux)
- [Environment Variables](#environment-variables)
- [Running the Server](#running-the-server)
- [API Routes](#api-routes)
- [Middlewares](#middlewares)
- [Contributing](#contributing)

## Technologies

This project is built with the following technologies:

- Node.js
- Express: Web framework for Node.js
- MongoDB: NoSQL database
- Mongoose: ODM for MongoDB
- JWT: Secure user authentication
- Nodemailer: Sending emails
- Multer: Middleware for handling `multipart/form-data` for file uploads
- GridFS: Storing and retrieving large files within MongoDB
- dotenv: Loading environment variables

## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/ChaariMahmoud/Smart-Calendar.git
    ```

2. Navigate to the backend folder:

    ```bash
    cd Smart-Calendar/Backend
    ```

3. Install the dependencies:

    ```bash
    npm install
    ```

## Installing MongoDB on Linux

To install MongoDB on a Linux system, follow these steps:

1. Import the public key used by the package management system:

    ```bash
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    ```

2. Create a list file for MongoDB:

    ```bash
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    ```

3. Reload the local package database:

    ```bash
    sudo apt-get update
    ```

4. Install the MongoDB packages:

    ```bash
    sudo apt-get install -y mongodb-org
    ```

5. Start MongoDB:

    ```bash
    sudo systemctl start mongod
    ```

6. Verify that MongoDB has started successfully:

    ```bash
    sudo systemctl status mongod
    ```

7. Enable MongoDB to start on system reboot:

    ```bash
    sudo systemctl enable mongod
    ```

## Environment Variables

Create a `.env` file in the backend folder and add the following environment variables:

```env
PORT=3000
MONGO_URI=mongodb://127.0.0.1:27017/smart_calendar
JWT_SECRET=your_jwt_secret
EMAIL_SERVICE=your_email_service
EMAIL_USER=your_email@example.com
EMAIL_PASS=your_email_password
```

## Running the Server

Start the server by running:

```bash

npm start

```

The server will run on `http://0.0.0.0:3000` or the port specified in the `.env` file.

## API Routes

### Authentication Routes

- POST `/api/auth/register`: Register a new user

- POST `/api/auth/login`: Log in a user

- POST `/api/auth/send-otp`: Send OTP for password reset

- POST `/api/auth/verify-otp`: Verify OTP for password reset

- POST `/api/auth/reset-password`: Reset user password

### Photo Routes

- POST `/api/photo/upload`: Upload a photo

- GET `/api/photo/:filename`: Retrieve a photo by filename

- GET `/api/photo/task/:taskId`: Retrieve all photos associated with a specific task ID

- GET `/api/photo/user/:userId`: Retrieve all photos associated with a specific user ID

- GET `/api/photo/`: Retrieve all photos

- DELETE `/api/photo/`: Delete all photos

- DELETE `/api/photo/user/:userId`: Delete all photos associated with a specific user ID

- DELETE `/api/photo/task/:taskId`: Delete all photos associated with a specific task ID

### Survey Routes

- POST `/api/surveys`: Create a new survey response

- GET `/api/surveys/:userId`: Retrieve survey responses by user ID

- GET `/api/surveys`: Retrieve all surveys

- DELETE `/api/surveys/:userId`: Delete surveys by user ID

- DELETE `/api/surveys`: Delete all surveys

### Task Routes

- POST `/api/tasks`: Create a new task

- GET `/api/tasks`: Retrieve all tasks

- GET `/api/tasks/:`: Retrieve a task by ID

- PUT `/api/tasks/:id`: Update a task by ID

- DELETE `/api/tasks/:id`: Delete a task by ID

- DELETE `/api/tasks`: Delete all tasks

- GET `/api/tasks/user/:userId`: Retrieve tasks by user ID

### User Routes

- POST `/api/users`: Create a new user

- GET `/api/users`: Retrieve all users

- GET `/api/users/:id`: Retrieve a user by ID

- PUT `/api/users/:id`: Update a user by ID

- DELETE `/api/users/:id`: Delete a user by ID

- DELETE `/api/users`: Delete all users

## Middlewares

- `auth.js`: Handles JWT authentication

- `error.js`: Global error handling middleware

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss potential changes.


