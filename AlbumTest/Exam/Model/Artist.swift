//
//  Artist.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import Foundation

class Artist: NSObject, Codable {
    public var name: String?
    public var artistId: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case artistId = "ArtistId"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.artistId = try container.decode(Int.self, forKey: .artistId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(artistId, forKey: .artistId)
    }
}
