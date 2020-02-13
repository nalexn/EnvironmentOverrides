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
    @Binding private var isHidden: Bool
    @State private var controlWidth: CGFloat = ControlWidth.defaultValue
    
    init(params: Params, isHidden: Binding<Bool>) {
        self.params = params
        _isHidden = isHidden
    }
    
    var body: some View {
        VStack {
            title.edgePadding()
            Divider()
            Group {
                themeToggle
                localeSelector.disabled(params.locales.count < 2)
                textSizeSlider
                layoutDirectionToggle
                accessibilityToggle
                screenshotButton
            }.edgePadding()
        }.padding([.top, .bottom], 10)
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
    
    var screenshotButton: some View {
        Button(action: {
            self.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if ScreenshotGenerator.takeScreenshot() {
                    Haptic.successFeedback()
                } else {
                    Haptic.errorFeedback()
                }
                self.isHidden = false
            }
        }, label: { Text("Take Screenshot") })
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
                SettingsView(params: .preview(), isHidden: Binding<Bool>(wrappedValue: false))
            }
            .colorScheme(.light)
            ZStack {
                Color(UIColor.tertiarySystemBackground)
                SettingsView(params: .preview(), isHidden: Binding<Bool>(wrappedValue: false))
            }
            .colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 300))
    }
}

#endif
