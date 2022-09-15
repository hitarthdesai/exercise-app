import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct User {
    var uid: String = ""
    var isNewUser: Bool = false
}

class LoginViewModel: ObservableObject {
    private var handler = Auth.auth().addStateDidChangeListener{_,_ in }
    init() {
        handler = Auth.auth().addStateDidChangeListener{ auth, user in
            if let user = user {
                self._currentUser = User(uid: user.uid, isNewUser: self.loginMethod == .signUp)
                self.loginState = .loggedIn
            } else {
                self._currentUser = nil
                self.loginState = .loggedOut
            }
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
    enum LoginState {
        case loggedIn
        case loggedOut
    }
    @Published var loginState: LoginState = .loggedOut
    
    enum LoginMethod {
        case signIn
        case signUp
    }
    @Published var loginMethod: LoginMethod = .signIn {
        didSet {
            self.email = ""
            self.username = ""
            self.password = ""
            self.error = .noError
        }
    }
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    enum LoginError {
        case emptyEmail, invalidEmail
        case emptyUsername
        case emptyPassword
        case noError
        
        // Below given errors have not been handled yet
        case cannotCreateUserDocument, someError, wrongPassword, usernameAlreadyTaken, emailAlreadyExists
    }
    @Published var error: LoginError = .noError
    
    @Published private var _currentUser : User? = nil
    var currentUser: User {
        return _currentUser ?? User(uid: "")
    }
    
    func signIn() async {
        if(email.count == 0) {
            self.error = .emptyEmail
            return
        }
        if(password.count == 0) {
            self.error = .emptyPassword
            return
        }
        
        do{
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let signInError as NSError {
            switch signInError.code {
            case AuthErrorCode.invalidEmail.rawValue:
                self.error = .invalidEmail
                break
            case AuthErrorCode.wrongPassword.rawValue:
                self.error = .wrongPassword
                break
            default:
                self.error = .someError
            }
            
        }
    }
    
    private func createUserDocument(uid: String) {
        let db = Firestore.firestore()
        var _: DocumentReference = db.collection("users").addDocument(data: [
            "userID": uid
        ]) { error in
            if let _ = error {
                self.error = .cannotCreateUserDocument
            } else {
                self.error = .noError
            }
        }
    }
    
    func signUp() async {
        if(email.count == 0) {
            self.error = .emptyEmail
            return
        }
        if(username.count == 0) {
            self.error = .emptyUsername
            return
        }
        if(password.count == 0) {
            self.error = .emptyPassword
            return
        }
        
        do{
            let AuthData = try await Auth.auth().createUser(withEmail: email, password: password)
            let loggedInUserID = AuthData.user.uid
            createUserDocument(uid: loggedInUserID)
        } catch let signUpError as NSError {
            switch signUpError.code {
            case AuthErrorCode.invalidEmail.rawValue:
                self.error = .invalidEmail
                break
            case AuthErrorCode.wrongPassword.rawValue:
                self.error = .wrongPassword
                break
            default:
                self.error = .someError
            }
            
        }
    }
       
    func signOut() async {
        do {
            try Auth.auth().signOut()
        } catch {
        }
    }
}
