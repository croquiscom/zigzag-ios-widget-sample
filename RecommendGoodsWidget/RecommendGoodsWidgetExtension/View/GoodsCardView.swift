import SwiftUI
import WidgetKit

struct GoodsCardView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var item: GoodsItem
    var textPadding: CGFloat {
        switch family {
        case .systemSmall:  return 12
        default:            return 8
        }
    }

    var font: Font {
        switch family {
        case .systemSmall:  return .system(size: 15, weight: .semibold, design: .rounded)
        default:            return .system(size: 15, weight: .semibold, design: .rounded)
        }
    }

    var body: some View {
        ZStack {
            if let url = URL(string: item.imageUrl),
               let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(16)
            } else {
                Color(.lightGray)
                    .cornerRadius(16)
                Image("smallempty_warning_24_n")
                    .unredacted()
            }
            VStack {
                Spacer()
                HStack {
                    Text(item.title)
                        .font(font)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                        .frame(width: .none, height: 20, alignment: .leading)
                        .shadow(color: .black, radius: 5, x: 2.0, y: 2.0)
                    Spacer()
                }
                .padding(textPadding)
            }
        }
    }
}
struct GoodsCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GoodsCardView(item: GoodsItem.first)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            GoodsCardView(item: GoodsItem.third)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
