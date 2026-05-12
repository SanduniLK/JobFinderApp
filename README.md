# 🚀 Job Finder - Your Dream Job Search Companion

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
</p>

A modern, feature-rich mobile application designed to bridge the gap between talent and opportunity. Built with **Flutter**, this app provides a seamless job search experience with offline support, real-time updates, and a professional UI.

---

## 📱 Screenshots

<div align="center">
  <table border="0">
    <tr>
      <td align="center">
        <img src="assets/screenshots/signIn.jpeg" width="200" alt="Sign In"/><br/>
        <b>Sign In</b>
      </td>
      <td align="center">
        <img src="assets/screenshots/signUpscreen.jpeg" width="200" alt="Sign Up"/><br/>
        <b>Sign Up</b>
      </td>
      <td align="center">
        <img src="assets/screenshots/home.jpeg" width="200" alt="Home Screen"/><br/>
        <b>Home Feed</b>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="assets/screenshots/filter.jpeg" width="200" alt="Filters"/><br/>
        <b>Advanced Filters</b>
      </td>
      <td align="center">
        <img src="assets/screenshots/profile.jpeg" width="200" alt="Profile"/><br/>
        <b>User Profile</b>
      </td>
      <td align="center">
        <img src="https://via.placeholder.com/200x400?text=Job+Details" width="200" alt="Job Details"/><br/>
        <b>Job Details</b>
      </td>
    </tr>
  </table>
</div>

---

## ✨ Key Features

### 🔐 Authentication & Security
*   **Hybrid Mode**: Register/Login via **ReqRes.in** (Online) or **SQLite** (Offline).
*   **Session Management**: Persistent login status using `SharedPreferences`.
*   **Secure Logout**: Built-in confirmation dialogs to prevent accidental logouts.

### 👤 Personalized Onboarding
*   **3-Step Registration**: A guided flow capturing Basic Info ➔ Preferences ➔ Salary/Work Mode.
*   **Preference Matching**: Select multiple job fields and titles to personalize your feed.
*   **Salary Slider**: Interactive UI for setting expected compensation.

### 💼 Job Discovery
*   **Smart Search**: Filter by title, company name, or geographic location.
*   **Deep Filtering**: Narrow down by Work Mode (Remote/Hybrid/On-site) and Experience Level.
*   **CV Integration**: Apply for jobs by attaching PDF/DOCX resumes using `file_picker`.

### 📶 Robust Offline Support
*   **Local Caching**: All jobs and user data are stored locally using `sqflite`.
*   **Smart Sync**: Access your profile and browse saved jobs even without an internet connection.

---

## 🛠️ Tech Stack

| Category | Technology |
|:--- | :--- |
| **Framework** | Flutter 3.x |
| **Language** | Dart 3.x |
| **State Management** | Provider |
| **Database** | SQLite (sqflite) |
| **Networking** | HTTP Package |
| **Animations** | Lottie |

---

## 📁 Project Structure

```text
lib/
├── core/            # App constants, themes, and shared utilities
├── data/            # SQLite logic, API services, and Data Models
├── domain/          # Business entities and logic
├── presentation/    # UI Layer (Screens, Widgets, and Providers)
└── main.dart        # Entry point

🚀 Installation & Setup
Prerequisites
Flutter SDK (>= 3.0.0)

Dart (>= 3.0.0)

Steps
Clone the Repo

Bash
git clone [https://github.com/SanduniLK/JobFinderApp.git](https://github.com/SanduniLK/JobFinderApp.git)
cd JobFinderApp

2. **Install Dependencies**
   ```bash
   flutter pub get
Run the Project

Bash
flutter run


---

## 🔐 Credentials for Testing

### **Online Mode (ReqRes API)**
> **Note:** Use these specific emails for a successful online registration.

| Email | Password |
| :--- | :--- |
| `eve.holt@reqres.in` | `cityslicka` |
| `janet.weaver@reqres.in` | `any_password` |

---

## 🤝 Contributing
Contributions make the open-source community an amazing place to learn and inspire.
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

<div align="center">
  <p>Made with ❤️ by <b>Reshika Sanduni</b></p>
  <p>© 2024 Job Finder App</p>
</div>