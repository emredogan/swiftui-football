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
					if let safeImage = imageDownloadViewModel.image {
						Image(uiImage: safeImage)
							.resizable()
							.frame(width: 100, height: 100)
					} else {
						ProgressView()
					}
					
				case .SDWeb:
					WebImage(url: URL(string: urlString))
						.resizable()
						.frame(width: 100, height: 100)
			}
		}
		.onAppear {
			Task {
				await imageDownloadViewModel.fetchImage(urlString:urlString)
			}
		}
    }
}

struct ImageDownloadView_Previews: PreviewProvider {
    static var previews: some View {
		ImageDownloadView(urlString: "https://media-1.api-sports.io/football/teams/51.png", imageService: .async)
    }
}
