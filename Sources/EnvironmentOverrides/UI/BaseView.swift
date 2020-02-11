import SwiftUI

struct BaseView: View {
    
    let isExpanded: Bool
    
    var body: some View {
        box.overlay(Group {
            if !isExpanded {
                innerElements
            }
        })
    }
}

private extension BaseView {
    
    var buttonSize: CGFloat { 44 }
    var cornerFactor: CGFloat { 0.17 }
    var toggleOffset: CGFloat { 0.19 }
    var toggleHeight: CGFloat { 0.24 }
    var strokeFactor: CGFloat { 0.09 }
    var strokeColor: Color { Color(UIColor.separator) }
    var bgColor: Color { Color(UIColor.tertiarySystemBackground) }
    
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
    static var previews: some View {
        Group {
            ZStack {
                Color(UIColor.systemBackground)
                HStack {
                    BaseView(isExpanded: false)
                    Spacer(minLength: 20)
                    BaseView(isExpanded: true)
                }.padding()
            }.colorScheme(.light)
            ZStack {
                Color(UIColor.systemBackground)
                HStack {
                    BaseView(isExpanded: false)
                    Spacer(minLength: 20)
                    BaseView(isExpanded: true)
                }.padding()
            }.colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 260, height: 200))
    }
}

#endif
