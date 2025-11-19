
<p align="center">
  <img width="300" height="200" alt="image" src="https://github.com/user-attachments/assets/69f9251c-1c12-4b86-a194-aef5576b58aa" />
</p>

<h1 align="center">2025-Prek</h1>

<div align="center">
  
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.io)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)

</div>

## Contents
- [Project description](#project-description)
- [Stakeholders](#stakeholders)
- [User Stories](#user-stories)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Architecture Diagram](#architecture-diagram)
- [User Instructions](#user-instructions)
- [Developer Instructions](#developer-instructions)
- [Internal Links](#internal-links)
- [Team Members](#team-members)

## Project Description  
**Prek** is a wellbeing application designed to help users cultivate mindfulness and positivity through guided reflection exercises. 
The application encourages users to focus on gratitude and intentional living by providing structured daily prompts and journaling features that promote positive thinking and emotional balance.   

The **goal** of Prek is to create a simple, reflective, and uplifting digital space that helps users cultivate gratitude, mindfulness, and intentional living. By providing structured prompts and seamless journaling features, the project aims to empower users to recognise positive moments, manage stress, and enhance their sense of wellbeing over time. 

**Main functionality**:
- Providing different affirmations every day
- Write daily reflections
- View past entries

## Stakeholders
- **Individual Client**: The project owner who will oversee the general direction of the app and receive the final deliverables.

- **End Users**: The individuals seeking to enhance their mindfulness and general wellbeing by daily reflection and gratitude.

- **Student Team**: The group of programmers and designers responsible for designing and developing the application.

## User Stories
- As a **university student**, I want an outlet to record what I am grateful for after lectures, so that I am able to keep a positive mindset even when facing harder days, improve my mental health, and feel more at ease at university.
  
- As a **busy professional**, I want to get simple daily prompts that guide my gratitude reflections, so I can include mindfulness in my routine, establish a positive work-life balance, and enhance my concentration as well as mood at work.

- As **someone trying to improve my mental health**, I want to review my past entries, so I can reflect on the improvement of my mental state, identify trends in my growth, maintain motivation when faced with disappointments, and get a deeper grasp of the factors that influence my happiness.

## Releases

| Release        | Description                                               | Target Date | Status  |
|----------------|-----------------------------------------------------------|--------------|----------|
| **MVP**         | Core functionality for initial launch.                    | 20/11/2025   | Pending  |
| **Beta**        | Majority of functionality implemented.                    | 19/02/2026   | Pending  |
| **Final Release** | Full functionality and optimizations; ready for production. | 30/04/2026   | Pending  |

## Project Structure
- to be added

## Tech Stack  
- **Frontend** : Flutter
- **Backend**  : Supabase
- **Database** : PostgreSQL
  
## Architecture Diagram
<img width="1587" height="2245" alt="tech stack (1)" src="https://github.com/user-attachments/assets/f3dd7db0-8aab-4600-8634-5b9c3c9f9be9" />

## User Instructions
1. Login
    - Enter your email and password then click Login.
    - You can sign in with Google by clicking the button.
    
2. Sign Up
   - Click the Sign Up button if you are a new user.
   - Enter your email.
   - Enter your password twice for verification process.
   - Click the Sign Up button and your account will be created.

3. Forgot Password
   - Click the Forgot Password button if you have forgotten your password.
   - Enter your email.
   - Enter your new password twice and click done.
   - It will be saved and you can now login with your new password.
  
4. Home Page
   - Once logged in, you will see a new affirmation everyday.
   - Click the Start Reflection button to write your reflection.
   - Click on the top left menu button to go to Profile, Settings and History Page.

5. Reflection Page
   - Enter your reflection in the reflection box.
   - Click the Save Reflection button to save it.
  
6. History Page
   - Your past entries will show up here with timestamps.

## Developer Instructions
1. Install [Flutter](https://docs.flutter.dev/install/manual)
2. In the terminal, clone this repository:
   
   ```
   git clone https://github.com/spe-uob/2025-Prek.git
   ```
3. In the terminal, install dependencies at the project root:

    ```
     flutter pub get
    ```
4. In the terminal, create .env file at the project root:
    ```
     touch .env
    ```
5. In the .env file, type in:
   
   ```
   SUPABASE_URL="YOUR_SECRET_KEY"
   SUPABASE_ANON_KEY="YOUR_ENCRYPTION_KEY"
   ```
6. In the .gitignore file, type in:

   ```
   .env
   ```
7. In the terminal, run the application:
   
   ```
   flutter run
   ```
   
## Internal Links
- [Kanban Board](https://github.com/orgs/spe-uob/projects/342)
- [License](https://github.com/spe-uob/2025-Prek/blob/a588db8ce4e40b9cb71dcd3317db70c8fcda09c1/LICENSE)
- Ethics
- AI document
  
## Team Members 

| Members        | Email                |
|----------------|----------------------|
| Carol Tan      |pn24594@bristol.ac.uk |
| Daud Ismail    |kk24104@bristol.ac.uk |
| Layan Alaskar (Client Liaison)  |pk23085@bristol.ac.uk |
| Ziqian Zhang   |ni24790@bristol.ac.uk |

| Week        | Project Manager      |
|-------------|----------------------|
| 2-7         |Layan Alaskar         |
| 8-12        |Daud Ismail           |
|13-18        | |
|19-24        | |
