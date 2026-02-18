//
//  Photo.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import Foundation

struct CuratedPhoto: Codable {
    enum CodingKeys: String, CodingKey {
        case page, photos
        case perPage = "per_page"
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
    
    var page: Int?
    var photos: [Photo]?
    var perPage: Int?
    var totalResults: Int?
    var nextPage: String?
}

struct Photo: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer, liked, alt, src
        case photographerUrl = "photographer_url"
        case photographerId = "photographer_id"
        case avgColor = "avg_color"
    }
    
    var id: Int?
    var width: Int?
    var height: Int?
    var url: String?
    var photographer: String?
    var liked: Bool
    var alt: String?
    var src: PhotoSource?
    var photographerUrl: String?
    var photographerId: Int?
    var avgColor: String?
}

struct PhotoSource: Codable {
    enum CodingKeys: String, CodingKey {
        case original, large2x, large, medium, small, portrait, landscape, tiny
    }
    
    var original: String?
    var large2x: String?
    var large: String?
    var medium: String?
    var small: String?
    var portrait: String?
    var landscape: String?
    var tiny: String?
}
