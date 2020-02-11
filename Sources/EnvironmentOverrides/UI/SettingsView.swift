import SwiftUI

struct SettingsView: View {
    
    let locales: [Locale]
    @Binding var locale: Locale
    @Binding var colorScheme: Bool
    @Binding var textSize: ContentSizeCategory
    
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
        HStack {
            Text("Locale").settingsStyle()
            Spacer(minLength: 0)
            Picker("", selection: $locale) {
                ForEach(locales, id: \.self) { locale in
                    Text(locale.identifier)
                }
            }.pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 100, alignment: .trailing)
        }
    }
    
    var textSizeSlider: some View {
        SliderSettingView(
            title: "Text", value: textSizeBinding,
            stride: ContentSizeCategory.stride) {
                self.textSize.name
            }
    }
}

private struct SliderSettingView: View {
    
    let title: LocalizedStringKey
    let value: Binding<CGFloat>
    let stride: CGFloat
    let valueTitle: () -> String
    
    var body: some View {
        HStack {
            Text(title).settingsStyle()
            Spacer(minLength: 8)
            Slider(value: value, in: 0 ... 1, step: stride)
                .frame(maxWidth: 150, alignment: .trailing)
                .background(Text(valueTitle())
                    .font(.footnote).fontWeight(.light)
                    .offset(x: 0, y: 20))
        }.padding(.bottom, 14)
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

// MARK: - Helpers

private extension Text {
    func settingsStyle() -> Text {
        font(.footnote).bold()
    }
}

private extension View {
    func edgePadding() -> some View {
        padding([.leading, .trailing], 8)
    }
}

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

// MARK: - Previews

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
