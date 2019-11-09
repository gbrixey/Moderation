import SwiftUI

/// View that records an amount of alcohol consumed.
struct AddView: View {
    @Environment(\.presentationMode) var presentation
    @State private var drinkType = 0
    @State private var daysFromNow = 0
    @State private var mL = ""

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            typePicker
            textField
            datePicker
            addButton
            Spacer()
        }
    }

    // MARK: - Private

    private var typePicker: some View {
        Picker("", selection: $drinkType) {
            ForEach((0..<DrinkType.allCases.count), id: \.self) {
                Text(String(drinkType: DrinkType(rawValue: $0)!))
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .labelsHidden()
        .padding([.top, .leading, .trailing], 20)
    }

    /// Text field for the amount of alcohol in milliliters.
    private var textField: some View {
        TextField(String(key: "ml.placeholder"), text: $mL)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .frame(width: 100)
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
        Button(action: {
            let mL = Int(self.mL) ?? 0
            let drinkType = DrinkType(rawValue: self.drinkType)!
            let date = Date(daysFromNow: self.daysFromNow)
            DataManager.shared.add(mL: mL, type: drinkType, onDate: date)
            self.presentation.wrappedValue.dismiss()
        }, label: {
            Text("add.button")
                .bold()
                .foregroundColor(.white)
                .frame(width: 120, height: 40)
                .background(Color(UIColor.systemBlue))
                .cornerRadius(5)
        })
    }
}
