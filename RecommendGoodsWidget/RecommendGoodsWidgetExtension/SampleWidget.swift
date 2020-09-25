import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        // TODO: Placeholder는 로컬의 데이터를 사용해서 보여줘야 함.
        Entry(date: Date(), items: GoodsCardEntry.preview.items)
    }

    func getSnapshot(in context: Context, completion: @escaping (GoodsCardEntry) -> ()) {
        // TODO: Context의 isPreview일 경우, 로컬 데이터를 사용해서 보여줘야 함.
        let entry = Entry(date: Date(), items: GoodsCardEntry.preview.items)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GoodsCardEntry>) -> ()) {
        NetworkManager.loadPageItems { result in
            let currentDate = Date()

            switch result {
            case .success(let items):
                var entries: [Entry] = []

                switch context.family {
                case .systemSmall:
                    let interval = 3
                    items.enumerated().forEach { (index, item) in
                        let entryDate = Calendar.current.date(byAdding: .second, value: (index + 1) * interval, to: currentDate) ?? currentDate
                        let entry = Entry(date: entryDate, items: [item])
                        entries.append(entry)
                    }
                case .systemMedium:
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
                case .systemLarge:
                    var tempItems: [GoodsItem] = []
                    items.enumerated().forEach { (index, item) in
                        if tempItems.count == 5 {
                            let interval = 1
                            let entryDate = Calendar.current.date(byAdding: .second, value: (index + 1) * interval, to: currentDate) ?? currentDate
                            let entry = Entry(date: entryDate, items: tempItems)

                            entries.append(entry)
                            tempItems.removeAll()
                        } else {
                            tempItems.append(item)
                        }
                    }
                @unknown default:
                    fatalError()
                }

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            case .failure:
                var timelinePolicy: TimelineReloadPolicy {
                    if let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate) {
                        return .after(refreshDate)
                    } else {
                        return .atEnd
                    }
                }

                let entry = Entry(date: currentDate, items: [])
                let timeline = Timeline(entries: [entry], policy: timelinePolicy)
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
            if let widgetUrl = entry.widgetUrl {
                SmallWidgetView(entry: entry)
                    .widgetURL(widgetUrl)
            } else {
                SmallWidgetView(entry: entry)
            }
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        @unknown default:
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

struct LargeWidgetView: View {
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
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(0 ..< 3, id: \.self) { index in
                            let item = entry.items[index]
                            let url = URL(string: item.productUrl)!
                            Link(destination: url) {
                                GoodsCardView(item: item)
                            }
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(3 ..< 5, id: \.self) { index in
                            let item = entry.items[index]
                            let url = URL(string: item.productUrl)!
                            Link(destination: url) {
                                GoodsCardView(item: item)
                            }
                        }
                    }
                }
                .padding(4)
            }
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
            .configurationDisplayName("지그재그")
            .description("신상을 만나보세요!")
            .supportedFamilies([.systemSmall,
                                .systemMedium,
                                .systemLarge])
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

            SampleWidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemLarge))

            SampleWidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .redacted(reason: .placeholder)
        }
    }
}
