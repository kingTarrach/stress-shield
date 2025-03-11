# Sprint 3 Report (Dates from 11/5 to 12/5)

## https://youtu.be/02avuuknyg8

## What's New (User Facing)
 * Redesigned profile view and added a logout button at the bottom of the screen
 * Created a a calendar view to display and schedule lessons in a user-friendly list format. (deprocated)
 * Integrated HealthKit to pull health data from Apple Watch for real-time stress tracking.
 * Refined lesson tracking functionality, simplifying navigation and enhancing the user experience.

## Work Summary (Developer Facing)
During this sprint, our team focused on refining existing features based on client feedback and implementing new functionality. We added the profile view to display a placeholder for what the profile view might look like with a logout button at the bottom. Our client originally wanted a social media type of profile, however, they have told us they don't want that anymore. The calendar view was originally requested by the client in their prototype, but has now been deprocated. Additionally, we began inegrating HealthKit, overcoming challenges with permissions and data parsing to successfully pull health data from Apple Watch. We have had troubles getting started, as only one of us had a Mac to start, however, we believe next semester we'll be ready to hit the ground running and make far greater progress we made this semester.

## Unfinished Work
We now have an AWS server set up to support backend functionalities, including lesson storage and management. While the server has been successfully configured, we were unable to fully implement lesson creation and integration with the app in this sprint. This includes functionality for saving lessons to the AWS server, retrieving them dynamically, and ensuring smooth interaction between the frontend and backend.
This work has been added as a priority for the next sprint and will involve creating lessons, connecting the lesson tracking system to the server, and testing the backend’s reliability and scalability.

## Completed Issues/User Stories
Here are links to the issues that we completed in this sprint:

 * https://github.com/kingTarrach/stress-shield/issues/9
 * https://github.com/kingTarrach/stress-shield/issues/5

 ## Incomplete Issues/User Stories
 Here are links to issues we worked on but did not complete in this sprint:
 
 * https://github.com/kingTarrach/stress-shield/issues/6 <<We have not had access to an AWS server until recently>>
 * https://github.com/kingTarrach/stress-shield/issues/4 <<We have not had the time yet>>
 * https://github.com/kingTarrach/stress-shield/issues/4 <<We have not had access to an AWS server until recently, but we have a template as of now>>
 
## Code Files for Review
Please review the following code files, which were actively developed during this sprint, for quality:
 *[ProfileView.swift](https://github.com/kingTarrach/stress-shield/blob/home_screen/StressShield/StressShield/Views/ProfileView.swift)
 * [TemporaryHealthView.swfit](https://github.com/kingTarrach/stress-shield/blob/healthkit/StressShield/StressShield/Views/TemporaryHealthView.swift)
 * [CalendarView.swift](https://github.com/kingTarrach/stress-shield/blob/home_screen/StressShield/StressShield/Views/CalendarView.swift)
 
## Retrospective Summary
Here's what went well:
  * The team successfully implemented significant client-requested changes, such as the redesigned profile view and the replacement of the calendar feature.
  * Integration of HealthKit provided a strong foundation for stress tracking.
  * Improved team collaboration and communication when troubleshooting navigation and UI issues.
 
Here's what we'd like to improve:
  * Time management for feature implementation, particularly for more complex features like progress tracking.
  * More thorough testing during development to catch navigation and data display bugs earlier in the process.
  
Here are changes we plan to implement in the next sprint:
  * Complete the lesson progress tracking feature, ensuring seamless integration with the user profile and lesson views.
  * Implement real lessons from our server that the user is able to work through
  * Begin implementing notification reminders for upcomming lessons
  * Conduct usability testing to refine navigation and layout further.
