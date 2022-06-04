# ModernGyan
- Web Application developed for online learning of Engineering courses and topics from different mentors at a prefered time slot on the prefered platform.
- The project was built in Java using HTML, CSS, JavaScript, JSP, and SQL while learning Advanced Java (web).

## Aim
The main aim of this project is to build a platform where Engineering Students can learn Engineering related sujects and topics live from their prefered mentors (based on the ratings) on their prefered time slot. Students can search through various courses according to their engineering branch, whether it might be a subject or a mere topic of a particular subject. The teachers are verified by the admin on their registration and then approved or rejected. Teachers can update their comfortable timings and subjects on their profile.

## Prerequisites
- Java jdk 8 or above
- Apache Tomcat (version 9) local server
- Eclipse IDE for Java
- MySQL jdbc connector for connecting SQL with jdbc driver
- and XAMPP for database (SQL)

## Run Project
- Start XAMPP for Apache HTTP Server, MariaDB database.
- Start Tomcat9 Daemon Servuce manager.
- Load your project on [localhost:8080](http://localhost:8080).

- You can view your database on [phpmyadmin](http://localhost/phpmyadmin/).

## Feature & Functions

### Student/Faculty Panel

#### Student/Faculty Login Page
Login Page for students and faculty. There is also an option for New users to register.
![Student/Faculty LoginPage](SiteImages/Student_Faculty_LoginPage.png)

#### Student Registration Page
Students can register immediately as soon as they fill all the details.
![Student Registration Page](SiteImages/StudentRegister.png)

#### Faculty Registration Page
Faculty members are verified by the Admin after there registration is complete.
![Faculty Registration Page](SiteImages/FacultyRegister.png)
![Faculty Registration Page](SiteImages/FacultyRegister2.png)

#### Registration Success Login Page
![Registration Success](SiteImages/RegisterSuccess.png)

#### Home Page
Home Page Without Login -
![Home Page](SiteImages/HomePage.png)

### Student Panel

#### Student Home Page
Displays student's Upcoming, Ongoing & Finished courses, and top 5 subjects & top 5 topics from his/her branch.
![Student Home Page](SiteImages/StudentHomePage.png)

#### Find Coruse Page
Lets user filter subjects and topics branch-wise, and also users can search directly from SearchBar.
![Find Course Page](SiteImages/FindCoursePage.png)

#### Course Enroll Page
Shows details about the chosen course along with faculties available for the same. Student can select the timing slot and platform for learning the course from a particular faculty.
![Course Enroll Page](SiteImages/CourseEnrollPage.png)

#### Course Enrollment Success Message
Displays the message for successful enrollment in the course.
![Enrollment Successful Message](SiteImages/EnrollSuccess.png)


### Faculty Panel

#### Faculty Home Page
Displays Upcoming, Ongoing & Completed courses by the faculty. And also displays a panel where the faculty can update his/her preferences.
![Faculty Home Page](SiteImages/FacultyHomePage.png)
![Faculty Home Page](SiteImages/FacultyHomePage2.png)

#### Faculty Profile Page
Displays faculty's profile and preferences and a means to update his/her profile details.
![Faculty Profile Page](SiteImages/FacultyProfilePage.png)
![Faculty Profile Page](SiteImages/FacultyProfilePage2.png)


### Admin Panel

#### Admin Login Page
Login Page for admins.
![Admin Login Page](SiteImages/AdminLoginPage.png)

#### Admin Home Page
It displays:-
- Total number of registered & active students from each branch and total number of faculties present.
- Faculty brief profiles.
- And a SearchBar to search faculties

![Admin Home Page](SiteImages/AdminHomePage.png)
![Admin Home Page](SiteImages/AdminHomePage2.png)
![Admin Home Page](SiteImages/AdminHomePage3.png)

#### Admin - Faculty Profile view Page
For viewing the general profile of faculties.
![Faculty Profile View Page](SiteImages/FacultyProfileViewPage.png)
![Faculty Profile View Page](SiteImages/FacultyProfileViewPage2.png)

#### Add Admin Page
Admins can make another admin here.
![Add Admin Page](SiteImages/AddAdminPage.png)

Admin Added Successful message
![Admin Added Successfully Message](SiteImages/AddAdminSuccess.png)

#### Add Branch Page
Admins can add a branch to the database here.
![Add Branch Page](SiteImages/AddBranchPage.png)

Branch Added Successful message
![Branch Added Successfully Message](SiteImages/AddBranchSuccess.png)

#### Add Subject Page
Admins can add a Subject to the database here.
![Add Subject Page](SiteImages/AddSubjectPage.png)

Subject Added Successful message
![Subject Added Successfully Message](SiteImages/AddSubjectSuccess.png)

#### Add Topic Page
Admins can add a Topic of a particular subject to the database here.
![Add Topic Page](SiteImages/AddTopicPage.png)

Topic Added Successful message
![Topic Added Successfully Message](SiteImages/AddTopicSuccess.png)

#### Request Page
All the students course enrollment request shows here. From here admin can either accept it or reject it.
![Request Page](SiteImages/RequestPage.png)
