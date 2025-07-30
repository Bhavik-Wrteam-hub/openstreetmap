# Gujarat Bus Route Map

A Flutter demo app showcasing OpenStreetMap integration with bus route visualization around Gujarat, India.

## 🗺️ Features

- **OpenStreetMap Integration**: Uses OpenStreetMap tiles (no Google Maps API key required)
- **Bus Route Visualization**: Shows 3 bus stops in Gujarat (Anand, Nadiad, Vadodara)
- **Interactive Markers**: Custom styled bus stop markers with tap functionality
- **Route Polyline**: Red dashed line connecting all bus stops
- **Current Location**: GPS location feature with permission handling
- **Auto-Zoom**: Automatically fits map to show the entire route
- **Modern UI**: Material Design 3 with polished interface

## 📱 Demo Video

Watch the app in action:

https://github.com/Bhavik-Wrteam-hub/openStreetMap/assets/174414612/Record_2025-07-30-13-55-59.mp4

*Note: Replace `yourusername` and `youruserid` with your actual GitHub username and user ID*

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Physical device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/openStreetMap.git
   cd openStreetMap/open_street_map
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- `flutter_map: ^7.0.2` - OpenStreetMap integration
- `latlong2: ^0.9.1` - Geographic coordinates
- `geolocator: ^12.0.0` - Location services

## 🔧 Permissions

The app requires location permissions for the current location feature:

### Android
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`

### iOS
- `NSLocationWhenInUseUsageDescription`

## 🎯 Usage

1. **View Bus Route**: The app opens showing the Gujarat bus route
2. **Tap Markers**: Click on bus stop markers to see stop names
3. **Get Location**: Tap the location button (📍) to show your current position
4. **Zoom Controls**: Use the zoom button to fit the route to screen
5. **Route Info**: Tap the floating action button for detailed information

## 🎨 UI Features

- **Bus Stop Markers**: Blue circular markers with bus icons
- **Current Location**: Green marker with person pin icon
- **Route Line**: Red dashed polyline connecting stops
- **Interactive Elements**: Tap feedback and snackbar notifications
- **Loading States**: Progress indicators for location services

## 📍 Bus Stops

1. **Anand Bus Stop** (22.5645°N, 72.9289°E)
2. **Nadiad Bus Stop** (22.6939°N, 72.8614°E)
3. **Vadodara Bus Stop** (22.3072°N, 73.1812°E)

## 🔍 Technical Details

- **Map Provider**: OpenStreetMap (free, no API key)
- **Location Accuracy**: High accuracy GPS positioning
- **Error Handling**: Comprehensive permission and service error handling
- **State Management**: Flutter StatefulWidget with proper lifecycle management
- **Responsive Design**: Works on various screen sizes

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you have any questions or issues, please open an issue on GitHub.
