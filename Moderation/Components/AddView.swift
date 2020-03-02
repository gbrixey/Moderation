import SwiftUI

/// View that records an amount of alcohol consumed.
struct AddView: View {
    @Environment(\.presentationMode) var presentation
    @Binding var volumeUnit: Int
    @State private var drinkType = 0
    @State private var daysFromNow = 0
    @State private var abv = ""
    @State private var amount = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: spacing) {
                HStack(spacing: spacing) {
                    amountTextField
                    abvTextField
                }
                drinkTypePicker
                datePicker
                Spacer()
            }
            .padding([.top], 20)
            .navigationBarTitle("add", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: doneButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private

    private let spacing: CGFloat = 10
    private let controlWidth: CGFloat = 320

    private var volumeUnitEnum: VolumeUnit {
        return VolumeUnit(rawValue: volumeUnit)!
    }

    private var cancelButton: some View {
        Button(action: dismiss, label: {
            Text("cancel")
        })
    }

    private var doneButton: some View {
        Button(action: add, label: {
            Text("done")
        })
    }

    /// Text field for the amount of alcohol in milliliters.
    private var amountTextField: some View {
        TextField(String(volumeUnit: volumeUnitEnum), text: $amount)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .frame(width: (controlWidth - spacing) / 2)
    }

    /// Text field for the alcohol ABV percentage.
    private var abvTextField: some View {
        TextField("abv", text: $abv)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.decimalPad)
            .frame(width: (controlWidth - spacing) / 2)
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
        .frame(width: controlWidth)
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

    private func add() {
        let amount = Double(self.amount) ?? 0
        guard amount > 0 else {
            return dismiss()
        }
        let mL = amount * volumeUnitEnum.mLMultiplier
        let abv = Double(self.abv) ?? 0
        let pureAlcoholML = Int(round(mL * (abv / 100)))
        let drinkType = DrinkType(rawValue: self.drinkType)!
        let date = Date(daysFromNow: daysFromNow)
        DataManager.shared.add(mL: pureAlcoholML, type: drinkType, onDate: date)
        dismiss()
    }

    private func dismiss() {
        presentation.wrappedValue.dismiss()
    }
}

// MARK: - Previews

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(volumeUnit: .constant(VolumeUnit.mL.rawValue))
    }
}
