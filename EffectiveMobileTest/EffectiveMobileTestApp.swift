//
//  EffectiveMobileTestApp.swift
//  EffectiveMobileTest
//
//  Created by Vitaly Volshin on 24/7/25.
//

import SwiftUI

@main
struct EffectiveMobileTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
