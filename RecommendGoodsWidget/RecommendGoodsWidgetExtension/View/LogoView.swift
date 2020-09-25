import SwiftUI
import WidgetKit

struct LogoView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("zigzaglogo_wh_24")
                    .shadow(color: .gray, radius: 4, x: 2, y: 2)
                    .unredacted()
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 12))
    }
}


struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
