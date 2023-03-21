//
//  StandingsViewModel.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import UIKit
import Combine

@MainActor
class StandingsViewModel: ObservableObject {
	@Published var standings: [Standing] = []
	@Published var images: [UIImage]? = nil
	@Published var imageService: ImageService = .async
	@Published var dataService: DataService = .async
	
	var request: URLRequest
	let headers = [
		"X-RapidAPI-Key": "144d8f8935msh73e730b7fa245cfp1ea48ajsn45c6ef3f9585",
		"X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
	]
	
	let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/standings?season=2022&league=39")!
	var cancellables = Set<AnyCancellable>()
	
	init() {
		request = URLRequest(url: url)
		request.allHTTPHeaderFields = headers
	}

	func fetchData() async  {
		do {
			let fetchedData = try await fetchLeagueData()
			DispatchQueue.main.async {
				if let fetchedData {
					self.standings = fetchedData
				}
			}
		} catch {
			print(error)
		}
	}
	
	func setupFetchDataPublisher() {
		URLSession.shared.dataTaskPublisher(for: request)
					.receive(on: DispatchQueue.main)
					.tryMap { (data, response) -> Data in
						guard
							let response = response as? HTTPURLResponse,
							response.statusCode >= 200 && response.statusCode < 300 else {
							throw URLError(.badServerResponse)
						}
						return data
					}
					.decode(type: Welcome.self, decoder: JSONDecoder())
					.sink { completion in
						print(completion)
					} receiveValue: { [weak self] welcome in
						
						let standings = welcome.response.first?.league.standings.first
						if let standings {
							self?.standings = standings
						}
					}
					.store(in: &cancellables)
	}
	
	func fetchLeagueData() async throws -> [Standing]? {
		let (data, _) = try await URLSession.shared.data(for: request)
		let result = try JSONDecoder().decode(Welcome.self, from: data)
		let standings = result.response.first?.league.standings.first
		return standings
	}
	
	func handleFetchData(_ newValue: DataService? = nil) {
		standings.removeAll()
		var newDataService = newValue
		
		if newDataService == nil {
			newDataService = dataService
		}
		Task {
			switch newDataService {
				case .async:
					await fetchData()
				case .combine:
					setupFetchDataPublisher()
				case .none:
					print("Unknown case")
			}
		}
	}
}

enum ImageService: String, CaseIterable {
	case async = "async"
	case combine = "combine"
	case SDWeb = "SDWeb"
}

enum DataService: String, CaseIterable {
	case async = "async"
	case combine = "combine"
}

