//
//  ContentView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = StandingsViewModel()
    var body: some View {
        VStack {
			List {
				ForEach(viewModel.standings, id: \.self.team.id) {standings in
					HStack {
						ImageDownloadView(urlString: standings.team.logo)
						Text(standings.team.name)
							.font(.largeTitle)
					}
				}
			}
        }
		.padding(.top, 20)
		.ignoresSafeArea()
		.onAppear {
			Task {
				//await viewModel.fetchData()
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
