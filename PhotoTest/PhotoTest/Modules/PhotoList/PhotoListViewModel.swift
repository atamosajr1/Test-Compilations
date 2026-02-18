//
//  PhotoListViewModel.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import Foundation

class PhotoListViewModel: ObservableObject {
    @Published var curatedPhotos: CuratedPhoto = CuratedPhoto()
    var apiClient: PhotoAPIProvider = PhotoAPIClient()
    
    func getPhotos() {
        apiClient
            .getPhotos()
            .replaceError(with: CuratedPhoto())
            .assign(to: &$curatedPhotos)
    }
}
