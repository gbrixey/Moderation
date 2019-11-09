import Foundation

/// Display data for a single day
struct Day {
    let id = UUID()
    let date: Date
    let amount: Int
}

class DataManager: ObservableObject {
    static let shared = DataManager()

    /// Observable display data for the `ContentView`
    @Published var days: [Day] = []

    init() {
        loadFromUserDefaults()
        calculateDisplayData()
    }

    func add(amount: Int, onDate date: Date) {
        amounts[date] = (amounts[date] ?? 0) + amount
        calculateDisplayData()
        saveToUserDefaults()
    }

    // MARK: - Private

    private var amounts: [Date: Int] = [:]
    private let userDefaultsKey = "com.glenb.Moderation.DataManager.amounts"

    private func calculateDisplayData() {
        let start = -6
        let end = 0
        days = (start...end).map { interval -> Day in
            let date = Date(daysFromNow: interval)
            return Day(date: date, amount: amounts[date] ?? 0)
        }
    }

    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data,
            let amounts = try? JSONDecoder().decode([Date: Int].self, from: data) {
            self.amounts = amounts
        }
    }

    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(amounts) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
