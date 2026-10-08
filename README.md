# Learning Dashboard

## 1. Architecture

Clean/MVVM, layered as `UI → ViewModel → Repository → API + Local Storage`:

- **Presentation** — SwiftUI `View`s + `@Observable` `ViewModel`s (Login, Dashboard, CourseDetail).
- **Domain** — pure Swift models (`Course`, `Lesson`, `User`) and repository *protocols* (`CourseRepository`, `AuthRepository`). No SwiftUI or SwiftData imports.
- **Data** — `RepositoryImpl` (business rules: network-first, cache fallback, merge), `Remote` (API + DTOs), `Local` (SwiftData entities + store), `Mappers` (DTO ⇄ Entity ⇄ Domain).
- **Core** — cross-cutting pieces (`ViewState<T>`, `AppError`, `Validators`) shared by every layer.

I chose this because ViewModels and Repositories depend only on protocols, never on concrete Data types — so business logic (progress calculation, offline fallback) is testable without SwiftUI, SwiftData, or the network, and the data source (bundled JSON today, a real backend tomorrow) can be swapped behind `CourseAPI` with no change above it.

## 2. Offline Support

`CourseEntity`/`LessonEntity` (`@Model`, SwiftData) persist locally. `CourseRepositoryImpl.fetchCourses()` is network-first: fetch via `CourseAPI`, upsert into the SwiftData store (preserving already-completed lessons), and only read-through to disk. If the fetch throws, it falls back to whatever is cached and only rethrows if the cache is also empty — `isUsingCachedData` surfaces this to the UI as an offline banner. Lesson completion (`setLessonCompleted`) writes straight to SwiftData, so it survives restarts.

Note: `CourseAPI`'s current implementation (`BundledCourseAPI`) reads the mock JSON from the app bundle rather than a live network call, so the fallback path is proven via `CourseRepositoryTests` (injecting a failing fake API) rather than by toggling Wi-Fi. Swapping in a `URLSession`-based implementation is a one-line change since both conform to the same `CourseAPI` protocol.

## 3. Security

Auth tokens would go in the **Keychain** (`kSecClassGenericPassword`), not `UserDefaults` or plain files — it's encrypted at rest and scoped to the app via entitlements. I'd use `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` so the token never leaves the device via iCloud Keychain/backup and is inaccessible while locked. In production: short-lived access tokens with refresh-token rotation, never logged, and explicitly wiped from the Keychain on logout.

## 4. Scale (1M+ users, hundreds of courses)

1. **Pagination** — fetch courses in pages (cursor/offset), not the full list in one response.
2. **Incremental sync** — `ETag`/`If-Modified-Since` so unchanged courses aren't re-downloaded, plus real timestamp-based conflict resolution for progress synced across multiple devices (today's merge is a simple "keep local lessons" rule, fine for one device, not for many).
3. **Background refresh** — `BGAppRefreshTask` + push notifications for new content, instead of only syncing on foreground launch.
4. **CDN-backed media** — once courses have thumbnails/video, serve and cache them via a CDN rather than the API payload.
5. **Observability** — crash reporting, analytics, and staged rollouts (feature flags) to de-risk shipping to that many users.

## 5. Second Platform (Android)

- **Presentation**: Jetpack Compose `Screen`s + `ViewModel` (AndroidX) exposing `StateFlow`, mirroring SwiftUI `View` + `@Observable`.
- **Domain**: `Course`/`Lesson`/`User` as Kotlin data classes and repository *interfaces* — nearly a 1:1 port, since this layer has no platform dependencies.
- **Local storage**: Room (SQLite) in place of SwiftData — same `@Entity`/DAO shape, same network-first/cache-fallback logic in the repository.
- **Networking**: Retrofit/OkHttp in place of `URLSession`; Hilt for DI in place of the hand-rolled `AppContainer`.
- **State**: a Kotlin `sealed class` (idle/loading/loaded/empty/failed) in place of `ViewState<T>`, collected with `collectAsStateWithLifecycle`.
- **Auth storage**: `EncryptedSharedPreferences`/Android Keystore in place of Keychain.
