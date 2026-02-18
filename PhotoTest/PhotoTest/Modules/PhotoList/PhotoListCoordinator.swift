//
//  PhotoListCoordinator.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import SwiftUI

struct PhotoListCoordinator: View {
    @State private var selectedPhoto: Photo?
    
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            PhotoListView(tapOnPhotoAction: { photo in
                selectedPhoto = photo
            })
            .listStyle(PlainListStyle())
            .navigationBarTitle("Photos", displayMode: .inline)
            
            if let selectedPhoto = selectedPhoto {
                EmptyNavigationLink(destination: PhotoDetailsView(photo: selectedPhoto, tapOnLinkAction: tapOnLinkAction), selectedItem: $selectedPhoto)
            }
        }
    }
    
    private func tapOnLinkAction(url: URL) {
        openURL(url)
    }
}
