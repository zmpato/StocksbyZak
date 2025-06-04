//
//  StocksbyZakApp.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/1/25.
//

import SwiftUI

@main
struct StocksbyZakApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabsView()
                .preferredColorScheme(.dark)
        }
    }
}
