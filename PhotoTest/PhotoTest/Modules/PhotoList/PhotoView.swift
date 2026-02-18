//
//  PhotoCell.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import SwiftUI
import NukeUI

struct PhotoView: View {
    let photo: Photo
    let tapOnPhotoAction: (Photo) -> Void
    
    var body: some View {
        VStack {
            LazyImage(source: photo.src?.original) { state in
                if let image = state.image {
                    image.aspectRatio(contentMode: .fit)
                } else if state.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }.cornerRadius(10)
            .onTapGesture {
                    tapOnPhotoAction(photo)
            }
        }
        }
    }
    
    struct RowView: View {
        let photos: [Photo]
        let width: CGFloat
        let height: CGFloat
        let horizontalSpacing: CGFloat
        let tapOnPhotoAction: (Photo) -> Void
        
        var body: some View {
            HStack(spacing: horizontalSpacing) {
                ForEach(photos) { photo in
                    PhotoView(photo: photo, tapOnPhotoAction: tapOnPhotoAction)
                        .frame(width: width, height: height)
                }
            }
            .padding()
        }
    }
