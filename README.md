# 🍽️ Food Tracker – Order & Delivery Mobile App

A modern, scalable **Flutter-based food delivery application** that enables users to browse menus, place food orders, track deliveries in real time, and enjoy a seamless, responsive user experience across Android and iOS platforms.

> Built with clean architecture, responsive UI, and state-of-the-art mobile dev practices.

---

## 🚀 Tech Stack

- **Framework:** Flutter (v3.29.2)
- **Language:** Dart
- **Architecture:** Clean + Feature-first structure
- **Responsive UI:** [`Sizer`](https://pub.dev/packages/sizer)
- **Routing:** Declarative `AppRoutes` map
- **Theming:** Light & Dark Mode with `ThemeData`
- **State Management:** Scalable and pluggable (ready for Provider, Riverpod, etc.)

---

## ✨ Key Features

- 🔍 **Browse Restaurants & Menus**
- 🛒 **Add to Cart & Checkout**
- 🛵 **Live Order Tracking UI**
- 🎨 **Dynamic Theming (Light/Dark)**
- 📱 **Responsive Design Across Devices**
- ⚡ **Optimized for Performance & Fast Launch**
- 🌐 **Cross-Platform Support (Android & iOS)**

---

## 📦 Installation

Make sure you have Flutter & Dart installed:

```bash
git clone https://github.com/your-username/food-tracker-app.git
cd food-tracker-app
flutter pub get
flutter run
```

---

## 🧱 Folder Structure

```
lib/
├── core/                 # Core utilities, services, constants
│   └── utils/
├── presentation/         # UI layer: screens & widgets
│   ├── splash_screen/
│   ├── home_screen/
│   ├── cart/
│   └── order_tracking/
├── routes/               # AppRoutes for navigation
├── theme/                # ThemeData (Light & Dark)
├── widgets/              # Reusable components
└── main.dart             # App entry point
```

---

## 📲 Screenshots

> _Add app UI mockups or screenshots here if available to catch recruiter attention visually._

---

## 🎨 Theming & Responsiveness

```dart
// Access theme color
ThemeData theme = Theme.of(context);
Color primary = theme.colorScheme.primary;

// Responsive layout using Sizer
Container(
  width: 80.w,
  height: 20.h,
  child: Text('Responsive Container'),
)
```

---

## 🛠 Build & Deployment

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

---

## ✅ Why This Project?

This project was built to demonstrate:

- ✅ Proficiency with Flutter & Dart
- ✅ Clean and scalable code structure
- ✅ Building responsive, cross-platform UIs
- ✅ Knowledge of modern mobile development practices
- ✅ Ability to work across frontend, architecture, and deployment layers

---

## 👨‍💻 Author

**Ritesh Kumar Singh**  
Mobile Developer | Flutter Enthusiast  
[LinkedIn](https://www.linkedin.com/in/ritesh-singh1/)

🌐 **GitHub Repo:** [github.com/neutron420/FreshFeats(https://github.com/neutron420/FreshFeats)
---
💼 Contributions Welcome: Forks and contributions are encouraged. 

---

## 📄 License

This project is licensed under the MIT License.

---

_Actively seeking opportunities in mobile development. Reach out if you're building something great!_
