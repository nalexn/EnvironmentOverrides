import SwiftUI

// MARK: - Bindings

extension Binding {
    
    func map<T>(toValue: @escaping (Value) -> T,
                fromValue: @escaping (T) -> Value) -> Binding<T> {
        return .init(get: {
            toValue(self.wrappedValue)
        }, set: { value in
            self.wrappedValue = fromValue(value)
        })
    }
    
    func onChange(_ perform: @escaping (Value) -> Void) -> Binding<Value> {
        return .init(get: {
            self.wrappedValue
        }, set: { value in
            self.wrappedValue = value
            perform(value)
        })
    }
}

// MARK: - EnvironmentValues

extension ContentSizeCategory {
    
    static var stride: CGFloat {
        return 1 / CGFloat(allCases.count - 1)
    }
    
    var floatValue: CGFloat {
        let index = CGFloat(ContentSizeCategory.allCases.firstIndex(of: self) ?? 0)
        return index * ContentSizeCategory.stride
    }
    
    init(floatValue: CGFloat) {
        let index = Int(round(floatValue / ContentSizeCategory.stride))
        self = ContentSizeCategory.allCases[index]
    }
    
    var name: String {
        switch self {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .extraLarge: return "XL"
        case .extraExtraLarge: return "XXL"
        case .extraExtraExtraLarge: return "XXXL"
        case .accessibilityMedium: return "Accessibility M"
        case .accessibilityLarge: return "Accessibility L"
        case .accessibilityExtraLarge: return "Accessibility XL"
        case .accessibilityExtraExtraLarge: return "Accessibility XXL"
        case .accessibilityExtraExtraExtraLarge: return "Accessibility XXXL"
        @unknown default: return "Unknown"
        }
    }
}

extension EnvironmentValues {
    
    static var supportedLocales: [Locale] = {
        let bundle = Bundle.main
        return bundle.localizations.map { Locale(identifier: $0) }
    }()
    
    static var currentLocale: Locale? {
        let current = Locale.current
        let fullId = current.identifier
        let shortId = String(fullId.prefix(2))
        return supportedLocales.locale(withId: fullId) ??
            supportedLocales.locale(withId: shortId)
    }
    
    static var isMac: Bool {
        #if targetEnvironment(macCatalyst) || os(macOS)
        return true
        #else
        return false
        #endif
    }
}

private extension Array where Element == Locale {
    func locale(withId identifier: String) -> Element? {
        first(where: { $0.identifier.hasPrefix(identifier) })
    }
}

// MARK: - ScreenshotGenerator

struct ScreenshotGenerator { }

extension ScreenshotGenerator {
    
    @discardableResult
    static func takeScreenshot() -> Bool {
        #if !os(macOS)
        let view = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        #endif
        return true
    }
}

// MARK: - Haptic

struct Haptic {
    
    static func successFeedback() {
        #if !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
    
    static func errorFeedback() {
        #if !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }
    
    static func toggleFeedback() {
        #if !os(macOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }
}
