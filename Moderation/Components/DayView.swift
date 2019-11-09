import SwiftUI

/// View that represents a single day.
/// Displays the date and the amount of alcohol consumed on that day.
struct DayView: View {
    let day: Day

    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 5) {
                Text(day.date.displayString)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                if totalStackCount > 0 {
                    ForEach((0...(totalStackCount / 5)), id: \.self) { index in
                        self.hStack(at: index)
                    }
                }
                if day.possibleML == 0 {
                    Text("🚫")
                }
                Spacer()
            }
            Separator(axis: .vertical)
        }
    }

    // MARK: - Private

    private var totalStackCount: Int {
        return day.mL.count + (day.possibleML ?? 0)
    }

    private func hStack(at index: Int) -> some View {
        let start = index * 5
        let end = min(totalStackCount, start + 5)
        let shouldAddSpacer = start + 5 > totalStackCount
        return HStack(spacing: 5) {
            ForEach((start..<end), id: \.self) { index in
                Text(self.string(at: index))
                    .opacity(index < self.day.mL.count ? 1.0 : 0.4)
            }
            if shouldAddSpacer {
                Spacer()
            }
        }
    }

    private func string(at index: Int) -> String {
        return String(drinkType: index < day.mL.count ? day.mL[index] : .beer)
    }
}
