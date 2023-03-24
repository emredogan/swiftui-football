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
	@Published var showLogin: Bool = false
	private var signInOutCancellable: AnyCancellable?

	
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
		
		signInOutCancellable = FireAuth.share.signInOutCommand.sink { completion in
			switch completion {
				case .finished: break
				case .failure(let error): debugPrint(error)
			}
		} receiveValue: { [weak self] signInOut in
			switch signInOut {
				case .signIn: print("Show sign in ")
					self?.showLogin = true
				case .signOut: print("Show sign out")
			}
		}
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
	
	
	func fetchLeagueData() async throws -> [Standing]? {
		let (data, _) = try await URLSession.shared.data(for: request)
		let result = try JSONDecoder().decode(Welcome.self, from: data)
		let standings = result.response.first?.league.standings.first
		return standings
	}
	
	func handleFetchData() {
		Task {
			await fetchData()
		}
	}
}

