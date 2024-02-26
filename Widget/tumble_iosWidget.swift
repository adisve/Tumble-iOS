import SwiftUI
import WidgetKit
import RealmSwift

struct tumble_iosWidget: Widget {
    let kind: String = "tumble_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if let event = entry.event {
                WidgetView(event: event)
                    .widgetBackground(Color.surface)
            } else {
                Text(LocalizedStringKey("No upcoming events available"))
            }
        }
        .configurationDisplayName("Upcoming event")
        .description("Shows the earliest upcoming event.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
