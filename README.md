# 💼 Job Finder App

A modern Flutter mobile application for searching and exploring job opportunities with clean UI, authentication, API integration, offline support, and responsive design.

---

## 📱 Features

🔐 User Authentication (Online + Offline)
🌐 API Integration (ReqRes API + MockAPI.io)
💼 Browse Job Listings
🔎 Search Jobs by title, company, location
🎯 Advanced Filters (Job Fields, Titles, Work Mode, Experience)
📱 Responsive Flutter UI
⚡ State Management (Provider)
🌙 Dark/Light Mode Toggle
📶 Offline Support (SQLite Database)
📎 Apply for Jobs with CV Upload
👤 Profile Management (Edit Profile & Preferences)

---

## 🛠️ Built With

Framework: Flutter 3.x
Language: Dart 3.x
State Management: Provider
Local Database: SQLite (sqflite)
Local Storage: SharedPreferences
Networking: HTTP Package
Animations: Lottie
Auth API: ReqRes.in
Jobs API: MockAPI.io

---

## 📂 Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_constants.dart
│   ├── themes/
│   │   └── app_theme.dart
│   └── utils/
│       ├── validators.dart
│       └── helpers.dart
├── data/
│   ├── local/
│   │   └── database_helper.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── job_model.dart
│   │   └── user_preferences_model.dart
│   └── remote/
│       ├── api_service.dart
│       └── job_api_service.dart
├── domain/
│   └── entities/
│       ├── user.dart
│       ├── job.dart
│       └── user_preferences.dart
└── presentation/
    ├── providers/
    │   ├── auth_provider.dart
    │   └── theme_provider.dart
    ├── screens/
    │   ├── splash_screen.dart
    │   ├── signin_screen.dart
    │   ├── signup_step1_screen.dart
    │   ├── signup_step2_screen.dart
    │   ├── signup_step3_screen.dart
    │   ├── home_screen.dart
    │   ├── profile_screen.dart
    │   ├── edit_profile_screen.dart
    │   └── apply_job_screen.dart
    └── widgets/
        ├── common/
        │   ├── custom_button.dart
        │   ├── custom_text_field.dart
        │   ├── loading_widget.dart
        │   └── error_widget.dart
        └── home/
            ├── home_header.dart
            ├── home_filters.dart
            ├── home_suggestions.dart
            ├── home_job_card.dart
            └── home_job_details_sheet.dart
```

---

## 🌐 API Endpoints

### Authentication API (ReqRes.in)

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| POST | https://reqres.in/api/register | User Registration | {"email": "eve.holt@reqres.in", "password": "cityslicka"} | {"id": 4, "token": "QpwL5tke4Pnpja7X4"} |
| POST | https://reqres.in/api/login | User Login | {"email": "eve.holt@reqres.in", "password": "cityslicka"} | {"token": "QpwL5tke4Pnpja7X4"} |
| GET | https://reqres.in/api/users | Get Users | ?page=1 | {"page": 1, "data": [...]} |
| GET | https://reqres.in/api/users/{id} | Get Single User | - | {"data": {"id": 2, "email": "..."}} |

### Jobs API (MockAPI.io)

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| GET | https://6a02decc0d92f63dd2545858.mockapi.io/jobs | Get All Jobs | - | [{"id": "1", "title": "..."}] |
| GET | https://6a02decc0d92f63dd2545858.mockapi.io/jobs/{id} | Get Single Job | - | {"id": "1", "title": "..."} |
| POST | https://6a02decc0d92f63dd2545858.mockapi.io/jobs | Create Job | {"title": "Flutter Dev", "company": "Google"} | {"id": "51", "title": "..."} |
| PUT | https://6a02decc0d92f63dd2545858.mockapi.io/jobs/{id} | Update Job | {"title": "Updated Title"} | {"id": "1", "title": "..."} |
| DELETE | https://6a02decc0d92f63dd2545858.mockapi.io/jobs/{id} | Delete Job | - | {} |

### Sample Job Data Structure

```json
{
  "id": "1",
  "title": "Senior Flutter Developer",
  "type": "Software Development",
  "company": "Google",
  "salary": "$140,000",
  "location": "Remote",
  "jobArea": "Mobile Development",
  "description": "Build cross-platform apps with Flutter",
  "requirements": "3+ years Flutter experience",
  "experience": "3 years",
  "postedDate": "2024-05-10"
}
```

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code
- Emulator or Physical Device

### Step 1: Clone Repository
```bashgit clone https://github.com/SanduniLK/JobFinderApp.git
cd JobFinderApp
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Run the Project
```bash
flutter run
```

### Step 4: Build APK (Android)
```bash
flutter build apk --release
```

### Step 5: Build IPA (iOS - Mac required)
```bash
flutter build ios --release
```

---

## 🔐 Credentials for Testing

### Online Mode (ReqRes API)

| Email | Password |
|-------|----------|
| eve.holt@reqres.in | Any |
| emma.wong@reqres.in | any_password |
| george.bluth@reqres.in | any_password |
| janet.weaver@reqres.in | any_password |
| michael.lawson@reqres.in | any_password |
| lindsay.ferguson@reqres.in | any_password |
| tobias.funke@reqres.in | any_password |
| byron.fields@reqres.in | any_password |
| george.edwards@reqres.in | any_password |
| rachel.howell@reqres.in | any_password |

### Offline Mode (SQLite)

| Field | Value |
|-------|-------|
| Email | ANY valid email (e.g., user@example.com) |
| Password | Minimum 6 characters |

> **Note:** Register first while online to use offline mode.

---

## 📱 App Flow Diagram

```
Splash Screen (3 seconds)
         ↓
   Check Auth Status
         ↓
    ┌────┴────┐
    ↓         ↓
Logged In  Not Logged In
    ↓         ↓
  Home      Sign In
              ↓
         Sign Up Step 1 (Basic Info)
              ↓
         Sign Up Step 2 (Job Preferences)
              ↓
         Sign Up Step 3 (Salary & Work Mode)
              ↓
            Home
```

---

## 📸 Screenshots

| Screen | Path |
|--------|------|
| Sign In Screen | assets/screenshots/signIn.jpeg |
| Sign Up Screen | assets/screenshots/signUpscreen.jpeg |
| Home Screen | assets/screenshots/home.jpeg |
| Filters Screen | assets/screenshots/filter.jpeg |
| Profile Screen | assets/screenshots/profile.jpeg |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  lottie: ^2.7.0
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2
  path: ^1.8.3
  http: ^1.1.0
  provider: ^6.1.1
  file_picker: ^6.1.1
  intl: ^0.18.1
```

---

## 🎨 UI Features

- Clean Modern Design with #01BEF9 color scheme
- Responsive Layout for all screen sizes
- Smooth Lottie animations
- Time-based greetings (Morning/Afternoon/Evening)
- Pull to Refresh
- Loading states and error handling
- Dark/Light mode support

---

## ✅ Features Checklist

| Feature | Status |
|---------|--------|
| User Registration (3-step) | ✅ |
| User Login (Online/Offline) | ✅ |
| Job Listing with Search | ✅ |
| Advanced Filters | ✅ |
| Job Details View | ✅ |
| Apply for Jobs with Form | ✅ |
| Profile Management | ✅ |
| Edit Profile | ✅ |
| Edit Job Preferences | ✅ |
| Dark/Light Mode | ✅ |
| Offline Support | ✅ |
| Logout Functionality | ✅ |
| Delete Account | ✅ |

---
## 📱 Download APK

<p align="center">
  <a href="https://drive.google.com/file/d/1Y_H2lwBZ-x9MA2H02biP_iL3s5N8QIjo/view?usp=sharing">
    <img src="https://img.shields.io/badge/Download_APK-00C853?style=for-the-badge&logo=android&logoColor=white" />
  </a>
</p>

<p align="center">
  <b>Version 1.0.0</b> | Size: ~25 MB | Android 5.0+
</p>

---

## 🤝 Contributing

1. Fork the Project
2. Create Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👩‍💻 Author

**Reshika Sanduni**

- Education: University Of moratuwa
- GitHub: [@SanduniLK](https://github.com/SanduniLK)


---

## 🙏 Acknowledgments

- [ReqRes.in](https://reqres.in/) - Mock authentication API
- [MockAPI.io](https://mockapi.io/) - Jobs API
- [Flutter Team](https://flutter.dev/) - Amazing framework
- [Google Fonts](https://fonts.google.com/) - Typography

---

## 📄 License

This project is for educational and learning purposes only.

---

<div align="center">

**💖 Made with Flutter by Reshika Sanduni**

**© 2026 Job Finder App | All Rights Reserved**

</div>
```

