import SwiftUI

struct ShowMenuButton: View {
    var body: some View {
        Text("H")
    }
}

struct ShowMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShowMenuButton().colorScheme(.light)
            ShowMenuButton().colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 44, height: 44))
    }
}
