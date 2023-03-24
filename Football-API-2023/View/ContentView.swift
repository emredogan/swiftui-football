//
//  ContentView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
	@StateObject var viewModel = StandingsViewModel()
	
    var body: some View {
        VStack {
			NavigationStack {
				List {
					ForEach(viewModel.standings, id: \.self.team.id) {standings in
						HStack(spacing: 15) {
							ImageDownloadView(urlString: standings.team.logo)
							NavigationLink(standings.team.name, value: standings)
						}
					}
				}
				.sheet(isPresented: $viewModel.showLogin) {
					LoginView()
				}
				.navigationDestination(for: Standing.self) { standing in
					DetailView(standing: standing)
				}
			}
		}
		.padding(.top, 20)
		.onAppear {
			Task {
				viewModel.handleFetchData()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
