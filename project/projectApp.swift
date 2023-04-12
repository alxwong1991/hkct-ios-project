//
//  projectApp.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI

@main
struct projectApp: App {
    @StateObject private var manager: DataManager = DataManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
