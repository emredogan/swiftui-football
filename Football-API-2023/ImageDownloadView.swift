//
//  ImageDownloadView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 17/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageDownloadView: View {
	@StateObject var imageDownloadViewModel = ImageDownloadViewModel()
	var urlString: String
	var imageService: ImageService
    var body: some View {
		ZStack {
			switch imageService {
				case .async, .combine:
					Image(uiImage: imageDownloadViewModel.image)
						.resizable()
						.frame(width: 100, height: 100)
				case .SDWeb:
					WebImage(url: URL(string: urlString))
						.resizable()
						.frame(width: 100, height: 100)
			}
		}
		.onChange(of: imageService, perform: { newValue in
			triggerDownload(newValue)
		})
		.onAppear {
			triggerDownload()
		}
    }
	
	func triggerDownload(_ newValue: ImageService? = nil) {
		var newService  = newValue
		if newService == nil {
			newService = imageService
		}
		
		Task {
			switch newService {
				case .async:
					imageDownloadViewModel.image =  UIImage(systemName: "heart")!
					await imageDownloadViewModel.fetchImage(urlString:urlString)
				case .combine:
					imageDownloadViewModel.image =  UIImage(systemName: "heart")!
					imageDownloadViewModel.setupFetchImagesPublisher(urlString:urlString)
				case .SDWeb:
					SDImageCache.shared.clearMemory()
					SDImageCache.shared.clearDisk()
					print("Fetch with SDWeb, handled automatically")
				case .none:
					print("Unknown case")
			}
		}
	}
}

struct ImageDownloadView_Previews: PreviewProvider {
    static var previews: some View {
		ImageDownloadView(urlString: "https://media-1.api-sports.io/football/teams/51.png", imageService: .async)
    }
}
