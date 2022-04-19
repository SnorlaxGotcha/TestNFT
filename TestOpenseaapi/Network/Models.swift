//
//  Models.swift
//  TestOpenseaapi
//
//  Created by 黃世維 on 2022/4/19.
//

import Foundation

struct MyAssets: Codable {
    let next: String?
    let previous: String?
    let assets: [Asset]
}

struct Asset: Codable, Equatable {
    static func == (lhs: Asset, rhs: Asset) -> Bool {
        lhs.id == rhs.id
    }
    
    let id, numSales: Int
    let imageURL, imagePreviewURL, imageThumbnailURL, imageOriginalURL: String?
    let name: String?
    let assetDescription: String?
    let permalink: String
    let collection: Collection

    enum CodingKeys: String, CodingKey {
        case id
        case numSales = "num_sales"
        case imageURL = "image_url"
        case imagePreviewURL = "image_preview_url"
        case imageThumbnailURL = "image_thumbnail_url"
        case imageOriginalURL = "image_original_url"
        case name
        case assetDescription = "description"
        case permalink, collection
    }
}

// MARK: - Collection
struct Collection: Codable {
    let name: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
    }
}
