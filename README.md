# Pokémon

A lightweight Pokédex-style iOS app built in SwiftUI + MVVM.
It displays a list of all 1010 Pokémon (sourced from a bundled JSON for reliability), supports search by name or ID, and shows detailed information with caching for offline resilience.

## 📸 Screenshots
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-03 at 02 51 59" src="https://github.com/user-attachments/assets/bf65f98a-9308-40b4-a9ca-930d0ebe8220" />
<img width="300" alt="Simulator Screenshot - iPhone 16 Pro - 2025-10-03 at 02 52 02" src="https://github.com/user-attachments/assets/1bc2963e-504d-474d-93f5-0f039b6e3248" />

## Features

- Browse and view content with a responsive SwiftUI interface
- Search functionality for quickly finding what you need
- Dynamic color extraction for a personalized visual experience
- Offline caching for smoother usage without constant network access
- Error handling with clear fallback UI states
- Simple setup: just open the project in Xcode and run

## 🚀 Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/pokemon.git
   ```
2. Open the project in Xcode 15 or later.
3. Run on the iOS Simulator or a physical device.

No additional setup or dependencies are required — everything runs out of the box.

## Git Workflow

For this project, I used a simple branching strategy suited for a small, single-developer app:

- Each feature was developed on its own branch (e.g. `homepage`, `info`, `network`, `caching`, `background-colors`, etc).
- Once a feature was complete, I opened a Pull Request (PR) and merged it directly into the `main` branch.
- This approach allowed for clean separation of features while keeping the workflow lightweight, without the overhead of managing long-lived branches.

Since this was a small project built under time constraints, this lightweight workflow provided both clarity and speed.

## 🏗️ Architecture & Structure

### High-Level Approach

The app is built with **SwiftUI + MVVM** for speed, simplicity, and future-proofing. The structure is organized into Swift packages plus a lightweight app target:

* **PokemonModels** → data models and DTOs
* **NetworkKit** → networking layer (protocols, `URLSession` service, testing helpers)
* **PokemonRepositoryKit** → local + remote repositories, caching logic, unified access point
* **Main App Target** → SwiftUI views, ViewModels, and feature-specific UI logic

Within the app target itself, the folder structure is feature-oriented:

* **Scenes** → feature screens (Home, Info), each with its own View and ViewModel
* **Components** → reusable SwiftUI elements (`PokemonCardView`, `PokemonImageView`)
* **Extensions** → utilities

This balances modular separation for core logic with a simple feature-based layout for UI.

---

## 🎨 Design & Architectural Considerations

### MVVM Choices

* Views are built with **SwiftUI**, while ViewModels handle only **transforming data for display**.
* Services/Repositories are injected into ViewModels for tasks like networking, persistence, and caching.
* I follow Paul Hudson’s approach of embedding the `ViewModel` as an extension of the `View`. It keeps things tidy, though it does mean files can’t share the same name (a minor inconvenience).

### Models

* Models double as both DTOs (API decoding) and domain models (UI display), since the data is simple.
* Each model has a static sample instance for use in previews, testing, and prototyping.
* Example: PokeAPI returns height in decimetres and weight in hectograms, so I added computed properties for human-friendly conversions in both metric and imperial. Since these are single-use, no `Constants` were introduced.

### UI Design

* The design is intentionally minimal. Apart from `PokemonImageView` and `PokemonCardView`, no extra components were factored out. Smaller helpers live inside the views themselves.

### Data Fetching & Caching

* **Pokémon list**:

  * PokeAPI requests were unreliable (timeouts in simulator, no support in previews).
  * Since there are only 1010 Pokémon, I opted to bundle a local JSON list of IDs and names. This removed the need for pagination and allowed full offline search.

* **Pokémon details**:

  * Managed via `RemotePokemonRepository` in `PokemonRepositoryKit`.
  * Uses a hybrid cache strategy:

    * In-memory (`PokemonMemoryCache`)
    * Disk (via `FileManager`)
    * API fallback

  * Each Pokémon is read from disk only once; subsequent accesses use memory.

* **FileManager vs. CoreData/SwiftData**:

  * Chose `FileManager` for caching Pokémon details.
  * Simpler and lighter than `CoreData/SwiftData`.
  * Avoids boilerplate setup while still fully meeting project needs.

### Colors

* `UIImageColors` extracts dominant colors from Pokémon images to set dynamic backgrounds. This mimics modern Pokédex-inspired UI designs seen on Dribbble/Pinterest, and static colors wouldn’t achieve the same effect.

### Things Deliberately Omitted

To keep scope manageable in a one-day build, the following were skipped as overkill:

* Structured logging
* API retry mechanism

---

## Guiding Principle

**Keep it simple until complexity demands structure.**
For this project’s scope, a flat but organized folder layout, lightweight MVVM, and pragmatic caching strategies gave the best balance of speed, clarity, and maintainability.
