//
//  RessipyApp.swift
//  Ressipy
//
//  Created by Dennis Beatty on 7/5/21.
//

import SwiftUI

@main
struct RessipyApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryListView()
                .accentColor(.red)
        }
    }
}
