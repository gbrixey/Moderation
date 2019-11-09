import SwiftUI

/// The root view of the application.
struct ContentView: View {
    @State private var showAddView = false
    @ObservedObject private var dataManager = DataManager.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView([.horizontal], showsIndicators: false) {
                    HStack(spacing: 20) {
                        Separator(axis: .vertical)
                        ForEach(dataManager.days, id: \.id) {
                            DayView(day: $0)
                        }
                    }
                }
                Separator(axis: .horizontal)
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: addButton)
        }
        .sheet(isPresented: $showAddView) {
            AddView()
        }
    }

    // MARK: - Private

    private var addButton: some View {
        Button(action: {
            self.showAddView = true
        }, label: {
            Image(systemName: "plus.circle")
                .foregroundColor(Color(UIColor.systemBlue))
                .frame(width: 40, height: 40, alignment: .trailing)
        })
    }
}
