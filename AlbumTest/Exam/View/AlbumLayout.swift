//
//  AlbumLayout.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class AlbumLayout: NSObject {
    enum Constants {
        static let insets: CGFloat = 8
    }
    
    func make() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    private func sectionProvider(sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1/3),
          heightDimension: NSCollectionLayoutDimension.absolute(128)
        )
        let groupSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.absolute(128)
        )
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = makeContentInsets()

        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = makeContentInsets()

        return section
    }
    
    private func makeContentInsets() -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: Constants.insets / 2,
                                leading: Constants.insets / 2,
                                bottom: Constants.insets / 2,
                                trailing: Constants.insets / 2)
    }
}
