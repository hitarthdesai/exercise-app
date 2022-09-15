//
//  Firebase.swift
//  exercise app
//
//  Created by Hitarth Jainul Desai on 2022-09-14.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirebaseSDK: ObservableObject {
    @Published var db = Firestore.firestore()
    @Published var auth = Auth.auth()
}
