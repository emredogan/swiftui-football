//
//  ImageDownloadView.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 17/03/2023.
//

import SwiftUI

struct ImageDownloadView: View {
	@StateObject var imageDownloadViewModel = ImageDownloadViewModel()
	var urlString: String
    var body: some View {
		ZStack {
			if let image = imageDownloadViewModel.image {
				Image(uiImage: image)
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
		ImageDownloadView(urlString: "https://media-1.api-sports.io/football/teams/51.png")
    }
}
