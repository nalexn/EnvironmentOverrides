import SwiftUI

extension SettingsView {
    struct Params {
        let locales: [Locale]
        let locale: Binding<Locale>
        let colorScheme: Binding<ColorScheme>
        let textSize: Binding<ContentSizeCategory>
    }
}

struct SettingsView: View {
    
    private let params: Params
    @State private var controlWidth: CGFloat = ControlWidth.defaultValue
    
    init(params: Params) {
        self.params = params
    }
    
    var body: some View {
        VStack {
            title.padding(.top, 10).edgePadding()
            Divider()
            themeToggle.edgePadding()
            Divider()
            if params.locales.count > 1 {
                localeSelector.edgePadding()
            }
            textSizeSlider.edgePadding()
        }
        .heightMeasurer()
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
        Toggle(isOn: colorSchemeBinding) {
            Text("Light / Dark theme").settingsStyle()
        }
    }
    
    var localeSelector: some View {
        SettingsView.Picker(
            title: "Locale", pickerWidth: controlWidth, value: params.locale,
            values: params.locales, valueTitle: { $0.identifier })
    }
    
    var textSizeSlider: some View {
        SettingsView.Slider(
            title: "Text", sliderWidth: controlWidth, value: textSizeBinding,
            stride: ContentSizeCategory.stride) {
                self.params.textSize.wrappedValue.name
            }
    }
}

// MARK: - Bindings

private extension SettingsView {
    
    var colorSchemeBinding: Binding<Bool> {
        .init(get: {
            self.params.colorScheme.wrappedValue == .dark
        }, set: {
            self.params.colorScheme.wrappedValue = $0 ? .dark : .light
        })
    }
    
    var textSizeBinding: Binding<CGFloat> {
        .init(get: {
            self.params.textSize.wrappedValue.floatValue
        }, set: {
            let index = Int(round($0 / ContentSizeCategory.stride))
            self.params.textSize.wrappedValue = ContentSizeCategory.allCases[index]
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

// MARK: - Sizing

extension SettingsView {
    struct ContentHeight: PreferenceKey {
        static var defaultValue = CGFloat.greatestFiniteMagnitude
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = min(value, nextValue())
        }
    }
}

private extension View {
    func heightMeasurer() -> some View {
        background(GeometryReader(content: { proxy in
            Color.clear.preference(key: SettingsView.ContentHeight.self,
                                   value: proxy.size.height)
                .hidden()
        }))
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

extension SettingsView.Params {
    static func preview() -> SettingsView.Params {
        SettingsView.Params(
            locales: [
                Locale(identifier: "en"),
                Locale(identifier: "ru"),
                Locale(identifier: "fr")
            ],
            locale: Binding<Locale>(wrappedValue: Locale(identifier: "en")),
            colorScheme: Binding<ColorScheme>(wrappedValue: .dark),
            textSize: Binding<ContentSizeCategory>(wrappedValue: .medium))
    }
}

struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ZStack {
                Color(UIColor.tertiarySystemBackground)
                SettingsView(params: .preview())
            }
            .colorScheme(.light)
            ZStack {
                Color(UIColor.tertiarySystemBackground)
                SettingsView(params: .preview())
            }
            .colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 300))
    }
}

#endif
