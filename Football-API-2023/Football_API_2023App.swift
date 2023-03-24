//
//  Football_API_2023App.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import SwiftUI

@main
struct Football_API_2023App: App {
	// To introduce the new app delegate file that we created
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@AppStorage("signIn") var isSignedIn = false
    var body: some Scene {
        WindowGroup {
			if isSignedIn{
				ContentView()
			} else {
				LoginView()
			}
        }
    }
}
