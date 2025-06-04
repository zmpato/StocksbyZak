//
//  StocksCarouselView.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/1/25.
//

import SwiftUI

struct StocksCarouselView: View {
    @EnvironmentObject var viewModel: StockViewModel
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        let featuredStocks = viewModel.featuredStocks
        
        VStack(alignment: .leading) {
            Text("Featured")
                .font(.headline)
                .padding(.horizontal)
            
            if featuredStocks.isEmpty {
                Text("No featured stocks available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(featuredStocks.indices, id: \.self) { index in
                        let stock = featuredStocks[index]
                        
                        NavigationLink(destination: StockDetailView(stock: stock)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(stock.name + (stock.instanceNumber > 0 ? " (\(stock.instanceNumber + 1))" : ""))
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(stock.ticker)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Text("$\(stock.price, specifier: "%.2f")")
                                        .font(.title3)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    Text("\(stock.priceChange24hrs >= 0 ? "+" : "")\(stock.priceChange24hrs, specifier: "%.2f")%")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(stock.priceChange24hrs >= 0 ? .green : .red)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .tag(index)
                        .padding(.horizontal)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 130)
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
                }
            }
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation {
                let featuredStocks = viewModel.featuredStocks
                if !featuredStocks.isEmpty {
                    currentIndex = (currentIndex + 1) % featuredStocks.count
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    StocksCarouselView()
}
