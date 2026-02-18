//
//  AlbumCell.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    
    var album : Album? {
        didSet {
            if let thumbnail = album?.primaryRelease?.image {
                thumbnailView.imageFromServerURL(thumbnail, placeHolder: UIImage(named: "avatar"))
            }
            thumbnailView.layer.masksToBounds = true
        }
      }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
