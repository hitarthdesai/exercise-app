import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AppView: View {
    @ObservedObject var appVM = AppViewModel()
    @ObservedObject var loginVM = LoginViewModel()
    @ObservedObject var firebaseSDK = FirebaseSDK()

    fileprivate func HomeSection() -> some View {
        VStack {
            Text("Home Screen")
        }
    }
    
    fileprivate func UserAvatar() -> some View {
        Image(systemName: "person.crop.circle")
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().fill(.yellow))
            .padding(.top, 50)
    }
    
    fileprivate func BasicDetails() -> some View {
        VStack {
            Text("")
        }
    }
    
    fileprivate func ProfileSection() -> some View {
        VStack {
            UserAvatar()
            Spacer()
            Text(appVM.loggedInUser.email)
            Spacer()
            Button("Sign Out") {
                loginVM.signOut()
            }
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
//            ProfileView()
            Text(appVM.loggedInUser.email)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(AppViewModel.TabViewSelection.profile)
        }
        // The onAppear has not been tested yet
        .onAppear {
            Task {
                await appVM.fetchUserData()
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
