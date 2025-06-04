//
//  StockService.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/2/25.
//

import Foundation
import Combine

struct StockService {
    static func loadStocksFromFile(named fileName: String) -> AnyPublisher<[Stock], Never> {
        Deferred {
            Future<[Stock], Error> { promise in
                guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                    promise(.failure(NSError(domain: "StockService", code: 1, userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])))
                    return
                }
                do {
                    let data = try Data(contentsOf: fileURL)
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        var seenTickers = Set<String>()
                        var uniqueStocks: [Stock] = []
                        
                        for item in jsonArray {
                            if let ticker = item["ticker"] as? String, !seenTickers.contains(ticker) {
                                seenTickers.insert(ticker)
                                if let stock = Stock.fromJSON(item) {
                                    uniqueStocks.append(stock)
                                }
                            }
                        }
                        promise(.success(uniqueStocks))
                    } else {
                        promise(.failure(NSError(domain: "StockService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .catch { error -> AnyPublisher<[Stock], Never> in
            print("Error loading stocks: \(error.localizedDescription)")
            return Just([]).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}



