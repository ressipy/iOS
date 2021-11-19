//
//  NavigationLazyView.swift
//  NavigationLazyView
//
//  This was taken from MwcsMac's answer here:
//  https://stackoverflow.com/a/61234030/2452757
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
