import SwiftUI

public extension View {
    func attachEnvironmentOverrides() -> some View {
        modifier(EnvironmentOverridesModifier())
    }
}

struct EnvironmentOverridesModifier: ViewModifier {
    
    @Environment(\.colorScheme) private var defaultColorScheme: ColorScheme
    @Environment(\.sizeCategory) private var defaultSizeCategory: ContentSizeCategory
    @Environment(\.layoutDirection) private var defaultLayoutDirection: LayoutDirection
    @Environment(\.accessibilityEnabled) private var defaultAccessibilityEnabled: Bool
    @State private var values = EnvironmentValues()
    
    func body(content: Content) -> some View {
        content
            .onAppear { self.copyDefaultSettings() }
            .environment(\.sizeCategory, values.sizeCategory)
            .environment(\.layoutDirection, values.layoutDirection)
            .overlay(EnvironmentOverridesView(params: settings),
                     alignment: .bottomTrailing)
            .environment(\.sizeCategory, .medium)
            .environment(\.layoutDirection, .leftToRight)
            .environment(\.colorScheme, values.colorScheme)
            .environment(\.locale, values.locale)
            .environment(\.accessibilityEnabled, values.accessibilityEnabled)
    }
    
    private func copyDefaultSettings() {
        values.colorScheme = defaultColorScheme
        values.sizeCategory = defaultSizeCategory
        values.layoutDirection = defaultLayoutDirection
        values.accessibilityEnabled = defaultAccessibilityEnabled
        if let locale = EnvironmentValues.currentLocale {
            values.locale = locale
        }
    }
    
    private var settings: SettingsView.Params {
        return SettingsView.Params(
            locales: EnvironmentValues.supportedLocales,
            locale: $values.map(\.locale),
            colorScheme: $values.map(\.colorScheme),
            textSize: $values.map(\.sizeCategory),
            layoutDirection: $values.map(\.layoutDirection),
            accessibilityEnabled: $values.map(\.accessibilityEnabled))
    }
}

// MARK: -

struct EnvironmentOverridesView: View {
    
    @State private var isExpanded = false
    @State private var isHidden = false
    private let params: SettingsView.Params
    
    init(params: SettingsView.Params) {
        self.params = params
    }
    
    var body: some View {
        BaseView(isExpanded: isExpanded)
            .contentShape(TappableArea(isExpanded: isExpanded))
            .onTapGesture {
                withAnimation(.easeInOut(duration: self.duration)) {
                    self.isExpanded.toggle()
                }
            }
            .overlay(SettingsView(params: params, isHidden: $isHidden)
                .instantFade(display: isExpanded, duration: duration))
            .padding(8)
            .opacity(isHidden ? 0 : 1)
    }
    
    private var duration: TimeInterval { 0.2 }
}

private extension View {
    func instantFade(display: Bool, duration: TimeInterval) -> some View {
        opacity(display ? 1 : 0).animation(display ?
            Animation.linear(duration: 0.01).delay(duration - 0.01) :
            Animation.linear(duration: 0.01))
    }
}

struct TappableArea: Shape {
    
    let isExpanded: Bool
    
    func path(in rect: CGRect) -> Path {
        // For .contentShape() "eoFill: true" has no effect (bug in SwiftUI)
        // So have to define tappable areas manually:
        if isExpanded {
            var path = Path()
            let widthForToggle = rect.width - 60
            path.addRect(CGRect(x: 0, y: 0, width: rect.width, height: 40))
            path.addRect(CGRect(x: 0, y: 0, width: widthForToggle, height: 80))
            path.addRect(CGRect(x: 0, y: 0, width: 50, height: rect.height))
            path.addRect(CGRect(x: 0, y: rect.height - 110, width: widthForToggle, height: 70))
            return path
        } else {
            return Path(rect)
        }
        
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
