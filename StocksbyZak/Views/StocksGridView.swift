//
//  StocksGridView.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/1/25.
//

import SwiftUI

struct StocksGridView: View {
    let stock: Stock
    @EnvironmentObject var viewModel: StockViewModel
    
    var body: some View {
        
        NavigationLink(destination: StockDetailView(stock: stock)) {
            ZStack(alignment: .trailing) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(stock.name + (stock.instanceNumber > 0 ? " (\(stock.instanceNumber + 1))" : ""))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(stock.ticker)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(stock.price, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(stock.priceChange24hrs >= 0 ? "+" : "")\(stock.priceChange24hrs, specifier: "%.2f")%")
                            .font(.subheadline)
                            .foregroundColor(stock.priceChange24hrs >= 0 ? .green : .red)
                    }
                    Spacer()
                        .frame(width: 44)
                }
                .padding(.vertical, 4)
                .padding(.horizontal)
                
                Button(action: {
                    withAnimation {
                        viewModel.toggleFavorite(for: stock)
                    }
                }) {
                    Image(systemName: viewModel.isFavorite(stock: stock) ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite(stock: stock) ? .yellow : .gray)
                        .font(.title3)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.clear)
                .zIndex(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleStock = Stock(
        name: "Apple",
        ticker: "AAPL",
        price: 175.00,
        priceChange24hrs: 1.25,
        isFeatured: false,
        instanceNumber: 0
    )

    let viewModel = StockViewModel()

    StocksGridView(stock: sampleStock)
        .environmentObject(viewModel)
}

