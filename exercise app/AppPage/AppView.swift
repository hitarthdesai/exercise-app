import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AppView: View {
    @ObservedObject var appVM = AppViewModel()
    @ObservedObject var loginVM = LoginViewModel()
    @ObservedObject var firebaseSDK = FirebaseSDK()
    
    fileprivate func ProfileSection() -> some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().fill(.yellow))
                .padding(.top, 50)
            Text(appVM.loggedInUser.username)
                .font(.title2)
            Spacer()
            HStack {
                Button("Sign Out") {
                    loginVM.signOut()
                }
                .buttonStyle(.bordered)
                Button("Edit Profile") {
                    appVM.isEditingProfile = true
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity)
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
            ProfileSection()
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
