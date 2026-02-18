//
//  Volume.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import Foundation

class Volume: NSObject, Codable {
    public var lastTrackIndex: Bool?
    public var firstTrackIndex: Bool?
    
    enum CodingKeys: String, CodingKey {
        case lastTrackIndex = "LastTrackIndex"
        case firstTrackIndex = "FirstTrackIndex"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lastTrack = try container.decode(Int.self, forKey: .lastTrackIndex)
        let firstTrack = try container.decode(Int.self, forKey: .firstTrackIndex)
        self.lastTrackIndex = Bool("\(lastTrack)")
        self.firstTrackIndex = Bool("\(firstTrack)")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastTrackIndex, forKey: .lastTrackIndex)
        try container.encode(firstTrackIndex, forKey: .firstTrackIndex)
    }
}
