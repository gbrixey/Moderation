import Foundation

/// Display data for a single day
struct Day {
    let id = UUID()
    let date: Date
    let mL: [DrinkType]
    let possibleML: Int?
}

enum DrinkType: Int, Codable, CaseIterable {
    case beer
    case wine
    case liquor
    case cocktail
}

class DataManager: ObservableObject {
    static let shared = DataManager()

    /// Observable display data for the `ContentView`
    @Published var days: [Day] = []

    init() {
        loadFromUserDefaults()
        calculateDisplayData()
    }

    func add(mL: Int, type: DrinkType, onDate date: Date) {
        let existingML = self.mL[date] ?? []
        let countToAdd = min(mL, maxMLDictValue - existingML.count)
        self.mL[date] = existingML + [DrinkType](repeating: type, count: countToAdd)
        calculateDisplayData()
        saveToUserDefaults()
    }

    // MARK: - Private

    private let maxMLPerDay = 60
    private let maxMLPerWeek = 140
    /// A practical upper limit on the size of the array values in the `mL` dict
    private let maxMLDictValue = 1000

    private var mL: [Date: [DrinkType]] = [:]
    private let userDefaultsKey = "com.glenb.Moderation.DataManager.mL"

    private func calculateDisplayData() {
        let firstDayToShow = -6
        var lastDayToShow = dateOfNextPossibleDrink().daysFromNow
        if lastDayToShow == 0 && amount(on: Date()) > 0 {
            lastDayToShow += 1
        }
        days = (firstDayToShow...lastDayToShow).reversed().map { daysFromNow -> Day in
            let date = Date(daysFromNow: daysFromNow)
            let mL = self.mL[date] ?? []
            // Don't show possible amounts for days in the past
            let possibleML: Int? = daysFromNow >= 0 ? self.possibleML(on: date) : nil
            return Day(date: date, mL: mL, possibleML: possibleML)
        }
    }

    private func amount(on date: Date) -> Int {
        let startOfDate = Calendar.autoupdatingCurrent.startOfDay(for: date)
        return mL[startOfDate]?.count ?? 0
    }

    private func possibleML(on date: Date) -> Int {
        let startOfDate = Calendar.autoupdatingCurrent.startOfDay(for: date)
        let amountsInPastWeek = (-6...0).map { amount(on: startOfDate.addingDays($0)) }
        // No drinking on consecutive days
        if amountsInPastWeek[5] > 0 {
            return 0
        }
        let remainingMLThisDay = max(0, maxMLPerDay - amountsInPastWeek[6])
        let remainingMLThisWeek = max(0, maxMLPerWeek - amountsInPastWeek.sum)
        return min(remainingMLThisDay, remainingMLThisWeek)
    }

    private func dateOfNextPossibleDrink() -> Date {
        var date = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        while possibleML(on: date) == 0 {
            date = date.addingDays(1)
        }
        return date
    }

    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data,
            let mL = try? JSONDecoder().decode([Date: [DrinkType]].self, from: data) {
            self.mL = mL
        }
        // Remove old data
        for date in mL.keys {
            if date.daysFromNow < -10 {
                mL.removeValue(forKey: date)
            }
        }
    }

    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(mL) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
