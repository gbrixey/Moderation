import SwiftUI

/// View that records an amount of alcohol consumed.
struct AddView: View {
    @Environment(\.presentationMode) var presentation
    @State private var daysFromNow = 0
    @State private var amount = ""

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            textField
            datePicker
            addButton
            Spacer()
        }
    }

    // MARK: - Private

    /// Text field for the amount of alcohol in milliliters.
    private var textField: some View {
        TextField(String(key: "ml.placeholder"), text: $amount)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
            .frame(width: 100)
            .padding([.top], 20)
    }

    /// Picker for selecting the date the alcohol was consumed.
    private var datePicker: some View {
        Picker("", selection: $daysFromNow) {
            ForEach((-6...0).reversed(), id: \.self) {
                Text(DateFormatter.standard.string(from: Date(daysFromNow: $0)))
            }
        }
        .labelsHidden()
        .border(Color(UIColor.systemGray3))
    }

    /// Confirmation button to add the specified amount of alcohol.
    private var addButton: some View {
        Button(action: {
            let amountInt = Int(self.amount)!
            let date = Date(daysFromNow: self.daysFromNow)
            DataManager.shared.add(amount: amountInt, onDate: date)
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
