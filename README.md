# 🚀 Job Finder App

A modern, offline-capable mobile application that helps job seekers find their dream jobs. Built with Flutter, this app features a beautiful UI, real-time job search, offline support, and complete authentication system.

## 📱 Project Overview

Job Finder is a comprehensive mobile application that allows users to:
- 🔐 **Register & Login** with online/offline support
- 📋 **Complete 3-step signup** with job preferences (job fields, titles, salary expectations, work mode)
- 🔍 **Search and filter jobs** by title, company, location, or job area
- 💼 **View detailed job information** and apply directly
- 👤 **Manage profile** with editable preferences
- 🌓 **Dark/Light mode** support
- 📶 **Smart online/offline mode** - uses ReqRes API when online, SQLite when offline

## 🛠️ Technology Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter (Cross-platform) |
| **Language** | Dart |
| **State Management** | Provider |
| **Local Database** | SQLite (sqflite) |
| **Local Storage** | SharedPreferences |
| **Networking** | HTTP package |
| **API** | ReqRes.in (Mock API) |
| **UI Approach** | Flutter Widgets (Custom) |
| **Animations** | Lottie |

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1        # State management
  sqflite: ^2.3.0          # SQLite database
  shared_preferences: ^2.2.2  # Local storage
  http: ^1.1.0             # API calls
  lottie: ^2.7.0           # Animations
  google_fonts: ^6.1.0     # Typography
  intl: ^0.18.1            # Date formatting
```

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/         # App colors, constants
│   ├── themes/            # Light/Dark themes
│   └── utils/             # Validators, helpers
├── data/
│   ├── local/             # SQLite database helper
│   ├── models/            # Data models
│   └── remote/            # API services
├── domain/
│   └── entities/          # Business entities
└── presentation/
    ├── providers/         # State management
    ├── screens/           # All UI screens
    └── widgets/           # Reusable widgets
```

## 🚀 Features

### Authentication
- ✅ Online registration with ReqRes API
- ✅ Offline registration with SQLite
- ✅ Persistent login session
- ✅ Logout functionality

### Job Management
- ✅ Browse jobs from MockAPI
- ✅ Search by title, company, location
- ✅ Filter by job fields and titles
- ✅ View job details
- ✅ Apply for jobs with form

### User Profile
- ✅ View account information
- ✅ Edit profile (name, email)
- ✅ Edit job preferences (fields, titles, salary, work mode)
- ✅ Dark/Light mode toggle
- ✅ Delete account option

### Offline Support
- ✅ SQLite database for local storage
- ✅ Works without internet connection
- ✅ Syncs when back online

## 🔌 API Endpoints

### ReqRes.in (Authentication)
```
POST https://reqres.in/api/register
POST https://reqres.in/api/login
GET  https://reqres.in/api/users
```

### MockAPI (Jobs)
```
GET    https://672e6e56229a881691ef49c2.mockapi.io/api/v1/jobs
POST   https://672e6e56229a881691ef49c2.mockapi.io/api/v1/jobs
PUT    https://672e6e56229a881691ef49c2.mockapi.io/api/v1/jobs/{id}
DELETE https://672e6e56229a881691ef49c2.mockapi.io/api/v1/jobs/{id}
```

## 📱 Screens

| Screen | Description |
|--------|-------------|
| Splash Screen | Animated splash with auto-navigation |
| Sign In Screen | Login with email/password |
| Sign Up Step 1 | Basic user information |
| Sign Up Step 2 | Job preferences selection |
| Sign Up Step 3 | Salary & work mode |
| Home Screen | Job listing with search/filters |
| Profile Screen | User info and preferences |
| Apply Screen | Job application form |

## 🎨 UI Features

- **Clean modern design** with brand color (#01BEF9)
- **Responsive layout** for all screen sizes
- **Dark/Light mode** support
- **Animated transitions** between screens
- **Custom widgets** for consistent UI
- **Loading states** and error handling
- **Pull to refresh** on job listings

## 🚦 Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)
- Android Studio / VS Code
- Android Emulator / iOS Simulator / Physical Device

### Installation Steps

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/job-finder-app.git
cd job-finder-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

4. **Build APK (Android)**
```bash
flutter build apk --release
```

## 🔐 Test Credentials

### Online Mode (ReqRes API)
```
Email: eve.holt@reqres.in
Password: cityslicka
```

### Offline Mode (SQLite)
```
Any email address works after offline registration
Example: test@example.com
Password: 123456
```

## 📱 Build Instructions

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS (requires macOS)
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is for educational purposes as part of a mobile development assignment.

## 👨‍💻 Author

**Your Name**
- GitHub: https://github.com/SanduniLK/JobFinderApp
- Email: geeganagesanduni83@gmail.com

## 🙏 Acknowledgments

- [ReqRes.in](https://reqres.in/) for the mock authentication API
- [MockAPI.io](https://mockapi.io/) for the jobs API
- Flutter team for the amazing framework

---

**Made with ❤️ using Flutter**
