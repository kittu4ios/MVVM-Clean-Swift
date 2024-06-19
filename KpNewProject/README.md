# Templete Clean Arch + MVVM

A sample project demonstrating Clean Architecture with MVVM design patterns in Swift.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [Contributing](#contributing)
- [License](#license)

## Introduction

KpNewProjectClean is a Swift project showcasing Clean Architecture with MVVM design patterns. It aims to provide a structured approach to building iOS applications with separation of concerns and testability in mind.

## Features

List the key features or functionalities of your project.

- Feature 1
- Feature 2
- ...

## Architecture

### Clean Architecture Layers

- **Domain Layer**: Contains core business logic and domain models.
- **Data Layer**: Manages data operations and repositories.
- **Presentation Layer**: Handles UI and user interaction.
- **Application Layer**: Coordinates data flow between layers.

### MVVM (Model-View-ViewModel) Pattern

- **Model**: Represents data and business logic.
- **View**: User interface components.
- **ViewModel**: Manages data for Views, handles presentation logic.

## Requirements

Ensure you have the following prerequisites before starting:

- iOS 14.0+
- Xcode 13+
- Swift 5.5+
- Cocoapods (for dependencies management, optional)

## Installation

To get started with KpNewProjectClean, follow these steps:

1. Clone the repository:
2. Navigate to the project directory:
3. Open `KpNewProjectClean.xcodeproj` in Xcode.
4. Select a simulator or device and click the run button (`Cmd + R`).


Project/
├── Domain/
│ ├── UseCases/
│ ├── Entities/
│ └── Repositories/
├── Data/
│ ├── Repositories/
│ └── Models/
└── Presentation/
├── Views/
├── ViewModels/
└── Coordinators/

## Contributing

Contributions are welcome! Feel free to submit bug reports, feature requests, or pull requests. Please follow these guidelines:

- Fork the repository and create your branch from `main`.
- Make sure your code follows Swift style guidelines.
- Test your changes thoroughly.
- Issue a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
