//
//  StandingsViewModel.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 16/03/2023.
//

import UIKit

class StandingsViewModel: ObservableObject {
	@Published var standings: [Standing]? = nil
	@Published var images: [UIImage]? = nil

	
	func fetchData() async  {
		let apiService = APIService()
		do {
			let fetchedData = try await apiService.fetchLeagueData()
			DispatchQueue.main.async {
				self.standings = fetchedData
			}
		} catch {
			print(error)
		}
	}
	
	func fetchImages(urlString: String) async {
		let apiService = APIService()
		do {
			let fetchedData = try await apiService.fetchImagesData(urlString: urlString)
			DispatchQueue.main.async {
				if (fetchedData != nil) {
					self.images?.append(fetchedData!)
				}
			}
		} catch {
			print(error)
		}
	}
}
