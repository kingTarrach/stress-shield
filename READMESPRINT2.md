
# StressShield

## Project summary

### One-sentence description of the project

StressShield is an application designed to help front-line workers and first responders track stress and access stress resilience training to improve their well-being and performance.

### Additional information about the project

StressShield empowers front-line workers and first responders by offering an easy-to-use platform that helps them monitor stress levels through health data tracking, and provides access to stress resilience training. The app integrates with iOS health data to gather relevant metrics such as heart rate variability and sleep patterns, and offers tailored training to build stress resilience. The app's goal is to support those who experience high-stress environments, improving both personal health and professional performance.

## Installation

### Prerequisites

- Xcode (latest stable version recommended)
- iOS device or Simulator for testing
- A smart watch that has been recording health data in the user's Health app

### Add-ons

Currently, there are no add-ons included in the project.

### Installation Steps

To run our code:

- Clone the repository
- Open the project in XCode
- Build and run the project with XCode


## Functionality

- User Authentication: Users can either sign up or log in using their credentials immediately upon opening app.
- Health Data Access: After logging in, users are prompted to give permission to access their health data (e.g., heart rate, sleep data).
- Data Display: Once permission is granted, users can view their health data in the app.
- Training Access: Users can access stress resilience training modules to learn how to manage stress more effectively through a path-based training system accessed through menu selection.
- Health Data Insights: Users can view detailed insights into their health data and progress over time through menu selection.

## Known Problems

- Currently having some intermittent issues with healtdata code on old XCode versions. To reproduce, attempt to compile reversion code on xcode 12.4.