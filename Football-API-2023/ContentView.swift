//
//  ContentView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import SwiftUI

enum ImageService: String, CaseIterable {
	case async = "async"
	case combine = "combine"
	case SDWeb = "SDWeb"
}

enum DataService: String, CaseIterable {
	case async = "async"
	case combine = "combine"
}

struct ContentView: View {
	@StateObject var viewModel = StandingsViewModel()
	@State var imageService: ImageService = .async
	@State var dataService: DataService = .async
    var body: some View {
        VStack {
			HStack {
				Picker("Choose data service", selection: $dataService) {
					ForEach(DataService.allCases, id: \.self) {
						Text($0.rawValue)
					}
				}
				Picker("Choose image service", selection: $imageService) {
					ForEach(ImageService.allCases, id: \.self) {
						Text($0.rawValue)
					}
				}
			}
			.padding()
			List {
				ForEach(viewModel.standings, id: \.self.team.id) {standings in
					HStack(spacing: 15) {
						ImageDownloadView(urlString: standings.team.logo, imageService: imageService)
						Text(standings.team.name)
							.font(.headline)
					}
				}
			}
        }
		.padding(.top, 20)
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
