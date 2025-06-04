//
//  MainTabsView.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/1/25.
//

import SwiftUI

struct MainTabsView: View {
    @StateObject private var viewModel = StockViewModel()
    
    var body: some View {
        TabView {
            StockListView()
                .tabItem {
                    Label("Stocks", systemImage: "list.bullet")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
        .tint(Color.primary)
        .environmentObject(viewModel)
    }
}

#Preview {
    MainTabsView()
}
