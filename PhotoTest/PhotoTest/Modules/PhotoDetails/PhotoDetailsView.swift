//
//  PhotoDetailsView.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import SwiftUI
import NukeUI

struct PhotoDetailsView: View {
    let photo: Photo
    let tapOnLinkAction: (URL) -> Void
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        LazyImage(source: photo.src?.large) { state in
                            if let image = state.image {
                                image.aspectRatio(contentMode: .fill)
                            } else if state.error != nil {
                                Color.red
                            } else {
                                Color.gray
                            }
                        }.cornerRadius(15)
                        .frame(height: 360)
                        .onTapGesture {
                            if let url = photo.url {
                                if let photoUrl = URL(string: url) {
                                    tapOnLinkAction(photoUrl)
                                }
                            }
                        }
                        if photo.liked == true {
                            Image(UIImage(named: "like")!)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .hidden()
                            }
                        }
                    HStack {
                        Text("Photographer ")
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.gray)
                        Text(photo.photographer ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    
                }
            }
            .padding()
        }
    }
}
