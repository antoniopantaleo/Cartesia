# Cartesia

A GeoGuessr-style iOS game built with SwiftUI and Apple Maps LookAround. You're dropped somewhere in the world, explore the streets, and guess where you are on a map. A game is 5 rounds; each round scores up to 11,000 points based on distance and speed.

## Requirements

- Xcode 26+, iOS 18.0+ deployment target
- [mise](https://mise.jdx.dev) (pins Tuist 4.88.0 and other tools)

## Setup

```sh
mise install
mise run generate-project   # runs tuist generate
```

Open `Cartesia.xcworkspace` and run the `Cartesia` scheme.

## Release builds

Two Tuist environment variables must be set when generating the project for release, otherwise the bundle identifier resolves to `.Cartesia` and code signing fails:

```sh
TUIST_BUNDLE_PREFIX=com.yourcompany TUIST_DEVELOPMENT_TEAM=XXXXXXXXXX tuist generate
```

## Architecture

- **µFeature modules** (`Start`, `Game`, `Result`): each has `Feature`, `FeatureInterface`, `FeatureTesting` (fakes), `FeatureTests`, and a standalone `FeatureExample` app.
- **App layer** (`Cartesia/`): `AppCoordinator` owns navigation and the 5-round `GameSession`; router implementations bridge feature interfaces to the coordinator.
- The Game module hides street/place labels in `MKLookAroundViewController` at runtime (see `MKLookAroundView+Swizzling.swift`) so the game isn't spoiled.
