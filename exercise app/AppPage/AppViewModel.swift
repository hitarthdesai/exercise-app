import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class AppViewModel: ObservableObject {
    enum TabViewSelection {
        case explore, home, profile
    }
    @Published var tabViewSelection: TabViewSelection = .home
    @Published var isEditingProfile: Bool = false
    
    enum AppError {
        // Below given errors have not been handled yet
        case noError, someError
        case cannotFetchUserData, userDoesNotExist
    }
    @Published var appError: AppError = .noError
    
    @Published var loggedInUser: User = User()
    func fetchUserData() async {
        let db = Firestore.firestore()
        let loggedInUserID = Auth.auth().currentUser?.uid
        if (loggedInUserID == nil || loggedInUserID?.count == 0) {
            self.appError = AppViewModel.AppError.cannotFetchUserData
        } else {
            let loggedInUserDocumentReference = db.document("users/\(loggedInUserID ?? "")")
            do {
                let loggedInUserDocumentSnapshot = try await loggedInUserDocumentReference.getDocument()
                if(!loggedInUserDocumentSnapshot.exists) {
                    self.appError = AppViewModel.AppError.userDoesNotExist
                } else {
                    if let loggedInUserData = loggedInUserDocumentSnapshot.data() {
                        self.loggedInUser.username = loggedInUserData["username"] as! String
                        self.loggedInUser.email = loggedInUserData["email"] as! String
                        self.loggedInUser.password = loggedInUserData["password"] as! String
                    }
                }
            } catch let documentFetchError as NSError {
                switch documentFetchError.code {
                    default:
                        self.appError = AppViewModel.AppError.someError
                }
            }

            self.tabViewSelection = self.loggedInUser.username.count == 0 ? AppViewModel.TabViewSelection.profile : AppViewModel.TabViewSelection.home
        }
    }
}
