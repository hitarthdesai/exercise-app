import SwiftUI

struct AppView: View {
    @ObservedObject var appVM = AppViewModel()
    @ObservedObject var loginVM = LoginViewModel()

    fileprivate func HomeSection() -> some View {
        VStack {
            Text("Home Screen")
        }
    }
    
    var body: some View {
        TabView(selection: $appVM.tabViewSelection) {
            Text("Explore Screen")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
                .tag(AppViewModel.TabViewSelection.explore)
            HomeSection()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(AppViewModel.TabViewSelection.home)
            Text("Profile Screen")
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(AppViewModel.TabViewSelection.profile)
        }
        // The onAppear has not been tested yet
        .onAppear {
            appVM.tabViewSelection = loginVM.currentUser.isNewUser ? AppViewModel.TabViewSelection.profile : AppViewModel.TabViewSelection.home
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
