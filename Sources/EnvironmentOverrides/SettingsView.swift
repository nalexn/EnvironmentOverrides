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
        .environment(\.sizeCategory, .medium)
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
        Toggle(isOn: params.colorScheme
            .map(toValue: { $0 == .dark},
                 fromValue: { $0 ? .dark : .light })
        ) {
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
            title: "Text", sliderWidth: controlWidth,
            value: params.textSize.map(
                toValue: { $0.floatValue },
                fromValue: { ContentSizeCategory(floatValue: $0) }),
            stride: ContentSizeCategory.stride) {
                self.params.textSize.wrappedValue.name
            }
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
