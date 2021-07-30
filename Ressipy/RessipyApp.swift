//
//  RessipyApp.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

@main
struct RessipyApp: App {
    init() {
        DispatchQueue.global(qos: .userInitiated).async {
            DataImporter.shared.runImport()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RessipyTabView()
                .accentColor(.red)
        }
    }
}
