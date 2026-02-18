//
//  UIImageView-Extension.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

extension UIImageView {

    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                if let error = error {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                }
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                       self.image = downloadedImage
                    }
                }
            }
        }).resume()
        }
    }
}
