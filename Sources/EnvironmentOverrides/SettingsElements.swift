import SwiftUI

extension SettingsView {
    
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
                SwiftUI.Picker("", selection: value) {
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
        
        var body: some View {
            HStack {
                Text(title).settingsStyle()
                Spacer(minLength: 8)
                SwiftUI.Slider(value: value, in: 0 ... 1, step: stride)
                    .widthMeasurer()
                    .frame(maxWidth: sliderWidth, alignment: .trailing)
                    .background(Text(valueTitle())
                        .font(.footnote).fontWeight(.light)
                        .offset(x: 0, y: 20))
            }.padding(.bottom, 14)
        }
    }
}

extension SettingsView {
    struct ControlWidth: PreferenceKey {
        static var defaultValue: CGFloat = 300
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = min(value, nextValue())
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
