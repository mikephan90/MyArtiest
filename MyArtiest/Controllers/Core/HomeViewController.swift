//
//  ViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation
import UIKit
import CoreData

class HomeViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - Enum
    
    enum HomeSectionType {
        case recommendedSongs(viewModels: [SongCellViewModel])
        case newAlbums(viewModels: [Album])
        case favoriteArtists(viewModels: [FavoriteArtist])
        
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
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "Songs or Artists"
        vc.searchBar.searchBarStyle = .prominent
        vc.definesPresentationContext = true
        
        return vc
    }()
    
    // get from local
    private var genres: Set<String> = ["hip-hop", "chill", "dubstep"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        setBackButtonStyle()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if sections.count > 2 {
//            getFavoriteArtists()
//            collectionView.reloadSections(IndexSet(integer: 2))
//        }
//    }
    
    func setBackButtonStyle() {
        let backButtonImage = UIImage(systemName: "arrowshape.backward.fill")?
            .withTintColor(UIColor.customPrimary, renderingMode: .alwaysOriginal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .customBackground
        title = "Home"
        tabBarController?.tabBar.isHidden = false
        
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return self.createSectionLayout(section: sectionIndex)
            }
        )
        
        collectionView.register(RecommendedSongCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedSongCollectionViewCell.identifier)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        
        collectionView.register(FavoriteArtistCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteArtistCollectionViewCell.identifier)
        collectionView.register(AddNewArtistCollectionViewCell.self, forCellWithReuseIdentifier: AddNewArtistCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        view.addSubview(collectionView)
        
       // check if genre has data
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Required but not used. Future enhancement
    }
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )]
        
        switch section {
        case 0:
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
                    heightDimension: .absolute(160)
                ),
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            
            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(1),
                    heightDimension: .fractionalWidth(1.5)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(140), heightDimension: .absolute(140)
                ),
                subitems: Array(repeating: item, count: 2)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 60, trailing: 0)
            
            return section
        case 2:
            let numberOfItems = viewModel.favoriteArtists.count
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(55)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 14, bottom: 14, trailing: 14)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(55 * CGFloat(numberOfItems))
                ),
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
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
        viewModel.fetchData { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.newReleaseAlbums = response.1
                    
                    self.getFavoriteArtists()
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
        sections.append(.recommendedSongs(viewModels: viewModel.recommendedTracks.compactMap {
            return SongCellViewModel(
                backgroundImage: URL(string: $0.album?.images.first?.url ?? ""),
                name: $0.name,
                artist: $0.artists.first?.name ?? "-"
            )
        }))
        sections.append(.newAlbums(viewModels: newReleaseAlbums.compactMap { $0 }))
        sections.append(.favoriteArtists(viewModels: viewModel.favoriteArtists.compactMap {
            return $0
        }))
    }
    
    private func getFavoriteArtists() {
        viewModel.getFavoriteArtistsFromCoreData()
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
            return viewModels.isEmpty ? 1 : viewModels.count
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        case .favoriteArtists(let viewModels):
            if viewModel.favoriteArtists.count < 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewArtistCollectionViewCell.identifier, for: indexPath) as? AddNewArtistCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.delegate = self
                
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteArtistCollectionViewCell.identifier, for: indexPath) as? FavoriteArtistCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.delegate = self
                let viewModel = viewModels[indexPath.row]
                cell.configure(with: viewModel)
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        let section = indexPath.section
        let title = sections[section].title
        let isFavoriteArtistSection = viewModel.favoriteArtists.count > 0 && section == 2
        header.configure(with: title, isFavoriteArtistSection)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .recommendedSongs:
            let track = viewModel.recommendedTracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        case .newAlbums:
            let album = self.newReleaseAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .favoriteArtists:
            break;
        }
    }
}

extension HomeViewController: UISearchBarDelegate, SearchResultViewControllerDelegate {
    func showResult(_ controller: UIViewController) {
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapAlbumResult(_ album: Album) {
        let vc = AlbumViewController(album: album)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapArtistResult(_ resultId: String) {
        let vc = ArtistViewController(artistId: resultId)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        
        viewModel.search(query: query) { [weak self, weak resultsController] result in
            guard let self = self, let resultsController = resultsController else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    resultsController.update(with: results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension HomeViewController: FavoriteArtistCollectionViewCellDelegate, AddNewArtistCollectionViewCellDelegate, TitleHeaderCollectionReusableViewDelegate {
    func didTapArtist(_ artistId: String) {
        let vc = ArtistViewController(artistId: artistId)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAddNewFavoriteArtist() {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension Notification.Name {
    static let refreshHomeView = Notification.Name("RefreshHomeView")
}
