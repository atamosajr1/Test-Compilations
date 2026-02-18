//
//  AlbumViewModel.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class AlbumViewModel: NSObject, UICollectionViewDelegate {
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Album>
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<Section, Album>
    
    private var sections = Section.allSections
    var dataSource: DiffableDataSource!
    private var lastOffset = 1
    private(set) var albums : [Album]!
    private var collectionView : UICollectionView!
    
    var updateControllerAfterCellSelection : ((_ Album : Album) -> ()) = {_ in }
    
    override init() {
        super.init()
        albums = [Album]()
    }
    
    func makeDataSource(collectionView: UICollectionView,  layout: AlbumLayout) -> DiffableDataSource {
        self.collectionView = collectionView
        self.collectionView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(refreshControl:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        dataSource = DiffableDataSource(collectionView: collectionView,
                                        cellProvider: cellProvider)
        
        return dataSource
    }
    
    func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, album: Album) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: "AlbumCollectionViewCell",
          for: indexPath) as? AlbumCell
        cell?.album = album
        return cell
    }
    
    func getAlbumsList() {
        APIService.shared.getAlbumsList(offset: lastOffset, count: 10) {[self] result, error in
            guard let result = result else { return }
            lastOffset += 1
            if let albumResults = result.results {
                albums.insert(contentsOf: albumResults, at: 0)
            }
            applySnapshot()
        }
    }
    
    @objc func refreshData(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            self.getAlbumsList()
        }
        refreshControl.endRefreshing()
    }
    
    //
    func applySnapshot(animatingDifferences: Bool = true) {
      var snapshot = DiffableSnapshot()
      snapshot.appendSections(sections)
      sections.forEach { section in
        snapshot.appendItems(albums, toSection: section)
      }
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        self.updateControllerAfterCellSelection(album)
    }
}
