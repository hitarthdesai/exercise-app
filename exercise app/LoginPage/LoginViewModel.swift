import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct User {
    var uid: String = ""
    var username: String = "bruh"
    var email: String = ""
    var password: String = ""
}

@MainActor
class LoginViewModel: ObservableObject {
    private var handler = Auth.auth().addStateDidChangeListener{_,_ in }
    init() {
        handler = Auth.auth().addStateDidChangeListener{ auth, user in
            if let user = user {
                self._currentUser = User(uid: user.uid)
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
            self.password = ""
            self.loginError = .noError
        }
    }
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    enum LoginError {
        case emptyEmail, invalidEmail
        case emptyPassword
        case noError
        
        // Below given errors have not been handled yet
        case cannotCreateUserDocument, someError, wrongPassword, emailAlreadyExists
    }
    @Published var loginError: LoginError = .noError
    
    @Published private var _currentUser: User? = nil
    var currentUser: User {
        return _currentUser ?? User(uid: "")
    }
    
    func signIn() async {
        if(email.count == 0) {
            self.loginError = .emptyEmail
            return
        }
        if(password.count == 0) {
            self.loginError = .emptyPassword
            return
        }
        
        do{
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch let signInError as NSError {
            switch signInError.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    self.loginError = .invalidEmail
                    break
                case AuthErrorCode.wrongPassword.rawValue:
                    self.loginError = .wrongPassword
                    break
                default:
                    self.loginError = .someError
            }
        }
    }
    
    private func createUserDocument(uid: String) {
        let db = Firestore.firestore()
        let userDocumentReference: DocumentReference = db.document("users/\(uid)")
        userDocumentReference.setData([
            "username": "",
            "email": self.email,
            "password": self.password
        ]) {
            error in
            if let _ = error {
                self.loginError = .cannotCreateUserDocument
            } else {
                self.loginError = .noError
            }
        }
    }
    
    func signUp() async {
        if(email.count == 0) {
            self.loginError = .emptyEmail
            return
        }
        if(password.count == 0) {
            self.loginError = .emptyPassword
            return
        }
        
        do{
            let AuthData = try await Auth.auth().createUser(withEmail: email, password: password)
            let loggedInUserID = AuthData.user.uid
            createUserDocument(uid: loggedInUserID)
        } catch let signUpError as NSError {
            switch signUpError.code {
            case AuthErrorCode.invalidEmail.rawValue:
                self.loginError = .invalidEmail
                break
            case AuthErrorCode.wrongPassword.rawValue:
                self.loginError = .wrongPassword
                break
            default:
                self.loginError = .someError
            }
            
        }
    }
       
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            //Handling errors is left
        }
    }
}
