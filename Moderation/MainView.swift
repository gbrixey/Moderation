import SwiftUI
import Combine

/// The root view of the application.
struct MainView: View {
    @State private var showModalView = false
    @State private var modalViewType: ModalViewType = .settings
    @ObservedObject private var volumeUnitObservable = VolumeUnitObservable()
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
            .navigationBarItems(leading: settingsButton, trailing: addButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showModalView) {
            if self.modalViewType == .settings {
                SettingsView(volumeUnit: self.$volumeUnitObservable.volumeUnit)
            } else {
                AddView(volumeUnit: self.$volumeUnitObservable.volumeUnit)
            }
        }
    }

    // MARK: - Private

    private enum ModalViewType {
        case settings
        case add
    }

    private var settingsButton: some View {
        Button(action: {
            self.modalViewType = .settings
            self.showModalView = true
        }, label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color(UIColor.systemBlue))
                .frame(width: 40, height: 40, alignment: .leading)
        })
    }

    private var addButton: some View {
        Button(action: {
            self.modalViewType = .add
            self.showModalView = true
        }, label: {
            Image(systemName: "plus.circle")
                .foregroundColor(Color(UIColor.systemBlue))
                .frame(width: 40, height: 40, alignment: .trailing)
        })
    }
}

// MARK: - Observable Objects

class VolumeUnitObservable: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefaultsWrapped(key: "com.glenb.Moderation.MainView.volumeUnit", defaultValue: VolumeUnit.mL.rawValue)
    fileprivate(set) var volumeUnit: Int {
        willSet {
            objectWillChange.send()
        }
    }
}

// MARK: - Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
