//
//  ImageModelViewModel.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 17/03/2023.
//

import UIKit
import Combine

@MainActor
class ImageDownloadViewModel: ObservableObject {
	@Published var image: UIImage?
	private static let cache = NSCache<NSString, UIImage>()
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
	
	// Fetch with async await. Manual caching implemented.
	func fetchImagesData(urlString: String) async throws -> UIImage {
		let url = URL(string: urlString)

		guard let url = url else {
			throw NetworkError.badURL
		}
		let request = URLRequest(url: url)
		
		// Check in cache
		if let cachedImage = ImageDownloadViewModel.cache.object(forKey: urlString as NSString) {
			return cachedImage
		} else {
			let (data, response) = try await URLSession.shared.data(for: request)
			guard let image = UIImage(data: data) else {
				throw NetworkError.unsupportedImage
			}
			guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
			ImageDownloadViewModel.cache.setObject(image, forKey: urlString as NSString)
			return image
		}
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
						
						guard UIImage(data: data) != nil else {
							throw NetworkError.unsupportedImage
						}
						return data
					}
					.sink { completion in
						print(completion)
					} receiveValue: { [weak self] data in
						
						self?.image = UIImage(data: data)!
					}
					.store(in: &cancellables)
	}
}

enum NetworkError: Error {
	case badRequest
	case unsupportedImage
	case badURL
}
