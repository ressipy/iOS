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
//        let qos = DataImporter.shared.lastSyncedAt == nil ? DispatchQoS.QoSClass.userInitiated : DispatchQoS.QoSClass.utility
//
//        DispatchQueue.global(qos: qos).async {
//            DataImporter.shared.runImport()
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            RessipyTabView()
                .accentColor(.red)
                .onOpenURL { url in
                    guard url.isUniversalLink, url.pathComponents.indices.contains(1) else { return }
                    
                    switch url.pathComponents[1] {
                    case "recipes":
                        if url.pathComponents.indices.contains(2) {
                            NavigationManager.shared.openRecipe(slug: url.pathComponents[2])
                        }
                        break;
                    case "categories":
                        if url.pathComponents.indices.contains(2) {
                            NavigationManager.shared.openCategory(slug: url.pathComponents[2])
                        }
                        break;
                    default:
                        break;
                    }
                }
        }
    }
}
