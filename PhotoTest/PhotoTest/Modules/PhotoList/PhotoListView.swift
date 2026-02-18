//
//  PhotoListView.swift
//  PhotoTest
//
//  Created by JayR Atamosa on 3/9/23.
//

import SwiftUI

struct PhotoListView: View, Equatable {
    @StateObject var viewModel = PhotoListViewModel()
    let tapOnPhotoAction: (Photo) -> Void
    
    let itemPerRow: CGFloat = 2
    let horizontalSpacing: CGFloat = 16
    let height: CGFloat = 173
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if let count: Int = viewModel.curatedPhotos.photos?.count {
                        ForEach(0..<count, id: \.self) { i in
                            if i % Int(itemPerRow) == 0 {
                                buildView(rowIndex: i, geometry: geometry)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if viewModel.curatedPhotos.photos?.count == 0 || viewModel.curatedPhotos.photos == nil {
                viewModel.getPhotos()
            }
        }
    }
    
    func buildView(rowIndex: Int, geometry: GeometryProxy) -> RowView? {
        var rowPhotos = [Photo]()
        for itemIndex in 0..<Int(itemPerRow) {
            if let photos = viewModel.curatedPhotos.photos {
                if rowIndex + itemIndex < photos.count {
                    rowPhotos.append(photos[rowIndex + itemIndex])
                }
            }
        }
        if !rowPhotos.isEmpty {
            let view = RowView(photos: rowPhotos, width: getWidth(geometry: geometry), height: height, horizontalSpacing: horizontalSpacing, tapOnPhotoAction: tapOnPhotoAction)
            return view
        }
        
        return nil
    }
    
    func getWidth(geometry: GeometryProxy) -> CGFloat {
        let width: CGFloat = (geometry.size.width - horizontalSpacing * (itemPerRow + 1)) / itemPerRow
        return width
    }
    
    static func == (lhs: PhotoListView, rhs: PhotoListView) -> Bool {
        return lhs.viewModel.curatedPhotos.photos?.count == lhs.viewModel.curatedPhotos.photos?.count
    }
}

