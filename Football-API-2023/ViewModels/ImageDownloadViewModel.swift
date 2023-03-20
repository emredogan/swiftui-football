//
//  ImageModelViewModel.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 17/03/2023.
//

import UIKit
import Combine

class ImageDownloadViewModel: ObservableObject {
	@Published var image: UIImage? = nil
	var cancellables = Set<AnyCancellable>()

	func fetchImage(urlString: String) async {
		do {
			let fetchedData = try await fetchImagesData(urlString: urlString)
			DispatchQueue.main.async {
				self.image = fetchedData
			}
		} catch {
			print(error)
		}
	}
	
	func resetImage() {
		image = nil
	}
	
	// Fetch with async await
	func fetchImagesData(urlString: String) async throws -> UIImage? {
		let url = URL(string: urlString)!
		let request = URLRequest(url: url)
		let (data, response) = try await URLSession.shared.data(for: request)
		guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
		return UIImage(data: data)
	}
	
	// Setup publisher so fetch with combine
	func setupFetchImagesPublisher(urlString: String) {
		URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
					.receive(on: DispatchQueue.main)
					.tryMap { (data, response) -> Data in
						guard
							let response = response as? HTTPURLResponse,
							response.statusCode >= 200 && response.statusCode < 300 else {
							throw URLError(.badServerResponse)
						}
						return data
					}
					.sink { completion in
						print(completion)
					} receiveValue: { [weak self] data in
						self?.image = UIImage(data: data)
					}
					.store(in: &cancellables)
	}
}
