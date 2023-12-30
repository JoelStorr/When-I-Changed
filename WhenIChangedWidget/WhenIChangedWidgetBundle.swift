//
//  WhenIChangedWidgetBundle.swift
//  WhenIChangedWidget
//
//  Created by Joel Storr on 30.12.23.
//

import WidgetKit
import SwiftUI

@main
struct WhenIChangedWidgetBundle: WidgetBundle {
    var body: some Widget {
        WhenIChangedWidget()
        WhenIChangedWidgetLiveActivity()
    }
}
