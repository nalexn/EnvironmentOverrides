import SwiftUI

struct SettingsView: View {
    
    let locales: [Locale]
    @Binding var locale: Locale
    @Binding var colorScheme: Bool
    @Binding var textSize: ContentSizeCategory
    @State private var controlWidth: CGFloat = ControlWidth.defaultValue
    
    var body: some View {
        VStack {
            title.edgePadding()
            Divider()
            themeToggle.edgePadding()
            Divider()
            if locales.count > 1 {
                localeSelector.edgePadding()
            }
            textSizeSlider.edgePadding()
        }
        .onPreferenceChange(ControlWidth.self) {
            self.controlWidth = $0
        }
    }
}

private extension SettingsView {
    
    var title: some View {
        Text("Environment Overrides").font(.subheadline).bold()
    }
    
    var themeToggle: some View {
        Toggle(isOn: $colorScheme) {
            Text("Light / Dark theme").settingsStyle()
        }
    }
    
    var localeSelector: some View {
        SettingsView.Picker(
            title: "Locale", pickerWidth: controlWidth, value: $locale,
            values: locales, valueTitle: { $0.identifier })
    }
    
    var textSizeSlider: some View {
        SettingsView.Slider(
            title: "Text", sliderWidth: controlWidth, value: textSizeBinding,
            stride: ContentSizeCategory.stride) {
                self.textSize.name
            }
    }
}

// MARK: - Bindings

private extension SettingsView {
    
    var textSizeBinding: Binding<CGFloat> {
        .init(get: {
            self.textSize.floatValue
        }, set: {
            let index = Int(round($0 / ContentSizeCategory.stride))
            self.textSize = ContentSizeCategory.allCases[index]
        })
    }
}

// MARK: - Styling

extension Text {
    func settingsStyle() -> Text {
        font(.footnote).bold()
    }
}

private extension View {
    func edgePadding() -> some View {
        padding([.leading, .trailing], 8)
    }
}

// MARK: - Helpers

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

#if DEBUG

struct SettingsView_Previews: PreviewProvider {
    
    static var boolBinding = Binding(wrappedValue: true)
    static var textSizeBinding = Binding(wrappedValue: ContentSizeCategory.extraExtraLarge)
    static var localeBinding = Binding(wrappedValue: locales[0])
    static var locales: [Locale] {
        [
            Locale(identifier: "en"),
            Locale(identifier: "ru"),
            Locale(identifier: "fr")
        ]
    }
    
    static var previews: some View {
        Group {
            ZStack {
                Color(UIColor.systemBackground)
                SettingsView(locales: locales,
                             locale: localeBinding,
                             colorScheme: boolBinding,
                             textSize: textSizeBinding)
            }
            .colorScheme(.light)
            ZStack {
                Color(UIColor.systemBackground)
                SettingsView(locales: locales,
                             locale: localeBinding,
                             colorScheme: boolBinding,
                             textSize: textSizeBinding)
            }
            .colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 300))
    }
}

extension Binding {
    init(wrappedValue: Value) {
        var value = wrappedValue
        self.init(get: { value }, set: { value = $0 })
    }
}

#endif
