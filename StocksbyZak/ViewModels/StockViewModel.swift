//
//  StockViewModel.swift
//  StocksbyZak
//
//  Created by Zak Mills on 5/1/25.
//

import Foundation
import Combine
import Charts

class StockViewModel: ObservableObject {
    @Published var stocks: [Stock] = []
    @Published var isLoading: Bool = false
    @Published var favoriteTickers: Set<String> = [] {
        didSet {
            debouncedSave()
        }
    }
    
    private let favoritesKey = "favoriteTickers"
    
    private var saveCancellable: AnyCancellable?
    private var loadCancellable: AnyCancellable?
    
    init() {
        loadFavorites()
        loadStocksFromFile()
    }
    
    
    private func loadStocksFromFile() {
        isLoading = true
        
        loadCancellable = Just(())
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .flatMap { _ in
                StockService.loadStocksFromFile(named: "ExampleJSON")
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedStocks in
                self?.stocks = loadedStocks
                self?.isLoading = false
            }
    }

    
    private func loadFavorites() {
        if let savedTickers = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            favoriteTickers = Set(savedTickers)
        }
    }
    
    private func saveFavorites() {
        let tickers = Array(favoriteTickers)
        UserDefaults.standard.set(tickers, forKey: favoritesKey)
        UserDefaults.standard.synchronize()
    }
    
    private func debouncedSave() {
        saveCancellable?.cancel()
        saveCancellable = Just(())
            .delay(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveFavorites()
            }
    }
    
    func toggleFavorite(for stock: Stock) {
        if favoriteTickers.contains(stock.ticker) {
            favoriteTickers.remove(stock.ticker)
        } else {
            favoriteTickers.insert(stock.ticker)
        }
    }
    
    func isFavorite(stock: Stock) -> Bool {
        return favoriteTickers.contains(stock.ticker)
    }
    
    var favoritedStocks: [Stock] {
        return stocks.filter { favoriteTickers.contains($0.ticker) }
    }
    
    var featuredStocks: [Stock] {
        return stocks.filter { $0.isFeatured }
    }
    
}
