//
//  FavoritesView.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/1/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: StockViewModel
    @State private var sortAscending = true
    @Environment(\.colorScheme) var colorScheme
    
    var sortedFavorites: [Stock] {
        viewModel.favoritedStocks.sorted { (a: Stock, b: Stock) in
            sortAscending
            ? a.priceChange24hrs < b.priceChange24hrs
            : a.priceChange24hrs > b.priceChange24hrs
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favoritedStocks.isEmpty {
                    VStack {
                        Image(systemName: "star.slash")
                            .font(.system(size: 72))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("No Favorites Added Yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(sortedFavorites) { stock in
                                NavigationLink(destination: StockDetailView(stock: stock)) {
                                    StocksGridView(stock: stock)
                                }
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        sortAscending.toggle()
                    }) {
                        HStack {
                            Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text("Sort")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                    }
                }
            }
        }
        .tint(Color.primary)
    }
        
}

#Preview {
    FavoritesView()
}
