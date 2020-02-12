import SwiftUI

public extension View {
    func attachEnvironmentOverrides() -> some View {
        modifier(EnvironmentOverridesModifier())
    }
}

struct EnvironmentOverridesModifier: ViewModifier {
    
    private let defaultValues = EnvironmentValues.Reference()
    @State var values = EnvironmentValues()
    
    func body(content: Content) -> some View {
        content
            .readEnvironment(\.colorScheme, defaultValues)
            .readEnvironment(\.locale, defaultValues)
            .readEnvironment(\.sizeCategory, defaultValues)
            .onAppear { self.values = self.defaultValues.values }
            .environment(\.colorScheme, values.colorScheme)
            .environment(\.locale, values.locale)
            .environment(\.sizeCategory, values.sizeCategory)
    }
}

private extension View {
    func readEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>,
                            _ store: EnvironmentValues.Reference) -> some View {
        transformEnvironment(keyPath) {
            store.values[keyPath: keyPath] = $0
        }
    }
}

extension EnvironmentValues {
    class Reference {
        var values = EnvironmentValues()
    }
}

// MARK: -

struct EnvironmentOverridesView: View {
    
    @State private var isExpanded = true
    @State private var viewHeight: CGFloat = SettingsView.ContentHeight.defaultValue
    private let params: SettingsView.Params
    
    init(params: SettingsView.Params) {
        self.params = params
    }
    
    var body: some View {
        BaseView(isExpanded: isExpanded, height: $viewHeight)
            .overlay(SettingsView(params: params))
            .onPreferenceChange(SettingsView.ContentHeight.self) {
                self.viewHeight = $0
            }
            .onTapGesture { self.isExpanded.toggle() }
            .padding(8)
    }
}

#if DEBUG

struct EnvironmentOverridesView_Previews: PreviewProvider {
    static var previews: some View {
        Color(UIColor.systemBackground)
            .overlay(EnvironmentOverridesView(params: .preview()),
                     alignment: .bottomTrailing)
            .colorScheme(.light)
    }
}

extension Binding {
    init(wrappedValue: Value) {
        var value = wrappedValue
        self.init(get: { value }, set: { value = $0 })
    }
}

#endif
