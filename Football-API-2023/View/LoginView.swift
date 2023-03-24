//
//  LoginView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 23/03/2023.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import Firebase

struct LoginView: View {
	@State private var userName = ""
	@State private var password = ""
	
    var body: some View {
		VStack(spacing: 20) {
			Image("premier")
				.resizable()
				.frame(width: 100, height: 100)
			Text("Welcome to the \n Premier League App")
				.font(.largeTitle)
			TextField("Username", text: $userName)
			TextField("Password", text: $password)
			Button {
				
			} label: {
				VStack {
					Text("Login")
						.padding()
						.frame(width: 200)
						.background(Color.black)
						.foregroundColor(.white)
					Text("or")
					Button {
						FireAuth.share.signInWithGoogle(presenting: getRootViewController()) { error in
							guard error == nil else {
								return
							}
							
							FireAuth.share.signInOutCommand.send(.signIn)
						}
					} label: {
						Image("google")
							.resizable()
							.frame(width: 100, height: 100)
					}
				}
				
			}

		}
		.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
