import Foundation

extension Date {
    init(daysFromNow: Int) {
        let date = Date(timeIntervalSinceNow: 86400 * Double(daysFromNow))
        self = Calendar.autoupdatingCurrent.startOfDay(for: date)
    }
}

extension DateFormatter {
    static var standard: DateFormatter {
        let dateFormatter = DateFormatter()
        let locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = locale
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM d", options: 0, locale: locale)
        return dateFormatter
    }
}

extension String {
    init(key: String) {
        self = NSLocalizedString(key, comment: "")
    }
}
