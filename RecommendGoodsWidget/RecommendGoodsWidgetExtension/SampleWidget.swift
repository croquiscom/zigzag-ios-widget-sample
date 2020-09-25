import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), items: [.first, .second, .third])
    }

    func getSnapshot(in context: Context, completion: @escaping (GoodsCardEntry) -> ()) {
        let entry = Entry(date: Date(), items: [.first, .second, .third])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoodsCardEntry>) -> ()) {
        NetworkManager.loadPageItems { result in
            let currentDate = Date()

            switch result {
            case .success(let items):
                var entries: [Entry] = []
                if context.family == .systemSmall {
                    let interval = 3
                    items.enumerated().forEach { (index, item) in
                        let entryDate = Calendar.current.date(byAdding: .second, value: (index + 1) * interval, to: currentDate) ?? currentDate
                        let entry = Entry(date: entryDate, items: [item])
                        entries.append(entry)
                    }
                } else {
                    var tempItems: [GoodsItem] = []
                    items.enumerated().forEach { (index, item) in
                        if tempItems.count == 3 {
                            let interval = 1
                            let entryDate = Calendar.current.date(byAdding: .second, value: (index + 1) * interval, to: currentDate) ?? currentDate
                            let entry = Entry(date: entryDate, items: tempItems)
                            entries.append(entry)
                            tempItems.removeAll()
                        } else {
                            tempItems.append(item)
                        }
                    }
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            case .failure:
                // TODO: Default item for Error
                let entry = Entry(date: currentDate, items: [])
                let timeline = Timeline(entries: [entry], policy: .never)
                completion(timeline)
            }
        }
    }
}

struct SampleWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    @ViewBuilder
        var body: some View {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
                    .widgetURL(URL(string: entry.items.first!.productUrl)!)
            case .systemMedium:
                MediumWidgetView(entry: entry)
                    .widgetURL(URL(string: entry.items.first!.productUrl)!)
            default:
                GoodsCardView(item: .first)
            }
        }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            GoodsCardView(item: entry.items.first!)
            LogoView()
        }
    }
}

struct MediumWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                ForEach(0 ..< min(3, entry.items.count), id: \.self) { index in
                    let item = entry.items[index]
                    let url = URL(string: item.productUrl)!
                    Link(destination: url) {
                        GoodsCardView(item: item)
                    }
                }
            }
            .padding(.all, 8)
            LogoView()
        }
    }
}

@main
struct SampleWidget: Widget {
    let kind: String = "SampleWidget"

    var body: some WidgetConfiguration {
        let extractedExpr = StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SampleWidgetEntryView(entry: entry)
        }
        return extractedExpr
            .configurationDisplayName("직잭 신상")
            .description("신상을 만나보세요!")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct SampleWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SampleWidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            SampleWidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)

            SampleWidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            SampleWidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .redacted(reason: .placeholder)
        }
    }
}
