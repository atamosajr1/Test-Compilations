//
//  Section.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class Section: Hashable {
  var id = UUID()
  var title: String
  
  init(title: String) {
    self.title = title
  }
  // 4
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Section, rhs: Section) -> Bool {
    lhs.id == rhs.id
  }
}

extension Section {
  static var allSections: [Section] = [
    Section(title: "test")
  ]
}


