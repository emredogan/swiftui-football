//
//  APIService.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import Foundation
import UIKit

struct APIService {
	let headers = [
		"X-RapidAPI-Key": "144d8f8935msh73e730b7fa245cfp1ea48ajsn45c6ef3f9585",
		"X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
	]
	
	let teamIcons = [UIImage]()

	func fetchLeagueData() async throws -> [Standing]? {
		let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/standings?season=2022&league=39")!
		var request = URLRequest(url: url)
		request.allHTTPHeaderFields = headers
		
		let (data, _) = try await URLSession.shared.data(for: request)
		let result = try JSONDecoder().decode(Welcome.self, from: data)
		let standings = result.response.first?.league.standings.first
		return standings
	}
	
	func fetchImagesData(urlString: String) async throws -> UIImage? {
		let url = URL(string: urlString)!
		let request = URLRequest(url: url)
		let (data, response) = try await URLSession.shared.data(for: request)
		guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
		return UIImage(data: data)
	}
}


