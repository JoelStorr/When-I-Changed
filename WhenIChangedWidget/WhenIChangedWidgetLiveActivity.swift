//
//  WhenIChangedWidgetLiveActivity.swift
//  WhenIChangedWidget
//
//  Created by Joel Storr on 30.12.23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WhenIChangedWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WhenIChangedWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WhenIChangedWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WhenIChangedWidgetAttributes {
    fileprivate static var preview: WhenIChangedWidgetAttributes {
        WhenIChangedWidgetAttributes(name: "World")
    }
}

extension WhenIChangedWidgetAttributes.ContentState {
    fileprivate static var smiley: WhenIChangedWidgetAttributes.ContentState {
        WhenIChangedWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WhenIChangedWidgetAttributes.ContentState {
         WhenIChangedWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WhenIChangedWidgetAttributes.preview) {
   WhenIChangedWidgetLiveActivity()
} contentStates: {
    WhenIChangedWidgetAttributes.ContentState.smiley
    WhenIChangedWidgetAttributes.ContentState.starEyes
}
