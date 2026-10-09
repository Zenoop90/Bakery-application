# 🥖 Sweet Crumbs — Bakery & Café iOS App

An elegant, fully-featured iOS Bakery application built using **SwiftUI** as part of the **iOS App Development Internship Project (Industrial Training 1)**.

The entire application architecture, navigation flow, and UI components are neatly structured in a consolidated, self-contained implementation using modern SwiftUI paradigms.

---

## 📱 Features

- 🔐 **Authentication System**:
  - **Login View**: Form validation, error handling, and animated loading states.
  - **Sign-Up View**: Comprehensive password strength checks (minimum 6 characters), password confirmation, and input validation.
  
- 🏠 **Interactive Home Dashboard**:
  - **Personalized Greeting**: Dynamic welcome card displaying user identity.
  - **Daily Bakery Quotes Carousel**: Auto-rotating inspirational quotes with smooth fade transitions and dot indicators.
  - **Best Sellers Ranking**: Top-selling products highlighted with 🥇🥈🥉 medals and "Top Pick" badges.
  - **Today's Specials**: Horizontal scrollable showcase of featured baked goods.
  - **Category Pills**: Quick category navigation shortcuts.

- 🍰 **Full Bakery Menu**:
  - Real-time search filtering by item name and description.
  - Dynamic category filters: *All, Pastries, Cakes, Breads, Muffins, Cookies*.
  - Responsive multi-column grid layout with detailed product cards.

- 🔍 **Item Detail View**:
  - High-resolution hero display with bakery items and custom color theming.
  - Detailed product descriptions and pricing.
  - Interactive quantity selector (+ / -) with live total price calculations.
  - Animated toast notification upon adding to cart.

- 🛒 **Cart & Checkout Management**:
  - Real-time cart state with item quantities and individual totals.
  - Remove items directly with swipe/trash controls.
  - Automatic calculation of subtotal, delivery fee, and sales tax (8%).
  - Live interactive order placement with completion alert dialog.
  - Dynamic nav-bar badge updating live item counts.

- ℹ️ **About & Bakery Story**:
  - Brand background, core artisan values, operating hours, and location/contact info.

- 👤 **User Profile**:
  - Member tier badge, order stats, profile shortcuts, and secure logout.

---

## 🛠️ Technical Stack & Architecture

- **Language**: Swift 6
- **UI Framework**: SwiftUI (Declarative UI)
- **Architecture**: MVVM (Model-View-ViewModel)
  - **Models**: `BakeryItem`, `CartItem` (Conforming to `Identifiable`, `Sendable`)
  - **ViewModel / App State**: `@MainActor class AppState: ObservableObject`
  - **Views**: Composable SwiftUI View structures
- **Navigation**: Modern `NavigationStack` with seamless `NavigationLink` pushes
- **State Management**: `@State`, `@StateObject`, `@EnvironmentObject`, `@Published`
- **Concurrency**: Concurrency-safe design conforming to `@MainActor` rules
- **Animations**: SwiftUI `withAnimation`, spring transitions, Combine `Timer.publish` publishers

---

## 🚀 How to Run

1. Clone this repository:
   ```bash
   git clone git@github.com:Zenoop90/Bakery-application.git
   ```
2. Open `SweetCrumbs_BakeryApp.xcodeproj` in **Xcode 15+**.
3. Select an iOS Simulator (e.g., iPhone 15 Pro / iPhone 16).
4. Press **Cmd + R** or click **Run** to launch the app.

---

## 👨‍💻 Author

- **Intern Project**: Industrial Training 1 — iOS App Development
- **GitHub**: [@Zenoop90](https://github.com/Zenoop90)
