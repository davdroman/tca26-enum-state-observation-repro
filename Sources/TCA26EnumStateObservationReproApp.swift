import ComposableArchitecture2
import SwiftUI

@main
struct TCA26EnumStateObservationReproApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  @State var withoutParamsStore = Store(initialState: WithoutParams.State.first) {
    WithoutParams()
  }
  @State var withParamsStore = Store(initialState: WithParams.State.first(.init())) {
    WithParams()
  }
  @State var redrawCount = 0

  var body: some View {
    NavigationStack {
      List {
        Section("WithoutParams") {
          Text(withoutParamsStore.state.label)
            .font(.title2.monospaced())

          Button("Show First") { withoutParamsStore.send(.showFirst) }
          Button("Show Second") { withoutParamsStore.send(.showSecond) }

          Text("This label refreshes immediately.")
            .font(.footnote)
            .foregroundStyle(.secondary)
        }

        Section("WithParams") {
          Text(withParamsStore.state.label)
            .font(.title2.monospaced())

          Button("Show First") { withParamsStore.send(.showFirst) }
          Button("Show Second") { withParamsStore.send(.showSecond) }

          Text("This label stays stale until an unrelated redraw occurs.")
            .font(.footnote)
            .foregroundStyle(.secondary)
        }

        Section("Unrelated SwiftUI state") {
          Button("Force redraw (\(redrawCount))") {
            redrawCount += 1
          }
        }
      }
      .navigationTitle("Enum state repro")
    }
  }
}

@Feature
struct WithoutParams {
  enum State {
    case first
    case second
  }

  enum Action {
    case showFirst
    case showSecond
  }

  var body: some Feature {
    Update { state, action in
      switch action {
      case .showFirst:
        state = .first
      case .showSecond:
        state = .second
      }
    }
  }
}

@Feature
struct WithParams {
  enum State {
    case first(Child.State)
    case second(Child.State)
  }

  enum Action {
    case showFirst
    case showSecond
  }

  var body: some Feature {
    Update { state, action in
      switch action {
      case .showFirst:
        state = .first(.init())
      case .showSecond:
        state = .second(.init())
      }
    }
  }
}

@Feature
struct Child {
  struct State {}
  enum Action {}
}

extension WithoutParams.State {
  var label: String {
    switch self {
    case .first:
      "first"
    case .second:
      "second"
    }
  }
}

extension WithParams.State {
  var label: String {
    switch self {
    case .first:
      "first(Child.State)"
    case .second:
      "second(Child.State)"
    }
  }
}
