//
//  AlbumViewController.swift
//  Exam
//
//  Created by JayR- Mac-mini on 10/22/21.
//

import UIKit

class AlbumViewController: UIViewController {

    private var albumListViewModel : AlbumViewModel!
    var selectedAlbum : Album!
    @IBOutlet var collectionView : UICollectionView!
    
    private var layout = AlbumLayout()
    private lazy var dataSource = albumListViewModel.makeDataSource(collectionView: collectionView, layout: layout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumListViewModel = AlbumViewModel()
        collectionView.collectionViewLayout = layout.make()
        albumListViewModel.getAlbumsList()
        
        //viewModel binding to update Controller when cell is selected
        albumListViewModel.updateControllerAfterCellSelection =  { [self] album in
            selectedAlbum = album
            self.performSegue(withIdentifier: "showDetails", sender: self)
        }
            
        // Initialize diffable data source
        _ = dataSource.snapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! AlbumDetailsViewController
            destinationVC.album = selectedAlbum
    }

}
