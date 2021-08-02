import SwiftUI

extension SettingsView {
    
    struct Toggle: View {
        
        let title: LocalizedStringKey
        let value: Binding<Bool>
        
        var body: some View {
            SwiftUI.Toggle(isOn: value) {
                Text(title).settingsStyle()
            }
        }
    }
    
    struct Picker<T>: View where T: Hashable {
        
        let title: LocalizedStringKey
        let pickerWidth: CGFloat
        let value: Binding<T>
        let values: [T]
        let valueTitle: (T) -> String
        
        var body: some View {
            HStack {
                Text(title).settingsStyle()
                Spacer(minLength: 8)
                SwiftUI.Picker("", selection: value.onChange({ _ in
                    Haptic.toggleFeedback()
                })) {
                    ForEach(values, id: \.self) { value in
                        Text(self.valueTitle(value))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .widthMeasurer()
                .frame(maxWidth: pickerWidth, alignment: .trailing)
            }
        }
    }

    struct Slider: View {
        
        let title: LocalizedStringKey
        let sliderWidth: CGFloat
        let value: Binding<CGFloat>
        let stride: CGFloat
        let valueTitle: () -> String
        @State private var isLoaded: Bool = false
        
        var body: some View {
            ZStack {
                if !isLoaded {
                    Text("")
                } else {
                    self.content
                }
            }.onAppear { self.isLoaded = true }
            .onDisappear { self.isLoaded = false }
        }

        var content: some View {
            HStack {
                Text(title).settingsStyle()
                Spacer(minLength: 8)
                SwiftUI.Slider(value: value, in: 0 ... 1, step: stride)
                    .widthMeasurer()
                    .frame(maxWidth: sliderWidth, alignment: .trailing)
                    .background(Text(valueTitle())
                        .font(.footnote).fontWeight(.light)
                        .offset(x: 0, y: 20))
            }
        }

    }
}

extension SettingsView {
    struct ControlWidth: PreferenceKey {
        static var defaultValue: CGFloat = 300
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            let next = nextValue()
            if next > 40 {
                value = min(value, nextValue())
            }
        }
    }
}

private extension View {
    func widthMeasurer() -> some View {
        background(GeometryReader(content: { proxy in
            Color.clear.preference(key: SettingsView.ControlWidth.self,
                                   value: proxy.size.width)
                .hidden()
        }))
    }
}
