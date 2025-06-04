# Stocks By Zak

## 🛠 Architecture Choices

- I chose MVVM for a clean separation of interests along with a service layer for loading the JSON data, I also considered if I were hypothetically building a full scale application and needed to implement thorough testing, separating these layers makes that an easier and cleaner process. 

## 📱 Functionality & Features

- The Main view has the list of stocks with requested information
- In each cell, you can select the Star icon and save this stock into your favorites tab.
- There is also a rotating carousel with featured stocks.
- Filter favorites by price change
- Any stock you select will bring you to a detail view where you can view a stock graph with historical changes and further information about the stock.

## 📦 Details

- For persistence, I opted for UserDefaults as we are working with a small amount of data. It is lightweight and less complex, perfect for this amount of data.
- I used Combine in tandem with many operations related to persistence and data loading as an opportunity to show my familiarity with this technology, and also saw it as a chance to further my understanding and uncover unfamiliar subjects related to it, despite it maybe being a bit more complicated to use that async/await.
- Combine further simplified operations related to persisting by delaying the save which I thought was useful to implement
- I also saw an opportunity to become more familiar with Swift Charts. So I used that to build some stock visuals when the user selects a stock.

## What would I change if I continued working on this application?
- I would implement a different type of data persistence other than USerDefaults to efficiently handle more users.
- I would dedicate more time to dependency injection and avoid injecting any Model directly into a View.
- I would elaborate on my Charts features with toggling the charts to see a more detailed look at the price over time.
