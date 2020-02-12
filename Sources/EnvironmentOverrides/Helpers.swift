import SwiftUI

// MARK: - Bindings

extension Binding {
    
    func map<T>(_ keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        return .init(get: {
            self.wrappedValue[keyPath: keyPath]
        }, set: {
            self.wrappedValue[keyPath: keyPath] = $0
        })
    }
    
    func map<T>(toValue: @escaping (Value) -> T,
                fromValue: @escaping (T) -> Value) -> Binding<T> {
        return .init(get: {
            toValue(self.wrappedValue)
        }, set: { value in
            self.wrappedValue = fromValue(value)
        })
    }
}

// MARK: -

extension ContentSizeCategory {
    static var stride: CGFloat {
        return 1 / CGFloat(allCases.count)
    }
    var floatValue: CGFloat {
        let index = CGFloat(ContentSizeCategory.allCases.firstIndex(of: self) ?? 0)
        return index * ContentSizeCategory.stride
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

// MARK: -

extension EnvironmentValues {
    static var supportedLocales: [Locale] = {
        let bundle = Bundle.main
        return bundle.localizations.map { Locale(identifier: $0) }
    }()
}
