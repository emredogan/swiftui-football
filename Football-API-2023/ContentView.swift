//
//  ContentView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = StandingsViewModel()
	@State var standings: [Standing]? = nil
    var body: some View {
        VStack {
			if let standings {
				List {
					ForEach(standings, id: \.self.team.id) {standings in
						HStack {
							ImageDownloadView(urlString: standings.team.logo)
							Text(standings.team.name)
								.font(.largeTitle)

						}
					}
				}
			}
        }
		.padding(.top, 20)
		.ignoresSafeArea()
		.onAppear {
			Task {
				await viewModel.fetchData()
				standings = viewModel.standings
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
