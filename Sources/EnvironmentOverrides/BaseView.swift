import SwiftUI

struct BaseView: View {
    
    let isExpanded: Bool
    
    var body: some View {
        box
            .frame(maxWidth: isExpanded ? expandedSize.width : buttonSize,
                   maxHeight: isExpanded ? expandedSize.height : buttonSize,
                   alignment: .bottomTrailing)
            .overlay(innerElements.opacity(isExpanded ? 0 : 1), alignment: .bottomTrailing)
    }
}

private extension BaseView {
    
    var expandedSize: CGSize { CGSize(width: 300, height: 278) }
    var buttonSize: CGFloat { 44 }
    var cornerFactor: CGFloat { 0.17 }
    var toggleOffset: CGFloat { 0.19 }
    var toggleHeight: CGFloat { 0.24 }
    var strokeFactor: CGFloat { 0.09 }
    #if os(macOS)
    var strokeColor: Color { Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)) }
    var bgColor: Color { Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) }
    #else
    var strokeColor: Color { Color(UIColor.separator) }
    var bgColor: Color { Color(UIColor.tertiarySystemBackground) }
    #endif
    
    var box: some View {
        ZStack {
            RoundedRectangle(cornerRadius: buttonSize * cornerFactor - strokeWidth)
                .inset(by: -0.5 * strokeWidth)
            .fill(bgColor)
            RoundedRectangle(cornerRadius: buttonSize * cornerFactor - strokeWidth)
                .stroke(strokeColor, style: strokeStyle)
        }
        .frame(width: isExpanded ? nil : buttonSize,
               height: isExpanded ? nil : buttonSize)
    }
    
    var innerElements: some View {
        Path { path in
            let cornerRadius = buttonSize * cornerFactor - 0.5 * strokeWidth
            let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
            path.addRoundedRect(in: CGRect(
                x: buttonSize * toggleOffset,
                y: buttonSize * toggleOffset,
                width: buttonSize * (1 - 2 * toggleOffset),
                height: buttonSize * toggleHeight), cornerSize: cornerSize)
            path.addRoundedRect(in: CGRect(
                x: buttonSize * (1 - toggleOffset) - buttonSize * toggleHeight,
                y: buttonSize * toggleOffset,
                width: buttonSize * toggleHeight,
                height: buttonSize * toggleHeight), cornerSize: cornerSize)
            path.addRoundedRect(in: CGRect(
                x: buttonSize * toggleOffset,
                y: buttonSize * (1 - toggleOffset - toggleHeight),
                width: buttonSize * (1 - 2 * toggleOffset),
                height: buttonSize * toggleHeight), cornerSize: cornerSize)
            path.addRoundedRect(in: CGRect(
                x: buttonSize * toggleOffset,
                y: buttonSize * (1 - toggleOffset - toggleHeight),
                width: buttonSize * toggleHeight,
                height: buttonSize * toggleHeight), cornerSize: cornerSize)
        }
        .stroke(strokeColor, style: strokeStyle)
        .frame(width: buttonSize, height: buttonSize)
    }
    
    var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: strokeWidth)
    }
    
    var strokeWidth: CGFloat {
        isExpanded ? 1 : buttonSize * strokeFactor
    }
}

#if DEBUG

struct BaseView_Previews: PreviewProvider {
    
    static let height = Binding<CGFloat>(wrappedValue: 140)
    
    static var previews: some View {
        Group {
            ZStack {
                bgView
                HStack {
                    BaseView(isExpanded: false)
                    Spacer(minLength: 20)
                    BaseView(isExpanded: true)
                }.padding()
            }.colorScheme(.light)
            ZStack {
                bgView
                HStack {
                    BaseView(isExpanded: false)
                    Spacer(minLength: 20)
                    BaseView(isExpanded: true)
                }.padding()
            }.colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 260, height: 200))
    }
    
    private static var bgView: some View {
        #if os(macOS)
        return Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        #else
        return Color(UIColor.systemBackground)
        #endif
    }
}

#endif
