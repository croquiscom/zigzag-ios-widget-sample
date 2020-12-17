import WidgetKit
import SwiftUI

struct ConfiguableWidgetProvider: IntentTimelineProvider {
    typealias Entry = GoodsCardEntry
    typealias Intent = HomePageTypeIntent

    func placeholder(in context: Context) -> GoodsCardEntry {
        Entry(date: Date(), items: GoodsCardEntry.preview.items)
    }

    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(date: Date(), items: GoodsCardEntry.preview.items)
        completion(entry)
    }

    func getTimeline(for configuration: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        WidgetNetworkManager.loadPageItems(pageId: configuration.pageId) { result in
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

struct ConfiguableWidget: Widget {
    let kind: String = "ConfiguableWidget"

    var body: some WidgetConfiguration {
        let extractedExpr = IntentConfiguration(kind: kind,
                                                intent: HomePageTypeIntent.self,
                                                provider: ConfiguableWidgetProvider()) { entry in
            WidgetEntryView(entry: entry)
        }
        return extractedExpr
            .configurationDisplayName("지그재그")
            .description("원하는 카테고리의 상품을 확인해보세요!")
            .supportedFamilies([.systemSmall,
                                .systemMedium])
    }
}
