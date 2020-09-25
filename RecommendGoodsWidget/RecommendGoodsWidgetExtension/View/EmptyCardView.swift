import SwiftUI
import WidgetKit

struct EmptyCardView: View {
    var body: some View {
        ZStack {
            Color(.lightGray)
                .cornerRadius(16)
        }
    }
}

struct EmptyCardView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCardView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
