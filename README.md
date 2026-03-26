# Street Voice — Location-Based Audio Guide App

> **Ứng dụng hướng dẫn âm thanh tự động theo vị trí địa lý** — tự động phát thuyết minh khi người dùng bước vào vùng geofence của quán ăn / địa điểm.

---

## 📖 Project Description

**Street Voice** is a cross-platform mobile application built with Flutter that delivers **automatic, location-triggered audio guides** for street food vendors and points of interest. As users walk through a city, the app detects when they enter the geofence radius of a registered stall and immediately plays a multilingual audio description — no interaction required.

The app targets **tourists and locals** who want to discover street food culture in an immersive, hands-free way. It works fully offline, supports five languages, and adapts its UI to both light and dark themes.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🎙️ **Geofence-Triggered Audio** | Automatically plays an audio description when the user enters a stall's radius (configurable per stall); includes a 3-second countdown and 1-minute per-stall cooldown |
| 🗺️ **Interactive Map** | VietMap GL-powered map showing nearby stalls with real-time user position |
| 📍 **Real-time GPS Tracking** | Continuous location monitoring with 2-meter distance filter for precise geofence detection |
| 🌐 **5-Language Support** | Full localisation in Vietnamese 🇻🇳, English 🇺🇸, Chinese 🇨🇳, Japanese 🇯🇵, and Korean 🇰🇷 |
| 📶 **Offline-First** | Falls back to bundled JSON data and local MP3 files when the network is unavailable |
| 📜 **POI Infinite Scroll** | Paginated, lazy-loading list of nearby points of interest sorted by distance and priority |
| 📷 **QR Code Scanner** | Scan QR codes to trigger APK downloads or open external links |
| 🌗 **Dark / Light Theme** | User-selectable theme persisted across sessions |
| 🔒 **Secure API Key Handling** | Environment variables loaded via `.env` with `flutter_dotenv` |
| 📊 **Analytics Tracking** | Event tracking flushed on app lifecycle transitions |

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** (Dart) — cross-platform iOS & Android
- **Dart 3** with dot-shorthand enum syntax (null-safety since Dart 2.12)

### State Management
- **Riverpod** (with code generation via `riverpod_generator` + `build_runner`)

### Networking & Data
- **Dio** — HTTP client with centralised exception handling
- **flutter_dotenv** — secure `.env`-based configuration
- **shared_preferences** — lightweight local persistence
- **connectivity_plus** — real-time network status

### Maps & Location
- **vietmap_flutter_gl** — Vietnamese map tiles and GL rendering
- **geolocator** — GPS access and stream-based location updates

### Audio
- **just_audio** — streaming and local audio playback with speed, position, and state streams

### UI & UX
- **flutter_screenutil** — responsive sizing
- **font_awesome_flutter** — icon library
- **device_preview** — multi-device UI debugging

### Other
- **mobile_scanner** — QR / barcode scanning
- **permission_handler** — runtime permissions (location, camera)
- **url_launcher** — open external links
- **intl** + `flutter gen-l10n` — ARB-based localisation

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── config/          # Environment & app configuration
│   ├── constants/       # AppColors, AppConstants, AppStrings
│   ├── network/         # API constants, exceptions, ApiResponse<T>
│   ├── offline/         # Bundled JSON stall data (5 languages)
│   ├── providers/       # Global Riverpod providers (theme, locale)
│   ├── router/          # GoRouter shell-pattern navigation
│   ├── services/        # LocationService, DatabaseService, AudioService, GeofenceService, AnalyticsService, VietmapRoutingService
│   ├── theme/           # AppColors, gradients, ThemeData extensions
│   └── utils/           # Shared helpers
└── features/
    ├── home_screen/     # Map view + food stall list + geofence provider
    ├── poi_infinite_scroll/ # Paginated POI browser
    ├── qr_scanner/      # QR code scanning & download trigger
    ├── settings/        # Theme / language / notification settings
    └── shell/           # Root scaffold + bottom navigation bar
```

**Design patterns used:** Feature-first folder structure, Repository pattern (DatabaseService), Provider pattern (Riverpod Notifiers), Offline-first with API + local JSON fallback.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10.1
- Dart ≥ 3.0
- Android Studio / Xcode for device deployment

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/giahuyto3107/automatic_demonstration.git
cd automatic_demonstration

# 2. Create environment file
cp .env.example .env   # then fill in your API_KEY and BASE_URL

# 3. Install dependencies
flutter pub get

# 4. Generate Riverpod/l10n code
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 5. Run the app
flutter run
```

> **Note:** A valid VietMap API key and backend URL are required in `.env` for full functionality. The app will fall back to bundled offline data if the network is unreachable.

---

## 📱 Screenshots

| Home (Light) | Home (Dark) | POI List | Settings |
|---|---|---|---|
| *(coming soon)* | *(coming soon)* | *(coming soon)* | *(coming soon)* |

---

## 🗂️ Recent Changelog

- **Real API Integration** — `GET /stalls` endpoint with `lang` query parameter; API key secured via `.env`
- **Dark / Light Mode** — toggle button; theme persisted with `shared_preferences`
- **State Management** — Riverpod providers for `FoodStallModel`, `Locale`, and `Theme`
- **GPS Refresh Button** — on-demand re-fetch of the latest device coordinates
- **UI/UX Polish** — optimised padding, spacing, and food stall list layout