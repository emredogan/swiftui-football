//
//  ImageModelViewModel.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 17/03/2023.
//

import UIKit

class ImageDownloadViewModel: ObservableObject {
	@Published var image: UIImage? = nil
	
	func fetchImage(urlString: String) async {
		let apiService = APIService()
		do {
			let fetchedData = try await apiService.fetchImagesData(urlString: urlString)
			DispatchQueue.main.async {
				self.image = fetchedData
			}
		} catch {
			print(error)
		}
	}
}
