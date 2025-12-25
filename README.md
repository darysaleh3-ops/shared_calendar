# Shared Calendar App

A local-first, offline-capable Shared Calendar application built with Flutter.

## Features
- **Local Authentication**: Register and Login (Data persisted locally).
- **Groups**: Create and manage groups.
- **Shared Calendar**: View events per group in Month/Week/Day formats.
- **Events**: Add, Edit, Delete events with permission logic.
- **Notifications**: Local notifications on event changes.

## Architecture
- **State Management**: Riverpod (with Code Generation).
- **Persistence**: Drift (SQLite).
- **Navigation**: GoRouter.
- **UI**: Flutter Material 3 + TableCalendar.

## Setup

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate Code**:
   This project uses code generation for Riverpod, Drift, and Freezed. Run:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run App**:
   ```bash
   flutter run
   ```

## Folder Structure
- `lib/core`: Database, Router, Notifications, Providers.
- `lib/features/auth`: User authentication.
- `lib/features/groups`: Group management.
- `lib/features/calendar`: Calendar and Event management.
