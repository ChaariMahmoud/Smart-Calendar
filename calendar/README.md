# IA Calendar

**IA Calendar** is an innovative mobile application developed using Flutter 3.22. Designed for intelligent task management, IA Calendar offers a modern interface with advanced features that streamline and personalize daily task management.

## Key Features

- **Cross-Platform**: Developed with Flutter, IA Calendar delivers a high-quality, multi-platform experience with a single codebase.
- **MVC Architecture**: The app is structured using the MVC pattern, ensuring clear separation of responsibilities and ease of maintenance.
- **State Management with GetX**: Efficient, reactive state management enables seamless interaction between various components.
- **Task Management**: Users can create, modify, and delete tasks with comprehensive details including title, note, task type, date, start and end times, and priority and difficulty indicators. Tasks are visually organized by date and color-coded for readability.
- **Progress Tracking**: Each task includes a progress bar, allowing users to track real-time progress.
- **Local Storage with SQLite**: Local storage is optimized with SQLite, ensuring tasks are saved even during temporary loss of connection.
- **Customization**: Offers light/dark mode options and allows users to personalize notifications and task categories.
- **Network Status**: Notifies users of their connection status (online/offline).
- **User Authentication**: Secure login, registration, and password reset via OTP with additional fingerprint login support.
- **AI-Powered Scheduling**: Automatically schedules tasks based on priority, difficulty, and user productivity data collected from a daily form.
- **OCR Integration**: Extracts tasks from calendar photos using advanced OCR technology via an API built with Flask and EasyOCR. Includes image cropping functionality to ensure optimal OCR results.
- **Notification Service**: Alerts users when a task time starts, even if the app is not running.
- **Profile Management**: Users can upload their profile photo, change their name, and update their password.
- **Stay Signed In & Biometric Login**: Provides a "Stay signed in" option at login, and supports fingerprint login for Android and Face ID for iOS.
- **Backend**: Built with Node.js 20, using MongoDB for user and task data storage, JWT for secure authentication, and email OTP for password resets. The backend is hosted on Google Cloud Platform (GCP).

## Installation

### Prerequisites

Ensure you have the following installed on your system:

- **Flutter 3.22** (or the latest stable version)
- **Dart SDK**
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **Git** (for version control)

### Installing Flutter on Windows

1. **Download Flutter SDK**: 
   - Visit [Flutter's official website](https://flutter.dev) and download the latest stable version for Windows.
   
2. **Extract and Set Path**:
   - Extract the downloaded ZIP file to your preferred directory (e.g., `C:\src\flutter`).
   - Add Flutter to the environment path:
     - Search for "Environment Variables" in the Windows search bar.
     - Under "System variables," select "Path," and click "Edit."
     - Click "New" and add the path to the `flutter\bin` directory.

3. **Install Required Dependencies**:
   - Run `flutter doctor` in your terminal to check for dependencies and install any missing components.

4. **Install Android Studio**:
   - Download and install [Android Studio](https://developer.android.com/studio).
   - Open Android Studio and go to **Tools > SDK Manager** to install the necessary SDK platforms and tools.
   - Set up an Android emulator or connect a physical device.

5. **Run Flutter Doctor**:
   - Open the terminal and run `flutter doctor` to ensure everything is set up correctly.

### Installing Flutter on Linux

1. **Download Flutter SDK**:
   - Visit [Flutter's official website](https://flutter.dev) and download the latest stable version for Linux.

2. **Extract and Set Path**:
   - Extract the downloaded TAR file to your preferred directory (e.g., `/home/yourusername/flutter`).
   - Add Flutter to the environment path:
     - Open a terminal and run:
       ```bash
       export PATH="$PATH:`pwd`/flutter/bin"
       ```
   - To make this change permanent, add the export command to your `~/.bashrc` or `~/.zshrc` file.

3. **Install Required Dependencies**:
   - Run `flutter doctor` in your terminal to check for dependencies and install any missing components.

4. **Install Android Studio**:
   - Download and install [Android Studio](https://developer.android.com/studio).
   - Open Android Studio and go to **Tools > SDK Manager** to install the necessary SDK platforms and tools.
   - Set up an Android emulator or connect a physical device.

5. **Run Flutter Doctor**:
   - Open the terminal and run `flutter doctor` to ensure everything is set up correctly.

## Running the App

1. **Clone the Repository**:
   - Use Git to clone the IA Calendar repository:
     ```bash
     git clone https://github.com/yourusername/IACalendar.git
     cd IACalendar
     ```

2. **Get Dependencies**:
   - Run the following command to get all the necessary dependencies:
     ```bash
     flutter pub get
     ```

3. **Run the App**:
   - Connect your Android/iOS device or start an emulator.
   - Run the app using the following command:
     ```bash
     flutter run
     ```

## Conclusion

IA Calendar is your ultimate tool for intelligent task management. With its advanced features and AI-driven capabilities, managing your tasks has never been easier or more efficient.
