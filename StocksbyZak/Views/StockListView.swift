//
//  StockListView.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/2/25.
//

import SwiftUI

struct StockListView: View {
    @EnvironmentObject var viewModel: StockViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                 stocksLoadingView
                }
                ScrollView {
                    VStack(spacing: 16) {
                        StocksCarouselView()
                            .padding(.top)
                        
                        VStack(alignment: .leading) {
                            Text("All Stocks")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.stocks) { stock in
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
            .navigationTitle("Stocks")
        }
    }
    var stocksLoadingView: some View {
         VStack(spacing: 16) {
             ProgressView()
                 .scaleEffect(1.5)
                 .progressViewStyle(CircularProgressViewStyle(tint: .blue))

             Text("Loading Stocks...")
                 .font(.headline)
                 .foregroundColor(.secondary)
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(Color(.systemBackground))
     }
}

#Preview {
    StockListView()
}
