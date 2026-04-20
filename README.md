# RegisterOffline

iOS app for offline-first member registration and upload flow.

## Overview

`RegisterOffline` provides:
- Authentication (`/login`, `/register`)
- Profile fetch (`/profile`)
- Member list fetch (`/member`)
- Create member form with camera capture for KTP photos
- Local draft storage (SwiftData) and bulk upload sync

The app uses a layered architecture:
- `RemoteDataSource` (network call)
- `Repository` (data orchestration)
- `ViewModel` (UI state + mapping from response to domain model)

## Tech Stack

- SwiftUI
- Combine
- SwiftData (local draft persistence)
- Alamofire (networking + multipart upload)
- SwiftyJSON
- KeychainSwift (token storage)
- netfox (debug network inspector)

## Requirements

- Xcode 16+
- iOS 17+ (SwiftData runtime)

## Run the Project

1. Open `RegisterOffline.xcodeproj` in Xcode.
2. Select scheme `RegisterOffline`.
3. Choose iOS simulator/device.
4. Build and run.

SPM dependencies are resolved automatically by Xcode on first build.

## Demo Video

- [Watch demo (Google Drive)](https://drive.google.com/file/d/1ecFWPd4XuMVb6EkEBpQhCT4iIuXHvYEG/view?usp=sharing)

## API Configuration

Base URL and headers are configured in:
- `RegisterOffline/Core/Utils/Network/APICall.swift`

Current base URL:
- `https://api-test.partaiperindo.com/api/v1`

If needed, set `x-api-key` in `APICall.headers`.

## Project Structure

```text
RegisterOffline/
├── Coordinator/                # Navigation + route building
├── Core/
│   ├── Data/
│   │   ├── Remotes/            # API calls
│   │   ├── Repository/         # Repository contracts/impl
│   │   ├── Responses/          # DTO response models
│   │   └── Locals/             # SwiftData local persistence
│   ├── DI/                     # Dependency injection
│   └── Utils/                  # Network, modifiers, extensions
├── Modules/
│   ├── Auth/                   # Login/Register
│   ├── Documents/              # Draft + Uploaded tabs
│   ├── CreateDocuments/        # Form, Camera, Confirmation
│   ├── Profile/                # Profile screen
│   ├── Splash/                 # Initial splash
│   └── Components/             # Shared reusable UI components
└── Assets.xcassets/
```

## Main Flows

### Login/Register
- Login stores bearer token in Keychain.
- Register sends required account fields.

### Profile
- Fetches `/profile` using bearer token.
- Maps `ProfileResponse` in ViewModel to UI/domain state.

### Documents - Draft Tab
- Drafts are saved locally with SwiftData (`MemberDraftEntity`).
- Draft list is rendered from local storage.
- Each item supports `Edit`, `Delete`, `Upload`.
- `Upload Semua` loops draft uploads one-by-one (multipart) until done.

### Create Document + Camera
- Form captures identity, KTP address, domicile address.
- KTP primary and secondary photos captured via camera.
- Camera permission requested before preview.
- Captured photo is reviewed in confirmation screen.

### Upload Member
- Endpoint: `POST /member`
- Content-Type: `multipart/form-data`
- Includes text fields + `ktp_file` and `ktp_file_secondary`.
- Images are compressed before upload to respect server size limits.

## Local Storage

Drafts are stored in SwiftData:
- Entity: `MemberDraftEntity`
- Local data source: `MemberDraftLocalDataSource`
- Container bootstrap: `SwiftDataStack`

Draft status values:
- `Draft`
- `Synced`

Draft tab shows only `Draft` items.

## Permissions

Camera usage description is set in project build settings:
- `NSCameraUsageDescription`

## Notes

- Coordinator resets temporary captured photo state when opening a new Create Document flow, so previous images do not leak into a new form session.
- Response-first mapping pattern is used in data layer: remote/repository return response DTOs, then ViewModel maps to UI/domain model.
