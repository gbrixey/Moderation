import SwiftUI

/// View that records an amount of alcohol consumed.
struct AddView: View {
    @Environment(\.presentationMode) var presentation
    @State private var drinkType = 0
    @State private var daysFromNow = 0
    @State private var abv = ""
    @State private var mL = ""

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(spacing: 10) {
                mLTextField
                abvTextField
            }
            drinkTypePicker
            datePicker
            addButton
            Spacer()
        }
        .padding([.top], 20)
    }

    // MARK: - Private

    /// Text field for the amount of alcohol in milliliters.
    private var mLTextField: some View {
        TextField("ml", text: $mL)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .frame(width: 120)
    }

    /// Text field for the alcohol ABV percentage.
    private var abvTextField: some View {
        TextField("abv", text: $abv)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .frame(width: 120)
            .transition(.fadeAndMove(edge: .trailing))
    }

    private var drinkTypePicker: some View {
        Picker("", selection: $drinkType) {
            ForEach((0..<DrinkType.allCases.count), id: \.self) {
                Text(String(drinkType: DrinkType(rawValue: $0)!))
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .labelsHidden()
        .frame(width: 250)
    }

    /// Picker for selecting the date the alcohol was consumed.
    private var datePicker: some View {
        Picker("", selection: $daysFromNow) {
            ForEach((-6...0).reversed(), id: \.self) {
                Text(Date(daysFromNow: $0).displayString)
            }
        }
        .labelsHidden()
        .border(Color(UIColor.systemGray3))
    }

    /// Confirmation button to add the specified amount of alcohol.
    private var addButton: some View {
        Button(action: add, label: {
            Text("add")
                .bold()
                .foregroundColor(.white)
                .frame(width: 120, height: 40)
                .background(Color(UIColor.systemBlue))
                .cornerRadius(5)
        })
    }

    private func add() {
        let mL = Double(self.mL) ?? 0
        let abv = Double(self.abv) ?? 0
        let pureAlcoholML = Int(round(mL * (abv / 100)))
        let drinkType = DrinkType(rawValue: self.drinkType)!
        let date = Date(daysFromNow: self.daysFromNow)
        DataManager.shared.add(mL: pureAlcoholML, type: drinkType, onDate: date)
        self.presentation.wrappedValue.dismiss()
    }
}
