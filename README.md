# Shaman - Post-Installation Configuration Assistant

Shaman is a vital post-installation configuration assistant designed primary for **Ekaaty Linux**, an operating system based on the **KDE Plasma 6** desktop environment or superior.

Its primary goal is to provide a user-friendly and interactive guide for new users to complete essential system configurations immediately after installation.

## 🚀 Key Features

* **System Theming:** Quick selection and application of system-wide visual styles.
* **Driver Management:** Streamlined installation and configuration of proprietary or additional hardware drivers.
* **Repository Management:** Easy addition, removal, and updating of software sources.
* **Security Adjustments:** Interactive settings for critical system security parameters.

## ⚙️ Architecture

The project adopts a modern, decoupled architecture:

1.  **Frontend (UI):** Built with **Qt Quick (QML)**, leveraging **Kirigami** for adaptive, native KDE user interfaces, and **PlasmaCore** for system integration features.
2.  **Backend (Logic):** Implemented in **Python** using the **PySide6** library. This layer handles all system-level interactions, such as package management and file manipulation on the GNU/Linux OS.
3.  **Communication Bridge:** A dedicated Python class (`ShamanBackend`, subclassing `QObject`) exposes system functionalities to the QML frontend via PySide6 `@Slot` decorators.

## 🛠️ Build and Development

This project uses **CMake** for configuration and dependency management, optimized for speed with the **Ninja Build** system.

### Prerequisites

* A C++ compiler (e.g., GCC or Clang)
* Python 3.x with development headers
* Qt 6 Development Libraries (including Qt Quick and Qt Core)
* PySide6
* Kirigami and Plasma Frameworks (KDE Development tools)
* CMake (3.21 or higher is recommended)
* Ninja Build

### Building the Project

```bash
# Create a build directory
mkdir build
cd build

# Configure the project with CMake (adjust install prefix if necessary)
# Note: KDE_INSTALL_DATADIR is usually set to /usr/share/ or equivalent on Linux.
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DQT_MAJOR_VERSION=6 ..

# Build
ninja

# Install (requires appropriate permissions)
sudo ninja install
```
