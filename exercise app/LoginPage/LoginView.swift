import SwiftUI

struct LoginView: View {
    @ObservedObject var loginVM = LoginViewModel()

    fileprivate func EmailInput() -> some View {
        TextField("Email", text: $loginVM.email)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)
    }
    
    fileprivate func PasswordInput() -> some View {
        SecureField("Password", text: $loginVM.password)
            .textFieldStyle(.roundedBorder)
    }
    
    fileprivate func SignInButton() -> some View {
        Button("Sign In") {
            Task {
                await loginVM.signIn()
            }
        }
        .buttonStyle(LoginButton())
    }
    
    fileprivate func SignUpButton() -> some View {
        Button("Sign Up") {
            Task {
                await loginVM.signUp()
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
            Picker("Login Method", selection: $loginVM.loginMethod) {
                Text("Sign In").tag(LoginViewModel.LoginMethod.signIn)
                Text("Sign Up").tag(LoginViewModel.LoginMethod.signUp)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 50)
            
            EmailInput()
            if(loginVM.loginError == LoginViewModel.LoginError.emptyEmail) {
                ErrorText(errorText: "Email cannot be empty")
            } else if(loginVM.loginError == LoginViewModel.LoginError.invalidEmail) {
                ErrorText(errorText: "Email is invalid")
            }
            
            PasswordInput()
            if(loginVM.loginError == LoginViewModel.LoginError.emptyPassword) {
                ErrorText(errorText: "Password cannot be empty")
            }
            if(loginVM.loginError == LoginViewModel.LoginError.wrongPassword) {
                ErrorText(errorText: "Password is incorrect")
            }
            
            if loginVM.loginMethod == LoginViewModel.LoginMethod.signUp {
                SignUpButton()
            } else {
                SignInButton()
            }
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
