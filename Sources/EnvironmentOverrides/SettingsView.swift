import SwiftUI

extension SettingsView {
    struct Params {
        let locales: [Locale]
        let locale: Binding<Locale>
        let colorScheme: Binding<ColorScheme>
        let textSize: Binding<ContentSizeCategory>
        let layoutDirection: Binding<LayoutDirection>
        let accessibilityEnabled: Binding<Bool>
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
            Group {
                themeToggle
                localeSelector.disabled(params.locales.count < 2)
                textSizeSlider
                layoutDirectionToggle
                accessibilityToggle
            }.edgePadding()
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
        SettingsView.Toggle(title: "Light or Dark",
                            value: params.colorScheme
            .map(toValue: { $0 == .dark },
                 fromValue: { $0 ? .dark : .light })
        )
    }
    
    var localeSelector: some View {
        SettingsView.Picker(
            title: "Locale", pickerWidth: controlWidth, value: params.locale,
            values: params.locales, valueTitle: { $0.identifier })
    }
    
    var textSizeSlider: some View {
        SettingsView.Slider(
            title: "Text", sliderWidth: controlWidth,
            value: params.textSize.map(
                toValue: { $0.floatValue },
                fromValue: { ContentSizeCategory(floatValue: $0) }),
            stride: ContentSizeCategory.stride) {
                self.params.textSize.wrappedValue.name
            }
    }
    
    var layoutDirectionToggle: some View {
        SettingsView.Toggle(title: "Inverse Layout",
                            value: params.layoutDirection
            .map(toValue: { $0 == .rightToLeft },
                 fromValue: { $0 ? .rightToLeft : .leftToRight })
        )
    }
    
    var accessibilityToggle: some View {
        SettingsView.Toggle(title: "Accessibility",
                            value: params.accessibilityEnabled)
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
            textSize: Binding<ContentSizeCategory>(wrappedValue: .medium),
            layoutDirection: Binding<LayoutDirection>(wrappedValue: .leftToRight),
            accessibilityEnabled: Binding<Bool>(wrappedValue: false))
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
