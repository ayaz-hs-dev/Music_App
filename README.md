
# 🎵 Music_App

![Music_App Demo](link-to-features-gif)  
*Animated preview: Search, play music, favorite & comment, notifications, local playback.*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev) 
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev) 
[![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat&logo=mongodb&logoColor=white)](https://www.mongodb.com/) 
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Music_App** is a modern music application that lets users search, play, and manage music online and locally. It comes with user accounts, a robust music player, foreground notifications, and interactive saved songs.

---

## 🌟 Features

- **Search & Save Music**: Find songs and add to your saved collection.  
- **Favorite & Comment**: Mark songs as favorite and leave comments.  
- **Local Music Playback**: Play music stored on your device.  
- **Music Player**: Play, pause, skip tracks, background playback, and notification controls.  
- **User Management**: Create, update, delete users, login/logout functionality.  

---

## 🛠 How It Works

1. **User Flow**:  
   Create account → Log in → Search/load music → Play → Save favorites → Comment → Manage profile.  

2. **Playback**:  
   - Music continues when the app is minimized.  
   - Notifications allow controlling playback without opening the app.  

3. **Backend**:  
   - Uses a **separate MongoDB backend repository**.  
   - Stores users, saved songs, favorites, and comments.  
   - Backend repo: [Music_App Backend](https://github.com/ayaz-hs-dev/Music_App_Backend.git)  

---

## 🔗 Architecture

```

+-------------------+          +--------------------+
\|   Music\_App       |   API    |   MongoDB Backend  |
\|   (Flutter App)   +--------->+   (Separate Repo)  |
\|                   |<---------+                    |
+-------------------+          +--------------------+

````

---

## 📸 Screenshots / GIFs

| Feature | Demo |
|---------|------|
| Login / Create User | ![login](link-to-login-gif) |
| Search & Saved Music | ![search](link-to-search-gif) |
| Music Player | ![player](link-to-player-gif) |
| Local Music Playback | ![local](link-to-local-gif) |
| Foreground Notification | ![notification](link-to-notification-gif) |
| Comments & Favorites | ![comments](link-to-comments-gif) |

---

## ⚡ Installation

1. Clone the repository:  
```bash
git clone https://github.com/ayaz-hs-dev/Music_App.git
````

2. Navigate to the project folder:

```bash
cd Music_App
```

3. Install dependencies:

```bash
flutter pub get
```

4. Set up backend API URL in the app configuration.
5. Run the app:

```bash
flutter run
```

---

## 🛠 Technologies Used

* Flutter
* Dart
* MongoDB (via separate backend repository)

---

## 📄 License

This project is licensed under the MIT License.

```


