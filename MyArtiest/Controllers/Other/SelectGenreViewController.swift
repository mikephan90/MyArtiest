//
//  SelectGenreViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

class SelectGenreViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = SelectGenresViewModel()
    private var collectionView: UICollectionView!
    private var genres = [String]()
    private var selectedGenres: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(GenreOptionCell.self, forCellWithReuseIdentifier: GenreOptionCell.identifier)
        view.addSubview(collectionView)
    }
    
    // MARK: - Fetch Data
    
    private func fetchData() {
        viewModel.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.genres = response.genres
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension SelectGenreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreOptionCell.identifier, for: indexPath) as! GenreOptionCell? else {
            return UICollectionViewCell()
        }
        
        let genre = genres.sorted()[indexPath.item]
        cell.configure(with: genre)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOption = Array(genres)[indexPath.item]
        selectedGenres.insert(selectedOption)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectedOption = Array(genres)[indexPath.item]
        selectedGenres.remove(deselectedOption)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genre = genres.sorted()[indexPath.item]
        let font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        let width = NSString(string: genre).size(withAttributes: [NSAttributedString.Key.font: font]).width + 50
        let height = NSString(string: genre).size(withAttributes: [NSAttributedString.Key.font: font]).height + 20
        
        return CGSize(width: width, height: height)
    }
}

