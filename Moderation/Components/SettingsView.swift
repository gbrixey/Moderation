import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentation
    @State private var maxMLPerDay = Double(DataManager.shared.maxMLPerDay)
    @State private var maxMLPerWeek = Double(DataManager.shared.maxMLPerWeek)
    @State private var allowDrinkingOnConsecutiveDays = DataManager.shared.allowDrinkingOnConsecutiveDays
    @State private var mLPerIcon = Double(DataManager.shared.mLPerIcon)

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text(maxMLPerDayText)
                Slider(value: self.$maxMLPerDay, in: 1...100, step: 1.0)

                Text(maxMLPerWeekText)
                    .padding([.top], 20)
                Slider(value: self.$maxMLPerWeek, in: 1...500, step: 1.0)

                HStack(spacing: 10) {
                    Text("allow.drinking.on.consecutive.days")
                    Spacer()
                    Toggle("", isOn: self.$allowDrinkingOnConsecutiveDays)
                }
                .padding([.top], 20)

                Text(mLPerIconText)
                    .padding([.top], 20)
                Slider(value: self.$mLPerIcon, in: 1...10, step: 1.0)

                Spacer()
            }
            .padding(20)
            .navigationBarTitle("settings", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private

    private var cancelButton: some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
        }, label: {
            Text("cancel")
        })
    }

    private var doneButton: some View {
        Button(action: applySettings, label: {
            Text("done")
        })
    }

    private var maxMLPerDayText: String {
        return String(format: String(key: "daily.maximum.format"), Int(maxMLPerDay))
    }

    private var maxMLPerWeekText: String {
        return String(format: String(key: "weekly.maximum.format"), Int(maxMLPerWeek))
    }

    private var mLPerIconText: String {
        return String(format: String(key: "ml.per.icon.format"), Int(mLPerIcon))
    }

    private func applySettings() {
        DataManager.shared.updateSettings(maxMLPerDay: Int(maxMLPerDay),
                                          maxMLPerWeek: Int(maxMLPerWeek),
                                          allowDrinkingOnConsecutiveDays: allowDrinkingOnConsecutiveDays,
                                          mLPerIcon: Int(mLPerIcon))
        presentation.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
