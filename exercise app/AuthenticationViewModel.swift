//
//  AuthenticationViewModel.swift
//  exercise app
//
//  Created by Hitarth Jainul Desai on 2022-09-14.
//

import Foundation
import FirebaseAuth

struct User {
    var uid: String = ""
}

class AuthenticationViewModel: ObservableObject {
    private var handler = Auth.auth().addStateDidChangeListener{_,_ in }
    init() {
        handler = Auth.auth().addStateDidChangeListener{ auth,user in
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
            self.username = ""
            self.password = ""
            self.error = .noError
        }
    }
    
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    enum LoginError {
        case emptyEmail, invalidEmail, emailAlreadyExists
        case emptyUsername, usernameAlreadyTaken
        case emptyPassword, wrongPassword
        case noError, someError
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
           try await Auth.auth().createUser(withEmail: email, password: password)
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
