import Foundation

/// Display data for a single day
struct Day {
    let id = UUID()
    let date: Date
    let icons: [DrinkType]
    let possibleIcons: Int?
}

enum DrinkType: Int, Codable, CaseIterable {
    case beer
    case wine
    case liquor
    case cocktail
}

class DataManager: ObservableObject {
    static let shared = DataManager()

    /// Observable display data for the `MainView`
    @Published var days: [Day] = []

    private(set) var maxMLPerDay = DataManager.defaultMaxMLPerDay
    private(set) var maxMLPerWeek = DataManager.defaultMaxMLPerWeek
    private(set) var allowDrinkingOnConsecutiveDays = DataManager.defaultAllowDrinkingOnConsecutiveDays
    private(set) var mLPerIcon = DataManager.defaultMLPerIcon

    init() {
        loadFromUserDefaults()
        calculateDisplayData()
    }

    func add(mL: Int, type: DrinkType, onDate date: Date) {
        let existingEntries = self.entries[date] ?? []
        self.entries[date] = existingEntries + [DrinkEntry(type: type, mL: mL)]
        calculateDisplayData()
        saveToUserDefaults()
    }

    func updateSettings(maxMLPerDay: Int, maxMLPerWeek: Int, allowDrinkingOnConsecutiveDays: Bool, mLPerIcon: Int) {
        self.maxMLPerDay = maxMLPerDay
        self.maxMLPerWeek = maxMLPerWeek
        self.allowDrinkingOnConsecutiveDays = allowDrinkingOnConsecutiveDays
        self.mLPerIcon = mLPerIcon
        saveToUserDefaults()
        calculateDisplayData()
    }

    // MARK: - Private

    private struct DrinkEntry: Codable {
        let type: DrinkType
        let mL: Int
    }

    private let userDefaultsKeyEntries = "com.glenb.Moderation.DataManager.entries"
    private let userDefaultsKeyMaxMLPerDay = "com.glenb.Moderation.DataManager.maxMLPerDay"
    private let userDefaultsKeyMaxMLPerWeek = "com.glenb.Moderation.DataManager.maxMLPerWeek"
    private let userDefaultsKeyAllowDrinkingOnConsecutiveDays = "com.glenb.Moderation.DataManager.allowDrinkingOnConsecutiveDays"
    private let userDefaultsKeyMLPerIcon = "com.glenb.Moderation.DataManager.mLPerIcon"

    private static let defaultMaxMLPerDay = 60
    private static let defaultMaxMLPerWeek = 140
    private static let defaultAllowDrinkingOnConsecutiveDays = false
    private static let defaultMLPerIcon = 1

    private var entries: [Date: [DrinkEntry]] = [:]

    func calculateDisplayData() {
        let firstDayToShow = -6
        var lastDayToShow = dateOfNextPossibleDrink().daysFromNow
        if lastDayToShow == 0 && mL(on: Date()) > 0 {
            lastDayToShow += 1
        }
        days = (firstDayToShow...lastDayToShow).reversed().map { daysFromNow -> Day in
            let date = Date(daysFromNow: daysFromNow)
            let entries = self.entries[date] ?? []
            let icons = entries.flatMap { entry -> [DrinkType] in
                let iconCount = Int(round(Double(entry.mL) / Double(mLPerIcon)))
                return [DrinkType](repeating: entry.type, count: iconCount)
            }
            // Don't show possible amounts for days in the past
            var possibleIcons: Int?
            if daysFromNow >= 0 {
                possibleIcons = Int(round(Double(possibleML(on: date)) / Double(mLPerIcon)))
            }
            return Day(date: date, icons: icons, possibleIcons: possibleIcons)
        }
    }

    private func mL(on date: Date) -> Int {
        let startOfDate = Calendar.autoupdatingCurrent.startOfDay(for: date)
        let entries = self.entries[startOfDate] ?? []
        return entries.reduce(0) { count, entry -> Int in
            return count + entry.mL
        }
    }

    private func possibleML(on date: Date) -> Int {
        let startOfDate = Calendar.autoupdatingCurrent.startOfDay(for: date)
        let mLInPastWeek = (-6...0).map { mL(on: startOfDate.addingDays($0)) }
        if !allowDrinkingOnConsecutiveDays && mLInPastWeek[5] > 0 {
            return 0
        }
        let remainingMLThisDay = max(0, maxMLPerDay - mLInPastWeek[6])
        let remainingMLThisWeek = max(0, maxMLPerWeek - mLInPastWeek.sum)
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
        func userDefaultsInteger(key: String, defaultValue: Int) -> Int {
            let value = UserDefaults.standard.integer(forKey: key)
            return value > 0 ? value : defaultValue
        }
        maxMLPerDay = userDefaultsInteger(key: userDefaultsKeyMaxMLPerDay, defaultValue: DataManager.defaultMaxMLPerDay)
        maxMLPerWeek = userDefaultsInteger(key: userDefaultsKeyMaxMLPerWeek, defaultValue: DataManager.defaultMaxMLPerWeek)
        allowDrinkingOnConsecutiveDays = UserDefaults.standard.bool(forKey: userDefaultsKeyAllowDrinkingOnConsecutiveDays)
        mLPerIcon = userDefaultsInteger(key: userDefaultsKeyMLPerIcon, defaultValue: DataManager.defaultMLPerIcon)
        if let data = UserDefaults.standard.object(forKey: userDefaultsKeyEntries) as? Data,
            let entries = try? JSONDecoder().decode([Date: [DrinkEntry]].self, from: data) {
            self.entries = entries
        }
        // Remove old data
        for date in entries.keys {
            if date.daysFromNow < -10 {
                entries.removeValue(forKey: date)
            }
        }
    }

    private func saveToUserDefaults() {
        UserDefaults.standard.set(maxMLPerDay, forKey: userDefaultsKeyMaxMLPerDay)
        UserDefaults.standard.set(maxMLPerWeek, forKey: userDefaultsKeyMaxMLPerWeek)
        UserDefaults.standard.set(allowDrinkingOnConsecutiveDays, forKey: userDefaultsKeyAllowDrinkingOnConsecutiveDays)
        UserDefaults.standard.set(mLPerIcon, forKey: userDefaultsKeyMLPerIcon)
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: userDefaultsKeyEntries)
        }
    }
}
