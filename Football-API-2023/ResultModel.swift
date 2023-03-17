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
struct Standing: Codable {
	let team: Team
	let rank: Int
}

// MARK: - Team
struct Team: Codable {
	let id: Int
	let name: String
	let logo: String
}
