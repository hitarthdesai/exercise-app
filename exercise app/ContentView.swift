import SwiftUI

struct ContentView: View {
    @State private var loginMethod = "Sign In"
    @State private var signinUsername = ""
    @State private var signinPassword = ""
    @State private var signupUsername = ""
    @State private var signupEmailID = ""
    @State private var signupPassword = ""
    
    var body: some View {
        VStack() {
            Picker("Login Method", selection: $loginMethod) {
                Text("Sign In").tag("Sign In")
                Text("Sign Up").tag("Sign Up")
            }.pickerStyle(.segmented).padding(.bottom, 50)
            if(loginMethod == "Sign In") {
                SignInComponent(signinUsername: $signinUsername, signinPassword: $signinPassword)
            }
            else if (loginMethod == "Sign Up") {
                SignUpComponent(signupEmailID: $signupEmailID, signupUsername: $signupUsername, signupPassword: $signupPassword)
            }
        }.padding()
    }
}

struct SignInComponent: View {
    @Binding var signinUsername: String
    @Binding var signinPassword: String
    var body: some View {
        LoginTextField(placeholder: "Username", textState: $signinUsername)
        LoginTextField(placeholder: "Password", textState: $signinPassword)
    }
}

struct SignUpComponent: View {
    @Binding var signupEmailID: String
    @Binding var signupUsername: String
    @Binding var signupPassword: String
    var body: some View {
        LoginTextField(placeholder: "Email ID", textState: $signupEmailID)
        LoginTextField(placeholder: "Username", textState: $signupUsername)
        LoginTextField(placeholder: "Password", textState: $signupPassword)
    }
}

struct LoginTextField: View {
    var placeholder: String
    @Binding var textState: String
    var body: some View {
        TextField(placeholder, text: $textState)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.secondary)
            .textFieldStyle(.roundedBorder)
            .background(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
