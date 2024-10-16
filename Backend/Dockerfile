# Use the official Node.js 20 image from Docker Hub as the base image
FROM node:20.18.0

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port that your application will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
