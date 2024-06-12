# Welcome to Cheney Mobile App
## Project summary
A mobile app to help connect the citizens of Cheney to their community.

"Welcome to Cheney" is a non-profit organization with a vital mission: to enhance community engagement and communication within the city of Cheney. Recognizing the challenges of disseminating timely and accurate information to residents through conventional social media channels, which often result in vital updates being lost amidst the digital noise, the organization has embarked on an ambitious project. The development of a dedicated mobile application aims to establish a direct, reliable communication channel to keep the Cheney community informed and connected.

# Cheney Mobile App: Developer Documentation

## How to Run

### Prerequisites
- **Windows Machine**: Required for running Android Studio to test the app on Android devices.
- **Mac Machine**: Required for running Xcode to test the app on iOS devices.
- **Flutter**: The framework used to develop the app.
- **Visual Studio Code**: The IDE used for programming.
- **Android Studio**: Needed to generate the Android emulator.
- **Xcode**: Needed to run the iOS Simulator.

### Installation Steps

#### Setting Up Your Development Environment

1. **Windows Machine**:
    - Install **Visual Studio Code**, **Flutter**, and **Android Studio**.
    - Follow this [setup video](https://www.youtube.com/watch?v=VFDbZk2xhO4&list=PLCC34OHNcOtpx9qCZNvNbIT1Gx3BAOku) for a step-by-step guide.

2. **Mac Machine**:
    - Install **Flutter** and **Xcode**.
    - Follow this [setup video](https://www.youtube.com/watch?v=KdO9B_CZmzo) for detailed instructions.

3. **Learn Flutter and Dart**:
    - Familiarize yourself with the Flutter framework and Dart programming language.
    - Watch this [Flutter Widgets video](https://www.youtube.com/watch?v=HbzUzEg8Aqc&list=PLCC34OHNcOto7WU2QzVn3hnpSOYEdflVf) to understand the basics.

### Obtaining the Source Code

1. **Clone the Repository**:
    - Navigate to our GitHub repository: [Cheney Mobile App Repo](https://github.com/CSCD488-Winter2024/senior-project-the-a-team)
    - Download the repository locally using your preferred IDE (VSCode or Xcode).

2. **Select a Branch**:
    - Choose the branch you want to work on. For first-time users, start with the `main` branch.

### Building and Running the Software

1. **Start the Emulator**:
    - Follow the videos from the setup section to boot up the appropriate emulator (Android or iOS).

2. **Run the Application**:
    - Open `main.dart` in Visual Studio Code.
    - Right-click on `main.dart` and select "Run Without Debugging".

### Directory Structure Overview

- **.vscode**: Configuration files for Visual Studio Code.
- **flutter**: Contains the `wtc` folder, where the main codebase is located.
    - **wtc**:
        - **android**: Android-specific files and icons.
        - **functions**: Contains `index.js` for Firebase functions (push notifications, admin functions).
        - **images**: Stores app images.
        - **ios**: iOS-specific files and icons.
        - **lib**: Main components of the app.
            - **accountPages**: User account-related pages.
            - **auth**: User registration, login, and account management.
            - **components**: Reusable widgets like buttons and text fields.
            - **intro_screens**: Initial pages shown to new users.
            - **pages**: Main application pages.
            - **services**: Handles Single Sign-On for Google and Apple.
            - **user**: Stores global user information.
            - **widgets**: Various widgets used throughout the app.
            - **app.dart**: Routing for all pages.
            - **firebase_options.dart**: Device-specific information for Firebase.
            - **main.dart**: Entry point for the app.
        - **pubspec.yaml**: Contains all dependencies for the app.

### Testing

- We used a "behavior driven testing" approach. Each task was broken down into small parts, implemented, and tested individually by the developer before making a pull request.
- Another developer would then test the feature and approve the pull request if it passed.

### Deployment

- We are working on deploying the app to both the Google Play Store and the Apple App Store.
- **Google Play Store Deployment**: Follow this [guide](https://www.youtube.com/watch?v=Jk4X3EDXi7s&t=202s).
- **Apple App Store Deployment**: Follow this [guide](https://www.youtube.com/watch?v=0zgDF81ZLrQ&t=651s).

## Known Problems
None currently.
## Additional Documentation
* [Flutter installation](https://docs.flutter.dev/get-started/install)
* [Developer Documentation](https://github.com/CSCD488-Winter2024/senior-project-the-a-team/blob/Calendar_fix/Developer_Documentation.pdf)
* [Comprehensive Tutorial](https://www.youtube.com/watch?v=tIm3mtmqK-s)
## License
MIT license: https://choosealicense.com/licenses/mit/
