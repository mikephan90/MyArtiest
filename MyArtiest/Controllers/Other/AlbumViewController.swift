//
//  AlbumViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/17/24.
//

import UIKit

class AlbumViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = AlbumViewModel()
    
    private var collectionView: UICollectionView!
    
    private(set) var tracks: [AudioTrack] = []
    
    private let albumId: String
    
    // MARK: - Init
    
    init(albumId: String) {
        self.albumId = albumId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    
    // TopImage / Album iamge
    // Album name: Artist
    
    // list of tracks that can be pressable
    // just do a long list now, do accordian style later.
    // bottom display other related albums by artist
    
    private var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        imageView.image = UIImage(systemName: "play.circle")
        
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "album name"
        
        return label
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist name"
        
        return label
    }()
    
    private var otherAlbumsHeadwerLabel: UILabel = {
        let label = UILabel()
        label.text = "Albums"
        return label
    }()
    
    // Display Collectionview of other albums
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchData(albumId: albumId)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return self.createSectionLayout(section: sectionIndex)
            }
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        view.addSubview(topImageView)
        view.addSubview(albumNameLabel)
        view.addSubview(artistNameLabel)
        
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -10),
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20),
            artistNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            albumNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant:  -10),
            albumNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20),
            albumNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
    }
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )]
    
        switch section {
        case 0:
            print(tracks)
            let numberOfItems = tracks.count
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 14, bottom: 0, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(40 * CGFloat(numberOfItems))
                ),
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
//            section.orthogonalScrollingBehavior = .continuous
//            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
            
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
                subitems: Array(repeating: item, count: 1)
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 60, trailing: 0)
            
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
    
    private func fetchData(albumId: String) {
        viewModel.fetchAlbumTracks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let audioTracks):
                    self?.tracks = audioTracks
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}
