//
//  Album.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class Result : NSObject, Codable  {
    public var results: Array<Album>?
    public var offset: Bool?
    public var count: Int?
    
    enum CodingKeys: String, CodingKey {
        case results = "Results"
        case offset = "Offset"
        case count = "Count"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decodeIfPresent(Array.self, forKey: .results)
        let iOffset = try container.decode(Int.self, forKey: .offset)
        self.offset = Bool("\(iOffset)")
        self.count = try container.decode(Int.self, forKey: .count)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(results, forKey: .results)
        try container.encode(offset, forKey: .offset)
        try container.encode(count, forKey: .count)
    }
}

class Album: NSObject, Codable {
    public var albumId: Int?
    public var releaseIds: Array<Int>?
    public var primaryRelease: PrimaryRelease?
    public var upc: String?
    public var albumType: String?
    public var primaryReleaseId: Int?
    public var translations: Array<String>?
    public var name: String?
    public var artists: Array<Artist>?
    
    enum CodingKeys: String, CodingKey {
        case albumId = "AlbumId"
        case releaseIds = "ReleaseIds"
        case primaryRelease = "PrimaryRelease"
        case upc = "Upc"
        case albumType = "AlbumType"
        case primaryReleaseId = "PrimaryReleaseId"
        case translations = "Translations"
        case name = "Name"
        case artists = "Artists"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.releaseIds = try container.decode(Array.self, forKey: .releaseIds)
        self.primaryRelease = try container.decode(PrimaryRelease.self, forKey: .primaryRelease)
        self.upc = try container.decode(String.self, forKey: .upc)
        self.albumType = try container.decode(String.self, forKey: .albumType)
        self.primaryReleaseId = try container.decode(Int.self, forKey: .primaryReleaseId)
        self.translations = try container.decode(Array.self, forKey: .translations)
        self.name = try container.decode(String.self, forKey: .name)
        self.artists = try container.decode(Array.self, forKey: .artists)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(albumId, forKey: .albumId)
        try container.encode(releaseIds, forKey: .releaseIds)
        try container.encode(primaryRelease, forKey: .primaryRelease)
        try container.encode(upc, forKey: .upc)
        try container.encode(albumType, forKey: .albumType)
        try container.encode(primaryReleaseId, forKey: .primaryReleaseId)
        try container.encode(translations, forKey: .translations)
        try container.encode(name, forKey: .name)
        try container.encode(artists, forKey: .artists)
       
    }
}

