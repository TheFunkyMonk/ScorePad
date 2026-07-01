//
//  ScorePadApp.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/29/26.
//

import SwiftUI

@main
struct ScorePadApp: App {
    var systemColorScheme: ColorScheme {
        UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }

    var body: some Scene {
        WindowGroup {
            ContentView(systemColorScheme: systemColorScheme)
        }
    }
}
