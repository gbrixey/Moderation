import SwiftUI

/// View that represents a single day.
/// Displays the date and the amount of alcohol consumed on that day.
struct DayView: View {
    let day: Day

    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 5) {
                Text(DateFormatter.standard.string(from: day.date))
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                Text("\(day.amount)")
                Spacer()
            }
            Separator(axis: .vertical)
        }
    }
}
