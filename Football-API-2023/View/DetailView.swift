//
//  DetailView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 23/03/2023.
//

import SwiftUI

struct DetailView: View {
	let standing: Standing
	let imageService: ImageService
    var body: some View {
		VStack {
			HStack {
				ImageDownloadView(urlString: standing.team.logo, imageService: imageService)
				Text(standing.team.name)
			}
			Text(standing.description ?? "")
			Text("Form: \(standing.form)")
			Text("Goal difference: \(standing.goalsDiff)")
			Text("Points \(standing.points)")
			Button("LOGIN") {
				FireAuth.share.signInOutCommand.send(.signIn)
			}
		}
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
		DetailView(standing: Standing(team: Team(id: 1, name: "Galatasaray", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Galatasaray_Sports_Club_Logo.svg/1565px-Galatasaray_Sports_Club_Logo.svg.png"), rank: 1, points: 11, goalsDiff: 1, description: nil, form: "WWWWW"), imageService: .async)
    }
}
