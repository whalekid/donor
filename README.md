# Donor
An iOS demo app that provides passing a health test а for a blood donor, creating an appointment for blood donation and tracking a condition of a current appointment.

<p align="center">
  <img src="https://media.giphy.com/media/gFX7GdPFSZgQNAGftb/giphy.gif">
</p>

## Features
- [X] Walkthrouh onboarding is included 
- [X] Authentification is provided by Firebase Auth.
- [X] An authorized user is provided with his personal profile screen, which contains an actual information about the user including a name, an avatar, rhesus, blood type and history of donations. 
- [X] The user can take a test for health reasons to find out if he can become a donor.
- [X] After successfully passing the test, the user can set the date and place of donation, or postpone the recording, but the test results will be saved.
- [X] After making an appointment for a donation, the user will receive personalized nutritional recommendations, depending on the number of days remaining before the donation.
- [X] The user will receive reminder notifications one day and 2 hours before the donation.
- [X] After donating blood, the record will be saved in the donation history, which the user can view on the profile screen.
## Description

This app has an MVC architecture with multiple screens. Custom UI is made with storyboards.

### User Interface Modules:
* `Authentification`: This module provides authentification features via Firebase Authentification Service and contains  `AuthViewController`,  `RegistrationViewController` and  `AuthorizeViewController`. 
- `AuthViewController` provides the user to register or authorize. 
- `RegistrationViewController` provides the user to register and make an request Firebase via  `FirebaseAuthService`.
- `AuthorizeViewController` provides a user to authorize via `FirebaseAuthService`.

<p align="middle">
<img src="https://media.giphy.com/media/vyOKOHHSudf2oUtoBu/giphy.gif">
  <img src="https://media.giphy.com/media/NGsK8SweNleMQvdub6/giphy.gif"> 
</p>

* `InitialControllers`: is a module of tab bar screens. Contains  `StartViewController`,  `ReccomendViewController`,   `ProfileViewController` and `DonationTableVC`. 
- `StartViewController` is a main screen for the authorized user. It checks if the user has some current donation appointment, if one has it calculates the time before an appointment and presents an actual appointment reminder screen. Otherwise, it suggests to pass the health test and make a new appointment. 
- `ReccomendViewController` contains some static general information for donors with basic recommendations and restrictions.

<p align="center">
  <img src="https://media.giphy.com/media/n4jutx7VnwWkIttIos/giphy.gif">
</p>

- `ProfileViewController` provides a user information including name, avatar, bloodtype and rhesus, current donation date and a clickable count of passed donations.

<p align="center">
  <img src="https://media.giphy.com/media/6S7And6yP73xmcOzlF/giphy.gif">
</p>

- `DonationTableVC` would shows when the count label is tapped. Shows a tableview with the donation history.

* `TestResponds`: This module provides a health test and creating an appointment features, it contains  `TestViewController`,  `NegativeRespondViewController` and  `PositiveRespondViewController`. 
- `TestViewController` contains some static general information for donors with basic recommendations and restrictions. Fields of answers to questions are descendants of the custom class `CornerButton`, in the screen area there is a method for listening to user actions, which monitors so that the same question cannot be answered simultaneously "yes" and "no", which is necessary for the implementation of the function of an unambiguous answer to the question. Thus, if at the moment before that the user inadvertently answered “yes”, then when you press “no”, the checkbox from the answer “yes” will be instantly removed and reassigned to the “no” field.

<p align="center">
  <img src="https://media.giphy.com/media/XLYptI0TuD5YssGd2g/giphy.gif">
</p>

- `NegativeRespondViewController`: With at least one positive answer, the user will not be allowed to donate blood and a special screen will open with a notification that for health reasons he cannot be allowed to donate blood, he is invited to familiarize himself with the general recommendations for donating blood.

<p align="center">
  <img src="https://media.giphy.com/media/cjQCIl12nr7TzGq3ca/giphy.gif">
</p>

- `PositiveRespondViewController` After successfully passing the test, the user can set the date and place of donation, or postpone the recording, but the test results will be saved. If the user made an appointment, `FirebaseService` provides the creation of a new donation instance in the Firestore Database for the user.

<p align="center">
  <img src="https://media.giphy.com/media/hiv4QFD7IVhyyEnFnB/giphy.gif">
</p>

* `Timers`: This module provides a reminder screen of current donation appointment, it contains  a few variations of `TimerViewController` and a `DidFinishViewController` . It also provides timer protocols such as `TimerProtocol` and `DonationDateCalculatorProtocol`   . 

<p align="center">
  <img src="https://media.giphy.com/media/iRB9kiqYaAoBb8mLkp/giphy.gif">
</p>

- `TimerViewController`: Current donation reminder screen with a counter of days before donation and recommendations proposed for a specific day before donation.
- `DidFinishViewController`: When the current donation has passed, the application congratulates the user on a successful donation by showing the corresponding screen and updating the donation counter in the profile.
- `TimerProtocol` contains { get set } property of `FirebaseService` and requires an implementation of updating a donation reminder screen and removing the current donation appointment.
- `DonationDateCalculatorProtocol` works with calendar and events, calculates the current donation appointment date and shows the proper screen of donation reminder.

### Models:
* `UserSettings`: A class that provides storing user settings with UserDefaults .
* `Donation`: NSObject NSCoding struct that stores encoded donation properties.
* `BloodRhesus`: NSObject NSCoding struct that stores encoded properties about user's blood type and rhesus.
* `Avatar`: A singleton that stores  FileManager's link for a user profile picture.

### Networking:
* `FirebaseAuthService`: provides the creation of user.
* `FirebaseService`: fetches the data from FireStore Database that is passed by controllers, updates the documents with changes in user information and creates new donations for the user.
* `AuthError`: provides the enum of authentification errors with descriptions .
* `Validators`: implements the check of filled fields on the authentification stage.

## Future Development.

- Unit tests would help to provide stability for an app perfomance.
- MVC architecture is a quite poor choice, so it would be great to refactor with an other architecture pattern such as VIPER or MVVM.
- Storyboard causes too many build problems and it slows down the coding perfomance, Snapkit would provide a better perfomance. 

