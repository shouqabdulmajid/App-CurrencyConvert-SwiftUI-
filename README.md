# Smart Currency Converter (iOS App)

A sleek, native iOS application built from scratch using SwiftUI and modern design principles. The app connects to a live financial API to fetch real-time exchange rates from Saudi Riyal (SAR) to major global currencies, providing users with instant, accurate conversions.

## Features
*   **Live API Integration:** Fetches up-to-date financial data dynamically using URLSession.
*   **Data Persistence:** Uses @AppStorage to locally remember the user's favorite currency choice across application launches.
*   **Modern UI/UX Design:** Features a polished Splash Screen with fluid spring animations (withAnimation(.spring())).
*   **Glassmorphic Elements:** Implements beautiful blurred container layouts using .ultraThinMaterial for a modern iOS aesthetic.
*   **Asynchronous Thread Handling:** Leverages DispatchQueue.main.async to ensure flawless UI updates without freezing the user interface.

## Technical Stack
*   **Language:** Swift 5
*   **Framework:** SwiftUI
*   **Networking:** URLSession (REST API)
*   **Data Parsing:** Codable & JSONDecoder
*   **Data Storage:** UserDefaults via @AppStorage

## Screenshots & Demo
*Design layout customized for fluid mobile usability.*

---
*Developed as part of my continuous journey in full-stack mobile development.*
