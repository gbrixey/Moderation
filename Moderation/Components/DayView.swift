import SwiftUI

/// View that represents a single day.
/// Displays the date and the amount of alcohol consumed on that day.
struct DayView: View {
    let day: Day

    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 4) {
                Text(day.date.displayString)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0))
                if totalStackCount > 0 {
                    ForEach((0...(self.totalStackCount / 5)), id: \.self) { index in
                        self.hStack(at: index)
                    }
                }
                if day.possibleIcons == 0 {
                    Text("🚫")
                }
                Spacer()
            }
            Separator(axis: .vertical)
        }
    }

    // MARK: - Private

    private var totalStackCount: Int {
        return day.icons.count + (day.possibleIcons ?? 0)
    }

    private func hStack(at index: Int) -> some View {
        let start = index * 5
        let end = min(totalStackCount, start + 5)
        let shouldAddSpacer = start + 5 > totalStackCount
        return HStack(spacing: 2) {
            ForEach((start..<end), id: \.self) { index in
                Text(self.string(at: index))
                    .opacity(index < self.day.icons.count ? 1.0 : 0.4)
            }
            if shouldAddSpacer {
                Spacer()
            }
        }
    }

    private func string(at index: Int) -> String {
        return String(drinkType: index < day.icons.count ? day.icons[index] : .beer)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(day: Day(date: Date(),
                         icons: [.beer, .beer, .beer, .beer, .beer,
                                 .beer, .beer, .beer, .beer, .beer,
                                 .wine, .wine, .wine, .wine, .wine,
                                 .wine, .wine, .wine, .wine, .wine],
                         possibleIcons: 40))
            .previewLayout(.sizeThatFits)
    }
}
