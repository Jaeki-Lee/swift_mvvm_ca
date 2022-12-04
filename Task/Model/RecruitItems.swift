//
//  RecruitItems.swift
//  Task
//
//  Created by trost.jk on 2022/09/16.
//

import Foundation

// MARK: - RecruitItems
struct RecruitItems: ModelType {
    let recruitItems: [RecruitItem]

    enum CodingKeys: String, CodingKey {
        case recruitItems = "recruit_items"
    }
}

// MARK: - RecruitItem
struct RecruitItem: ModelType {
    let id: Int
    let title: String
    let reward: Int
    let appeal: String
    let imageURL: String
    let company: Company
    var isBookmark: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title, reward, appeal
        case imageURL = "image_url"
        case company
    }
}

// MARK: - Company
struct Company: ModelType {
    let name: String
    let logoPath: String
    let ratings: [Rating]

    enum CodingKeys: String, CodingKey {
        case name
        case logoPath = "logo_path"
        case ratings
    }
}

// MARK: - Rating
struct Rating: ModelType {
    let type: String
    let rating: Double
}
