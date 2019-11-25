import SwiftUI

/// The root view of the application.
struct MainView: View {
    @State private var showAddView = false
    @ObservedObject private var dataManager = DataManager.shared

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView([.horizontal], showsIndicators: false) {
                    HStack(spacing: 15) {
                        Separator(axis: .vertical)
                        ForEach(dataManager.days, id: \.id) {
                            DayView(day: $0)
                        }
                    }
                }
                Separator(axis: .horizontal)
            }
            .navigationBarTitle(Text("moderation"), displayMode: .inline)
            .navigationBarItems(trailing: addButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
