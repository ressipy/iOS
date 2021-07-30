//
//  View+Ext.swift
//  View+Ext
//
//  Created by Dennis Beatty on 7/29/21.
//

#if canImport(UIKit)
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
