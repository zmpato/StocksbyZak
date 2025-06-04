//
//  StockModel.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/2/25.
//

import Foundation

struct Stock: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let ticker: String
    let price: Double
    let priceChange24hrs: Double
    let isFeatured: Bool
    
    
    let instanceNumber: Int
    
    
    init(id: UUID = UUID(), name: String, ticker: String, price: Double, priceChange24hrs: Double, isFeatured: Bool, instanceNumber: Int = 0) {
        self.id = id
        self.name = name
        self.ticker = ticker
        self.price = price
        self.priceChange24hrs = priceChange24hrs
        self.isFeatured = isFeatured
        self.instanceNumber = instanceNumber
    }
    
    var historicalData: [StockDataPoint] {
        var dataPoints: [StockDataPoint] = []
        let volatility = Swift.abs(priceChange24hrs) / 100
        var currentPrice = price - (priceChange24hrs / 100 * price)
        
        for i in 0..<30 {
            currentPrice += currentPrice * Double.random(in: -volatility...volatility)
            let date = Calendar.current.date(byAdding: .day, value: -29 + i, to: Date()) ?? Date()
            dataPoints.append(StockDataPoint(date: date, price: currentPrice))
        }
        if let last = dataPoints.last {
            dataPoints[dataPoints.count - 1] = StockDataPoint(date: last.date, price: price)
        }
        return dataPoints
    }
    
    static func fromJSON(_ json: [String: Any], instanceNumber: Int = 0) -> Stock? {
        guard
            let name = json["name"] as? String,
            let ticker = json["ticker"] as? String,
            let price = json["price"] as? Double,
            let priceChange24hrs = json["price_change_24hrs"] as? Double,
            let isFeatured = json["is_featured"] as? Bool
        else {
            return nil
        }
        
        return Stock(
            id: UUID(),
            name: name,
            ticker: ticker,
            price: price,
            priceChange24hrs: priceChange24hrs,
            isFeatured: isFeatured,
            instanceNumber: instanceNumber
        )
    }
    
    var uniqueIdentifier: String {
        return "\(ticker)_\(instanceNumber)"
    }
}
    
struct StockDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}
