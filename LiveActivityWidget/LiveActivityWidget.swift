//
//  LiveActivityWidget.swift
//  LiveActivityWidget
//
//  Created by Bartlomiej Sopala on 06/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    var status: String {
        "Status"
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), status: status)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), status: status)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
    
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, status: status)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let status: String
}

struct LiveActivityWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
        Text(entry.status)
    }
}

struct LiveActivityWidget: Widget {
    let kind: String = "LiveActivityWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LiveActivityWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct LiveActivityWidget_Previews: PreviewProvider {
    static var previews: some View {
        LiveActivityWidgetEntryView(entry: SimpleEntry(date: Date(), status: "5 minut"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
