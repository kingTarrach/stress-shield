# Sprint 1 Report (8/26/21 - 10/5/2024)

## What's New (User Facing)
 * Register and login functionality
 * Stores users information in the Firebase Database

## Work Summary (Developer Facing)
In preparation for the implementation, we had to do some project planning. First, we defined our competitors and how our app stands out from them. Next, we defined what our technical requirements were and what our nontechnical requirmenets were. To aid this, we also created a Use-Case diagram that showed all the actors and features of our app and how they are all related to each other. We also began to learn about how to code in Swift since it will be our primary language used for the app. Once we had prepared all of this information, we began to work on our first feature.
Our first feature that we developed was allowing users to register an account and saving their information to a database. To do this, we first developed Login view and corresponding view model for functions. User is able to input email address and password, or they can create an account if they are a new user. Then, developed register view and corresponding view model for functions. Linked "Create an Account" button to go to register view. In the register view, the user is able to enter their full name, email, and password to create an account. The program checks to make sure user enters password with at least 6 characters, and it checks if the email contains an "@" and ".". User information is stored in a Firebase database for now until client provides us with a database. User is able to log out from a profile view where their name and email are displayed. 

## Unfinished Work
Work we were unable to finish in this sprint included the creation of training for administrators, the pairing and collecting of data from a smart watch, and the display of health and stress data to the user. For the first, our group simply didn't have time to finish this requirement and are still deliberating on the best format. For the second, per the client's specification our code is meant to utelize the functionality of an Apple Watch. We are still learning about the watch's WatchKit and HealthKits which are required to collect data from the watch. Additionally, Apple watches run exclusively off of Swift and are difficult to test or simulate with a Mac environment, of which our group only has one. Our efforts so far have been focused elsewhere as we learn more. The final issue that is unfinished is due to the previous issue not being completed. While it's possible to forcefully simulate the displaying of health data, we still are learning of the formats in which health data is recorded and exported.

## Completed Issues/User Stories
Here are links to the issues that we completed in this sprint:

 * https://github.com/kingTarrach/stress-shield/issues/1
 * https://github.com/kingTarrach/stress-shield/issues/2
 
 ## Incomplete Issues/User Stories
 Here are links to issues we worked on but did not complete in this sprint:
 
 * https://github.com/kingTarrach/stress-shield/issues/3 We are still working on the formatting of each screen.
 * https://github.com/kingTarrach/stress-shield/issues/5 We are still reading through the documentation of how to access device data and use it on our app.
 * https://github.com/kingTarrach/stress-shield/issues/8 We did not get to this issue because we don't have access to the data that we need to visualize from the smartwatch device.
 

## Code Files for Review
Please review the following code files, which were actively developed during this sprint, for quality:
 * LoginView.swift https://github.com/kingTarrach/stress-shield/blob/main/StressShield/StressShield/Views/LoginView.swift
 * LoginViewVM.swift https://github.com/kingTarrach/stress-shield/blob/main/StressShield/StressShield/ViewModels/LoginViewVM.swift
 * RegisterView.swift https://github.com/kingTarrach/stress-shield/blob/main/StressShield/StressShield/Views/RegisterView.swift
 * RegisterViewVM.swift https://github.com/kingTarrach/stress-shield/blob/main/StressShield/StressShield/ViewModels/RegisterViewVM.swift
 
## Retrospective Summary
Here's what went well:
  * Login/Register User UI
  * Adding users to the Firebase 
  * Defining the specifications and Use case diagrams
 
Here's what we'd like to improve:
   * Defining what OS we will use for development/deployment 
  
Here are changes we plan to implement in the next sprint:
   * Adding watch functionality
   * Adding course functionality
   * Creating data visualizations for users' health data
