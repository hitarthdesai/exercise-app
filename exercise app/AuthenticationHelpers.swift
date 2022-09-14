//
//  AuthenticationHelpers.swift
//  exercise app
//
//  Created by Hitarth Jainul Desai on 2022-09-10.
//

import Foundation
import FirebaseAuth

func CreateUserWithEmailAndPassword(emailID: String, password: String, username: String) {
    Auth.auth().createUser(withEmail: emailID, password: password) {(result, error) in
        guard let _ = result?.user, error == nil else {
            return
        }
    }
}
