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
    
    var box: some View {
        RoundedRectangle(cornerRadius: buttonSize * (cornerFactor - strokeFactor * 0.5))
            .stroke(style: .init(lineWidth: isExpanded ? 1 : buttonSize * strokeFactor))
            .frame(width: isExpanded ? nil : buttonSize,
                   height: isExpanded ? nil : buttonSize)
    }
    
    var innerElements: some View {
        Path { path in
            let cornerRadius = buttonSize * (cornerFactor - strokeFactor * 0.5)
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
        }.stroke(lineWidth: buttonSize * strokeFactor)
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BaseView(isExpanded: false).colorScheme(.light)
            BaseView(isExpanded: true).colorScheme(.light)
            BaseView(isExpanded: false).colorScheme(.dark)
            BaseView(isExpanded: true).colorScheme(.dark)
        }
        .padding()
        .background(Color.secondary)
        .previewLayout(.fixed(width: 120, height: 120))
    }
}
