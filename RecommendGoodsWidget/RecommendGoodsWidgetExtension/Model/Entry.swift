import SwiftUI
import WidgetKit

struct GoodsCardEntry: TimelineEntry {
    let date: Date
    let items: [GoodsItem]
}

extension GoodsCardEntry {
    static let preview = GoodsCardEntry(date: Date(), items: [
        GoodsItem.first,
        GoodsItem.second,
        GoodsItem.third
    ])
}
