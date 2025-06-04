//
//  StockDetailView.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/2/25.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    let stock: Stock
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: StockViewModel
    @State private var selectedRange: ChartRange = .month
    
    enum ChartRange {
        case day, week, month, year
        
        var title: String {
            switch self {
            case .day: return "1D"
            case .week: return "1W"
            case .month: return "1M"
            case .year: return "1Y"
            }
        }
    }
    
    var priceColor: Color {
        stock.priceChange24hrs >= 0 ? .green : .red
    }
    
    var filteredData: [StockDataPoint] {
        let calendar = Calendar.current
        let now = Date()
        
        return stock.historicalData.filter { dataPoint in
            switch selectedRange {
            case .day:
                return calendar.isDateInToday(dataPoint.date)
            case .week:
                let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
                return dataPoint.date >= weekAgo
            case .month:
                let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
                return dataPoint.date >= monthAgo
            case .year:
                let yearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
                return dataPoint.date >= yearAgo
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(stock.name + (stock.instanceNumber > 0 ? " (\(stock.instanceNumber + 1))" : ""))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(stock.ticker)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                    }
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.toggleFavorite(for: stock)
                        }
                    }) {
                        Image(systemName: viewModel.isFavorite(stock: stock) ? "star.fill" : "star")
                            .foregroundColor(viewModel.isFavorite(stock: stock) ? .yellow : .gray)
                            .font(.title2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("$\(stock.price, specifier: "%.2f")")
                        .font(.system(size: 34, weight: .bold))
                    
                    HStack {
                        Text("\(stock.priceChange24hrs >= 0 ? "+" : "")\(stock.priceChange24hrs, specifier: "%.2f")%")
                            .foregroundColor(priceColor)
                        
                        Text("Today")
                            .foregroundColor(.gray)
                    }
                    .font(.headline)
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach([ChartRange.day, .week, .month, .year], id: \.self) { range in
                        Button(action: {
                            withAnimation {
                                selectedRange = range
                            }
                        }) {
                            Text(range.title)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedRange == range ? priceColor.opacity(0.2) : Color.clear)
                                .foregroundColor(selectedRange == range ? priceColor : .gray)
                                .cornerRadius(8)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    Chart {
                        ForEach(filteredData) { dataPoint in
                            LineMark(x: .value("Date", dataPoint.date),
                                     y: .value("Price", dataPoint.price)
                            )
                            .lineStyle(StrokeStyle(lineWidth: 2.5))
                            .foregroundStyle(priceColor.gradient)
                        }
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .frame(height: 250)
                    .padding(.vertical)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("About \(stock.name)" + (stock.instanceNumber > 0 ? " (\(stock.instanceNumber + 1))" : ""))
                        .font(.headline)
                        .font(.headline)
                    
                    Text("Market Cap: $\(Int.random(in: 10...500))B")
                    Text("P/E Ratio: \(Double.random(in: 10...50), specifier: "%.2f")")
                    Text("52-Week High: $\(stock.price * Double.random(in: 1.05...1.5), specifier: "%.2f")")
                    Text("52-Week Low: $\(stock.price * Double.random(in: 0.5...0.95), specifier: "%.2f")")
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eu nibh velit. Phasellus libero nisl, accumsan ut sollicitudin vel, feugiat sed lacus. \(stock.name) is a leading company in its industry with strong revenue growth and market position.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitle("", displayMode: .inline)
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

    StockDetailView(stock: sampleStock)
        .environmentObject(viewModel)
}
