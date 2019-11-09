import Foundation

// MARK: - Collection extensions

extension Collection where Element: Numeric {
    var sum: Element {
        reduce(0, +)
    }
}

// MARK: - Date extensions

extension Date {
    static var secondsInOneDay: TimeInterval { 86400 }

    var daysFromNow: Int {
        let calendar = Calendar.autoupdatingCurrent
        let startOfDay = calendar.startOfDay(for: self)
        let startOfToday = calendar.startOfDay(for: Date())
        return Int(round(startOfDay.timeIntervalSince(startOfToday) / Date.secondsInOneDay))
    }

    var displayString: String {
        switch daysFromNow {
        case -1:
            return String(key: "yesterday")
        case 0:
            return String(key: "today")
        case 1:
            return String(key: "tomorrow")
        default:
            let dateFormatter = DateFormatter()
            let locale = Locale.autoupdatingCurrent
            dateFormatter.timeZone = .autoupdatingCurrent
            dateFormatter.locale = locale
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM d", options: 0, locale: locale)
            return dateFormatter.string(from: self)
        }
    }

    init(daysFromNow: Int) {
        let date = Date(timeIntervalSinceNow: Date.secondsInOneDay * Double(daysFromNow))
        self = Calendar.autoupdatingCurrent.startOfDay(for: date)
    }

    func addingDays(_ days: Int) -> Date {
        return addingTimeInterval(Double(days) * Date.secondsInOneDay)
    }
}

// MARK: - String extensions

extension String {
    init(key: String) {
        self = NSLocalizedString(key, comment: "")
    }

    init(drinkType: DrinkType) {
        switch drinkType {
        case .beer:
            self = "🍺"
        case .wine:
            self = "🍷"
        case .liquor:
            self = "🥃"
        case .cocktail:
            self = "🍸"
        }
    }
}
