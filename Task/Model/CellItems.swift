//
//  CellItems.swift
//  Task
//
//  Created by trost.jk on 2022/09/16.
//
import Foundation

// MARK: - CellItems
struct CellItems: ModelType {
    let cellItems: [CellItem]

    enum CodingKeys: String, CodingKey {
        case cellItems = "cell_items"
    }
}

// MARK: - CellItem
struct CellItem: ModelType {
    let cellType: CellType
    let logoPath: String?
    let name, industryName: String?
    let rateTotalAvg: Double?
    let reviewSummary, interviewQuestion: String?
    let salaryAvg: Int?
    let updateDate: String?
    let count: Int?
    let sectionTitle: String?
    let recommendRecruit: [RecruitItem]?
    let cons, pros: String?

    enum CodingKeys: String, CodingKey {
        case cellType = "cell_type"
        case logoPath = "logo_path"
        case name
        case industryName = "industry_name"
        case rateTotalAvg = "rate_total_avg"
        case reviewSummary = "review_summary"
        case interviewQuestion = "interview_question"
        case salaryAvg = "salary_avg"
        case updateDate = "update_date"
        case count
        case sectionTitle = "section_title"
        case recommendRecruit = "recommend_recruit"
        case cons, pros
    }
}

enum CellType: String, Codable {
    case cellTypeCompany = "CELL_TYPE_COMPANY"
    case cellTypeHorizontalTheme = "CELL_TYPE_HORIZONTAL_THEME"
    case cellTypeReview = "CELL_TYPE_REVIEW"
}

//// MARK: - RecommendRecruit
//struct RecommendRecruit: ModelType {
//    let id: Int
//    let title: String
//    let reward: Int
//    let appeal: String
//    let imageURL: String
//    let company: Company
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, reward, appeal
//        case imageURL = "image_url"
//        case company
//    }
//}
