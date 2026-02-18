//
//  PrimaryRelease.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import Foundation

class PrimaryRelease: NSObject, Codable {
    public var albumId: Int?
    public var image: String?
    public var allowDownload: Bool?
    public var numberOfVolumes: Bool?
    public var duration: Int?
    public var isExplicit: Bool?
    public var volumes: Array<Volume>?
    public var allowStream: Bool?
    public var releaseDate: String?
    public var releaseId: Int?
    public var name: String?
    public var originalReleaseDate: String?
    public var contentLanguage: String?
    public var artists: Array<Artist>?
    public var label: Label?
    public var trackIds: Array<Int>?
    
    enum CodingKeys: String, CodingKey {
        case albumId = "AlbumId"
        case image = "Image"
        case allowDownload = "AllowDownload"
        case numberOfVolumes = "NumberOfVolumes"
        case duration = "Duration"
        case isExplicit = "IsExplicit"
        case volumes = "Volumes"
        case allowStream = "AllowStream"
        case releaseDate = "ReleaseDate"
        case releaseId = "ReleaseId"
        case name = "Name"
        case originalReleaseDate = "OriginalReleaseDate"
        case contentLanguage = "ContentLanguage"
        case artists = "Artists"
        case label = "Label"
        case trackIds = "TrackIds"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.albumId = try container.decode(Int.self, forKey: .albumId)
        self.image = try container.decode(String.self, forKey: .image)
        self.allowDownload = try container.decode(Bool.self, forKey: .allowDownload)
        let volumes = try container.decode(Int.self, forKey: .numberOfVolumes)
        self.numberOfVolumes = Bool("\(volumes)")
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.isExplicit = try container.decode(Bool.self, forKey: .isExplicit)
        self.volumes = try container.decode(Array.self, forKey: .volumes)
        self.allowStream = try container.decode(Bool.self, forKey: .allowStream)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.releaseId = try container.decode(Int.self, forKey: .releaseId)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalReleaseDate = try container.decode(String.self, forKey: .originalReleaseDate)
        self.contentLanguage = try container.decodeIfPresent(String.self, forKey: .contentLanguage) ?? ""
        self.artists = try container.decode(Array.self, forKey: .artists)
        self.label = try container.decode(Label.self, forKey: .label)
        self.trackIds = try container.decode(Array.self, forKey: .trackIds)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(albumId, forKey: .albumId)
        try container.encode(image, forKey: .image)
        try container.encode(allowDownload, forKey: .allowDownload)
        try container.encode(numberOfVolumes, forKey: .numberOfVolumes)
        try container.encode(duration, forKey: .duration)
        try container.encode(isExplicit, forKey: .isExplicit)
        try container.encode(volumes, forKey: .volumes)
        try container.encode(allowStream, forKey: .allowStream)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(releaseId, forKey: .releaseId)
        try container.encode(name, forKey: .name)
        try container.encode(originalReleaseDate, forKey: .originalReleaseDate)
        try container.encode(contentLanguage, forKey: .contentLanguage)
        try container.encode(artists, forKey: .artists)
        try container.encode(label, forKey: .label)
        try container.encode(trackIds, forKey: .trackIds)
    }
}
