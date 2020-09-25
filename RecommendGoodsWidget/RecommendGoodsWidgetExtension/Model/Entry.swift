import SwiftUI
import WidgetKit

struct GoodsCardEntry: TimelineEntry {
    let date: Date
    let items: [GoodsItem]

    var widgetUrl: URL? {
        guard let urlString = items.first?.productUrl else { return nil }
        return URL(string: urlString)
    }
}

extension GoodsCardEntry {
    static let preview = GoodsCardEntry(date: Date(), items: [
        GoodsItem.first,
        GoodsItem.second,
        GoodsItem.third,
        GoodsItem.first,
        GoodsItem.second
    ])
}
