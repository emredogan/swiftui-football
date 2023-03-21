//
//  ResultModel.swift
//  Football-API-2023
//
//  Created by Emre Dogan on 17/03/2023.
//

import Foundation


// MARK: - Welcome
struct Welcome: Codable {
	let response: [Response]
}

// MARK: - Response
struct Response: Codable {
	let league: League
}

// MARK: - League
struct League: Codable {
	let id: Int
	let country: String
	let logo: String
	let flag: String
	let season: Int
	let standings: [[Standing]]
}

// MARK: - Standing
struct Standing: Codable, Hashable {
	let team: Team
	let rank: Int
	let points, goalsDiff: Int
	let description: String?
	let form: String
}

// MARK: - Team
struct Team: Codable, Hashable {
	let id: Int
	let name: String
	let logo: String
}
