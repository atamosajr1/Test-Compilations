//
//  Label.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import Foundation

class Label: NSObject, Codable {
    public var name: String?
    public var labelId: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case labelId = "LabelId"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.labelId = try container.decode(String.self, forKey: .labelId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(labelId, forKey: .labelId)
    }
}
