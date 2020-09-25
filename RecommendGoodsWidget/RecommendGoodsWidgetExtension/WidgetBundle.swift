import SwiftUI
import WidgetKit

@main
struct SampleWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        DefaultWidget()
        ConfiguableWidget()
    }
}
