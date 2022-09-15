import Foundation

class AppViewModel: ObservableObject {
    enum TabViewSelection {
        case explore, home, profile
    }
    
    @Published var tabViewSelection: TabViewSelection = .home
}
