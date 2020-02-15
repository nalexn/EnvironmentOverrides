import SwiftUI

public extension EnvironmentValues {
    struct Diff: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let locale = Diff(rawValue: 1 << 0)
        public static let colorScheme = Diff(rawValue: 1 << 1)
        public static let sizeCategory = Diff(rawValue: 1 << 2)
        public static let layoutDirection = Diff(rawValue: 1 << 3)
        public static let accessibilityEnabled = Diff(rawValue: 1 << 4)
    }
}

public extension View {
    func attachEnvironmentOverrides(
        onChange: ((EnvironmentValues.Diff) -> Void)? = nil) -> some View {
        modifier(EnvironmentOverridesModifier(onChange: onChange))
    }
}

struct EnvironmentOverridesModifier: ViewModifier {
    
    @Environment(\.colorScheme) private var defaultColorScheme: ColorScheme
    @Environment(\.sizeCategory) private var defaultSizeCategory: ContentSizeCategory
    @Environment(\.layoutDirection) private var defaultLayoutDirection: LayoutDirection
    @Environment(\.accessibilityEnabled) private var defaultAccessibilityEnabled: Bool
    @State private var values = EnvironmentValues()
    let onChange: ((EnvironmentValues.Diff) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear { self.copyDefaultSettings() }
            .environment(\.locale, values.locale)
            .environment(\.sizeCategory, values.sizeCategory)
            .environment(\.layoutDirection, values.layoutDirection)
            .environment(\.accessibilityEnabled, values.accessibilityEnabled)
            .overlay(EnvironmentOverridesView(params: settings),
                     alignment: .bottomTrailing)
            .environment(\.sizeCategory, .medium) // fixed for the control view
            .environment(\.colorScheme, values.colorScheme)
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
            locale: $values.locale.onChange({ _ in
                self.onChange?(.locale)
            }),
            colorScheme: $values.colorScheme.onChange({ _ in
                self.onChange?(.colorScheme)
            }),
            textSize: $values.sizeCategory.onChange({ _ in
                self.onChange?(.sizeCategory)
            }),
            layoutDirection: $values.layoutDirection.onChange({ _ in
                self.onChange?(.layoutDirection)
            }),
            accessibilityEnabled: $values.accessibilityEnabled.onChange({ _ in
                self.onChange?(.accessibilityEnabled)
            }))
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
        bgView
            .overlay(EnvironmentOverridesView(params: .preview()),
                     alignment: .bottomTrailing)
            .colorScheme(.light)
    }
    
    private static var bgView: some View {
        #if os(macOS)
        return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        #else
        return Color(UIColor.systemBackground)
        #endif
    }
}

extension Binding {
    init(wrappedValue: Value) {
        var value = wrappedValue
        self.init(get: { value }, set: { value = $0 })
    }
}

#endif
