# TCA26 Enum State Observation Repro

This iOS app reproduces a SwiftUI refresh issue in TCA26 enum state observation.

`WithoutParams.State` has parameterless enum cases and refreshes as expected. `WithParams.State` has enum cases with `Child.State` payloads. Its state changes, but SwiftUI does not repaint until another view state change forces a redraw.

The app API involved is a SwiftUI view reading `store.state` in `body`.

## Reproduce

1. Open `TCA26EnumStateObservationRepro.xcodeproj` in Xcode.
2. Run the `TCA26EnumStateObservationRepro` scheme on an iOS simulator.
3. In the `WithoutParams` section, tap `First` and `Second`. The displayed state changes immediately.
4. In the `WithParams` section, tap `First` and `Second`. The displayed state does not change.
5. Tap `Force redraw`. The `WithParams` label catches up, which shows the store state changed but SwiftUI was not invalidated.

The project tracks the `main` branch of `pointfreeco/TCA26`.

## Project Generation

The Xcode project is checked in. To regenerate it after editing `project.yml`, run:

```sh
xcodegen generate
```
