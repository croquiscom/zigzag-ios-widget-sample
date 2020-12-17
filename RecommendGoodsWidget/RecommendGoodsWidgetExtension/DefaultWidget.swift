import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GoodsCardEntry {
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
                default:
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

struct DefaultWidget: Widget {
    let kind: String = "DefaultWidget"

    var body: some WidgetConfiguration {
        let extractedExpr = StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        return extractedExpr
            .configurationDisplayName("지그재그")
            .description("신상을 만나보세요!")
            .supportedFamilies([.systemSmall,
                                .systemMedium])
    }
}

struct DefaultWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            WidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)

            WidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            WidgetEntryView(entry: GoodsCardEntry.preview)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .redacted(reason: .placeholder)
        }
    }
}
