// Product.swift
import Foundation

struct Product: Codable {
    let brand: String
    let productName: String
    let price: Double
    let itemsLeft: Int
    let imageURL: String
    let isLiked: Bool
    let isBestseller: Bool
    
    enum CodingKeys: String, CodingKey {
        case brand
        case productName = "product_name"
        case price
        case itemsLeft = "items_left"
        case imageURL = "image_url"
        case isLiked = "is_liked"
        case isBestseller = "is_bestseller"
    }
}
