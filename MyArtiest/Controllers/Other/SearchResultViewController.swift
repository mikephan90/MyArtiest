//
//  SearchResultViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/21/24.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func showResult(_ controller: UIViewController)
    func didTapArtistResult(_ resultId: String)
    func didTapAlbumResult(_ album: Album)
}

class SearchResultViewController: UIViewController {
    
    // MARK: - Properties
    
    enum SearchResultType {
        case tracks(viewModels: [AudioTrack])
        case artists(viewModels: [Artist])
        case albums(viewModels: [Album])
        
        var title: String {
            switch self {
            case .tracks: return "Songs"
            case .artists: return "Artists"
            case .albums: return "Albums"
            }
        }
    }
    
    private var sections: [SearchResultType] = []
    private var collectionView: UICollectionView!
    weak var delegate: SearchResultViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return self.createSectionLayout(section: sectionIndex)
            }
        )
        
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        // TODO: UpDTe
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .customBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // TODO: Instead of having a singular list, break this out into a tab section with these three sections in future enchanment
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )]
        
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(60)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
            
            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(60)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0)
            
            return section
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(60)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            section.interGroupSpacing = 10
            
            return section
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(60)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    func update(with results: SearchResultResponse) {
        sections.removeAll()

        sections.append(.tracks(viewModels: results.tracks.items))
        sections.append(.artists(viewModels: results.artists.items))
        sections.append(.albums(viewModels: results.albums.items))
    
        collectionView.reloadData()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .tracks(let viewModels):
            return viewModels.count
        case .artists:
            return 5
        case .albums(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .tracks(let viewModels):
            break
        case .artists(let viewModels):
            let artistId = viewModels[indexPath.row].id
            delegate?.didTapArtistResult(artistId)
        case .albums(let viewModels):
            let album = viewModels[indexPath.row]
            delegate?.didTapAlbumResult(album)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell()
        }
        
        let type = sections[indexPath.section]
        let index = indexPath.row
        
        switch type {
        case .tracks(let viewModels):
            let viewModel = viewModels[index]
            let imageUrl = URL(string: viewModel.album?.images.first?.url ?? "")
            cell.configure(with: SearchResultViewModel(imageUrl: imageUrl, label: viewModel.name))
            return cell
            
        case .artists(let viewModels):
            let viewModel = viewModels[index]
            let imageUrl = URL(string: viewModel.images?.first?.url ?? "")
            cell.configure(with: SearchResultViewModel(imageUrl: imageUrl, label: viewModel.name))
            return cell
            
        case .albums(let viewModels):
            let viewModel = viewModels[index]
            let imageUrl = URL(string: viewModel.images.first?.url ?? "")
            cell.configure(with: SearchResultViewModel(imageUrl: imageUrl, label: viewModel.name))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView else {
            return UICollectionViewCell()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        
        return header
    }
}
