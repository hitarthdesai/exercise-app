//
//  DefaultView.swift
//  exercise app
//
//  Created by Hitarth Jainul Desai on 2022-09-14.
//

import SwiftUI

struct DefaultView: View {
    @ObservedObject var loginVM = LoginViewModel()
    var body: some View {
        if(loginVM.loginState == .loggedOut) {
            LoginView()
        } else {
            AppView()
        }
    }
}

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
