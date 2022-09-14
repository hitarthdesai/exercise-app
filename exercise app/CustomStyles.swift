//
//  CustomStyles.swift
//  exercise app
//
//  Created by Hitarth Jainul Desai on 2022-09-14.
//

import SwiftUI

struct LoginButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
            
    }
}
