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
			}
			.padding()
			List {
				ForEach(viewModel.standings, id: \.self.team.id) {standings in
					HStack(spacing: 15) {
						ImageDownloadView(urlString: standings.team.logo, imageService: viewModel.imageService)
						Text(standings.team.name)
							.font(.headline)
					}
				}
			}
		}
		.padding(.top, 20)
		.onChange(of: viewModel.dataService, perform: { newValue in
			viewModel.handleFetchData(newValue)
		})
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
