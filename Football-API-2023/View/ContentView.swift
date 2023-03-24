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
							ImageDownloadView(urlString: standings.team.logo, imageService: viewModel.imageService)
							NavigationLink(standings.team.name, value: standings)
						}
					}
				}
				.sheet(isPresented: $viewModel.showLogin) {
					LoginView()
				}
				.navigationDestination(for: Standing.self) { standing in
					DetailView(standing: standing, imageService: viewModel.imageService)
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
	
	var pickerView: some View {
		HStack {
			Picker("Choose data service", selection: $viewModel.dataService) {
				ForEach(DataService.allCases, id: \.self) {
					Text($0.rawValue)
				}
			}
			Picker("Choose image service", selection: $viewModel.imageService) {
				ForEach(ImageService.allCases, id: \.self) {
					Text($0.rawValue)
				}
			}
			Button("x") {
				// Clear data here
			}
		}
		.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
