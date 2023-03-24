//
//  FileAuth.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 23/03/2023.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import Firebase
import Combine

struct FireAuth {
	enum SignInOut {
		case signIn
		case signOut
	}
	
	let signInOutCommand = PassthroughSubject<SignInOut, Error>()
	
	static let share = FireAuth()
	private init() {}
	
	
	func signInWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
		guard let clientID = FirebaseApp.app()?.options.clientID else { return }

		// Create Google Sign In configuration object.
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.configuration = config

		// Start the sign in flow!
		GIDSignIn.sharedInstance.signIn(withPresenting: presenting) {  result, error in
			guard error == nil else {
				completion(error)
				return
			}
			
			guard let user = result?.user,
				  let idToken = user.idToken?.tokenString
			else {
				return
			}
			
			let credential = GoogleAuthProvider.credential(withIDToken: idToken,
														   accessToken: user.accessToken.tokenString)
			
			Auth.auth().signIn(with: credential) { result, error in
				
				// At this point, our user is signed in
				guard error == nil else {
					completion(error)
					return
				}
				print("SIGN IN SUCCESS")
				UserDefaults.standard.set(true, forKey: "signIn")
			}
		}
	}
}
