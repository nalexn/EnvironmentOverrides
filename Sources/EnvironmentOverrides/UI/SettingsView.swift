import SwiftUI

struct SettingsView: View {
    
    @Binding var colorScheme: Bool
    @Binding var textSize: ContentSizeCategory
    
    var body: some View {
        VStack {
            Text("Environment Overrides").settingsStyle()
            Divider()
            Toggle(isOn: $colorScheme) {
                Text("Light / Dark theme").settingsStyle()
            }.edgePadding()
            HStack {
                Text("Text").settingsStyle()
                Spacer(minLength: 0)
                Slider(value: textSizeBinding, in: 0 ... 1,
                       step: ContentSizeCategory.stride)
                    .frame(maxWidth: 150, alignment: .trailing)
                    .background(Text(textSize.name)
                        .font(.footnote).fontWeight(.light)
                        .offset(x: 0, y: 20))
            }.padding(.bottom, 14).edgePadding()
        }.background(Color.red)
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
    
    static var previews: some View {
        Group {
            SettingsView(colorScheme: boolBinding,
                         textSize: textSizeBinding)
                .colorScheme(.light)
            SettingsView(colorScheme: boolBinding,
                         textSize: textSizeBinding)
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
