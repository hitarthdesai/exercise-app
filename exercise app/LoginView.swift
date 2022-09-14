import SwiftUI

struct LoginView: View {
    @ObservedObject var authenticationVM = AuthenticationViewModel()

    fileprivate func EmailInput() -> some View {
        TextField("Email", text: $authenticationVM.email)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)
    }
    
    fileprivate func UsernameInput() -> some View {
        TextField("Username", text: $authenticationVM.password)
            .keyboardType(.default)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)
    }
    
    fileprivate func PasswordInput() -> some View {
        SecureField("Password", text: $authenticationVM.password)
            .textFieldStyle(.roundedBorder)
    }
    
    fileprivate func SignInButton() -> some View {
        Button("Sign In") {
            Task {
                await authenticationVM.signIn()
            }
        }
        .buttonStyle(LoginButton())
    }
    
    fileprivate func SignUpButton() -> some View {
        Button("Sign Up") {
            Task {
                await authenticationVM.signIn()
            }
        }
        .buttonStyle(LoginButton())
    }
    
    fileprivate func ErrorText(errorText: String) -> some View {
        Text(errorText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.red)
            .font(.footnote.italic().bold())
    }
    
    var body: some View {
        VStack() {
            Picker("Login Method", selection: $authenticationVM.loginMethod) {
                Text("Sign In").tag(AuthenticationViewModel.LoginMethod.signIn)
                Text("Sign Up").tag(AuthenticationViewModel.LoginMethod.signUp)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 50)
            
            EmailInput()
            if(authenticationVM.error == AuthenticationViewModel.LoginError.emptyEmail) {
                ErrorText(errorText: "Email cannot be empty")
            } else if(authenticationVM.error == AuthenticationViewModel.LoginError.invalidEmail) {
                ErrorText(errorText: "Email is invalid")
            }
            
            if (authenticationVM.loginMethod == AuthenticationViewModel.LoginMethod.signUp) {
                UsernameInput()
            }
            
            PasswordInput()
            if(authenticationVM.error == AuthenticationViewModel.LoginError.emptyPassword) {
                ErrorText(errorText: "Password cannot be empty")
            }
            if(authenticationVM.error == AuthenticationViewModel.LoginError.wrongPassword) {
                ErrorText(errorText: "Password is incorrect")
            }
            
            if authenticationVM.loginMethod == AuthenticationViewModel.LoginMethod.signUp {
                SignUpButton()
            } else {
                SignInButton()}
            }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
        }
    }
}
