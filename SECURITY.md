# Build-time API configuration

The API key previously committed to the Flutter client must be rotated by the backend administrator. Build with a fresh value supplied through --dart-define=TSC_API_KEY=... outside source control. There is no fallback credential in source.

Build-time configuration prevents accidental source disclosure, but a key embedded in a distributed mobile application remains extractable. Replace the shared key with user-based authentication for a durable security boundary. Coordinate backend rotation with mobile releases. This source cleanup does not change the running backend or installed applications.
