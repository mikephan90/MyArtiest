//
//  ViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Enum
    
    enum HomeSectionType {
        case recommendedSongs(viewModels: [SongCellViewModel])
        case newAlbums(viewModels: [SongCellViewModel])
        case favoriteArtists(viewModels: [RecommendedSongCollectionViewCell])
        
        var title: String {
            switch self {
            case .recommendedSongs: return "Recommended Songs"
            case .newAlbums: return "Explore New Albums"
            case .favoriteArtists: return "Favorite Artists"
            }
        }
    }
    
    // MARK: - Properties
    
    private var collectionView: UICollectionView!
    private var viewModel = HomeViewModel()
    private var sections = [HomeSectionType]()
    private var recommendedSongs = [AudioTrack]()
    private var newReleaseAlbums = [Album]()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // get from local
    private var genres: Set<String> = ["hip-hop", "chill", "dubstep"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .customBackground
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return HomeViewController.createSectionLayout(section: sectionIndex)
            }
        )
        
        collectionView.register(RecommendedSongCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedSongCollectionViewCell.identifier)
        collectionView.register(NewAlbumCollectionViewCell.self, forCellWithReuseIdentifier: NewAlbumCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        // Temp until signout is implemented
        UserDefaults.standard.removeObject(forKey: "first_login")
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            // Create item, to a group, then into a section and return it
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 0)
            
            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(1),
                    heightDimension: .fractionalWidth(1.2)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200), heightDimension: .absolute(200)
                ),
                subitems: Array(repeating: item, count: 2)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80)
                ),
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        }
    }
    
    // MARK: - APIs
    
    private func fetchData() {
        spinner.startAnimating()
        viewModel.genres = genres
        viewModel.fetchData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.recommendedSongs = response.0
                    self.newReleaseAlbums = response.1
                    self.configureModels()
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func configureModels() {
        sections.removeAll()
        sections.append(.recommendedSongs(viewModels: recommendedSongs.compactMap {
            return SongCellViewModel(
                backgroundImage: URL(string: $0.album?.images.first?.url ?? ""),
                name: $0.name,
                artist: $0.artists.first?.name ?? "-"
            )
        }))
        sections.append(.newAlbums(viewModels: newReleaseAlbums.compactMap {
            return SongCellViewModel(
                backgroundImage: URL(string: $0.images.first?.url ?? ""),
                name: $0.name,
                artist: $0.artists.first?.name ?? "-"
            )
        }))
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .recommendedSongs(let viewModels):
            return viewModels.count
        case .newAlbums(let viewModels):
            return viewModels.count
        case .favoriteArtists(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .recommendedSongs(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedSongCollectionViewCell.identifier, for: indexPath) as? RecommendedSongCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        case .newAlbums(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAlbumCollectionViewCell.identifier, for: indexPath) as? NewAlbumCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        case .favoriteArtists(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAlbumCollectionViewCell.identifier, for: indexPath) as? NewAlbumCollectionViewCell else {
                return UICollectionViewCell()
            }
            
//            let viewModel = viewModels[indexPath.row]
//            cell.configure(with: viewModel)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        
        return header
    }
}
