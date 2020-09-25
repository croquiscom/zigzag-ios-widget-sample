import SwiftUI
import WidgetKit

struct WidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            if let widgetUrl = entry.widgetUrl {
                SmallWidgetView(entry: entry)
                    .widgetURL(widgetUrl)
            } else {
                SmallWidgetView(entry: entry)
            }
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            fatalError()
        }
    }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("staticZPink600"),
                                                       Color("staticZPink400")]),
                           startPoint: .top,
                           endPoint: .bottom)

            if let item = entry.items.first {
                GoodsCardView(item: item)
                    .padding(4)
            } else {
                EmptyCardView()
                    .padding(4)
            }
            LogoView()
        }
    }
}

struct MediumWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("staticZPink600"),
                                                       Color("staticZPink400")]),
                           startPoint: .top,
                           endPoint: .bottom)

            if entry.items.isEmpty {
                EmptyCardView()
                    .padding(4)
            } else {
                HStack(spacing: 4) {
                    ForEach(0 ..< min(3, entry.items.count), id: \.self) { index in
                        let item = entry.items[index]
                        let url = URL(string: item.productUrl)!
                        Link(destination: url) {
                            GoodsCardView(item: item)
                        }
                    }
                }
                .padding(4)
            }
            LogoView()
        }
    }
}
