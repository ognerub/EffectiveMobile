//
//  EffectiveMobileApp.swift
//  EffectiveMobile
//
//  Created by Alexander Ognerubov on 03.09.2025.
//

import SwiftUI

@main
struct EffectiveMobileApp: App {
    let persistenceController = PersistenceController()
    let loader = Loader()

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext, loader: loader)
        }
    }
}
