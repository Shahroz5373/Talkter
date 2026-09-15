# Talkter 💬✨

> A modern, privacy-focused real-time chat application built with Flutter.

Talkter is a real-time messaging app combining a **modern glassmorphic UI** with secure communication, Firebase, and Riverpod.

## ✨ Features

* 🔐 **End-to-End Encryption** — Messages are encrypted locally using `libsodium`.
* 📱 **Phone Authentication** — Secure OTP authentication with Firebase.
* 💬 **Real-Time Chat** — Real-time messaging, read receipts, and swipe-to-reply.
* 👥 **Friends System** — Search users, send friend requests, and manage friends.
* 🎨 **Modern UI** — Dark glassmorphism with neon accents and smooth animations.
* 👤 **Profile Management** — Custom avatars hosted through Cloudinary.
* 💾 **Secure Storage** — Private keys stored securely on the user's device.

## 🛠️ Tech Stack

* **Frontend:** Flutter & Dart
* **State Management:** Riverpod
* **Backend:** Firebase Authentication & Cloud Firestore
* **Media:** Cloudinary
* **Encryption:** libsodium
* **Secure Storage:** flutter_secure_storage
* **Local Storage:** SharedPreferences

## 🚀 Getting Started

### Prerequisites

* Flutter SDK
* Firebase project
* Cloudinary account
* Android/iOS development environment

### Installation

```bash
git clone https://github.com/Shahroz5373/Talkter.git
cd Talkter
flutter pub get
flutter run
```

### Firebase Setup

Add your Firebase configuration files:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

Enable **Firebase Authentication** and **Cloud Firestore** in your Firebase project.

## 🔐 Encryption

Talkter generates a public/private key pair for each user.

* **Public key** → stored in Firestore
* **Private key** → stored securely on the user's device
* **Messages** → encrypted before being stored in Firestore

## 📸 Screenshots

<img width="1080" height="1350" alt="main_post" src="https://github.com/user-attachments/assets/ac6254c3-d3cc-478e-96c2-499ae3092486" />


## 👨‍💻 Author

**Muhammad Shahroz**

Flutter Developer & Computer Science Graduate

* [GitHub](https://github.com/Shahroz5373)
* [LinkedIn](https://www.linkedin.com/in/muhammad-shahroz-87a244304/)

---

<p align="center">
  Made with  using Flutter
</p>
