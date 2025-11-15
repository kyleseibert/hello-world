# Weather Buddy

A simple SwiftUI iOS application that fetches the current weather for any city using the free [Open-Meteo](https://open-meteo.com/) APIs. Type a city name, tap **Get Weather**, and the app displays the current conditions, temperature, feels-like temperature, wind speed, and humidity.

## Project structure

```
WeatherApp/
├── ContentView.swift          # SwiftUI UI layer
├── WeatherAppApp.swift        # App entry point
├── WeatherModels.swift        # Codable models and helpers
├── WeatherService.swift       # Networking + weather mapping
└── WeatherViewModel.swift     # Async view model & state machine
```

## Running the app

1. Open the project folder in Xcode (`File > Open...` and choose the `WeatherApp` directory).
2. Select an iOS Simulator (or a physical device) in the toolbar.
3. Press **Cmd+R** to build and run. The simulator will launch the app and automatically fetch the weather for San Francisco as a starting point.

The app uses async/await networking with `URLSession`, so it requires Xcode 14 / iOS 16 or newer.
