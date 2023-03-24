//
//  View+Extension.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 23/03/2023.
//

import SwiftUI

extension View {
	func getRootViewController() -> UIViewController {
		guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
			return .init()
		}
		
		guard let root = screen.windows.first?.rootViewController else {
			return .init()
		}
		
		return root
	}
}
