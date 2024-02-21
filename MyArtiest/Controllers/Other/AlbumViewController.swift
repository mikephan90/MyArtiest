//
//  AlbumViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/17/24.
//

import UIKit
import SDWebImage

class AlbumViewController: UIViewController {
    
    // MARK: - Properties
    
    enum AlbumSectionType {
        case tracklist(viewModels: [AudioTrack])
//        case relatedAlbums(viewModels: [SongCellViewModel])
    }
    
    private var viewModel = AlbumViewModel()
    private var collectionView: UICollectionView!
    private var tracks: [AudioTrack] = []
    private let album: Album
    private var sections = [AlbumSectionType]()
    
    // MARK: - Init
    
    init(album: Album) {
        self.album = album
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.zPosition = -2
        
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = -1
        
        return view
    }()
    
    private var albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        return label
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        
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
        
        configure()
        setupUI()
        setupGradientOverlay()
        fetchData(albumId: album.id)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return self.createSectionLayout(section: sectionIndex)
            }
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .customBackground
 
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        //        tabBarController?.tabBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        overlayView.frame = view.bounds
        
        view.addSubview(topImageView)
        view.addSubview(overlayView)
        
        view.addSubview(albumNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(collectionView)
        
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: view.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            topImageView.heightAnchor.constraint(equalToConstant: view.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topImageView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            albumNameLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: -5),
            albumNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            albumNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.bottomAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -20),
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20),
            artistNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
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
            let numberOfItems = tracks.count
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(60)
                )
            )
            
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(60 * CGFloat(numberOfItems))
                ),
                subitems: [item]
            )
            
            group.interItemSpacing = .fixed(10)
            
            
            let section = NSCollectionLayoutSection(group: group)
            //            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 14, bottom: 20, trailing: 14)
            
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
        viewModel.fetchAlbumTracks(albumId: albumId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let audioTracks):
                    self?.tracks = audioTracks.items
                    self?.configureModels()
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupGradientOverlay() {
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.customBackground.cgColor]
        gradientLayer.locations = [0.0, 0.33]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureModels() {
        sections.removeAll()
        sections.append(.tracklist(viewModels: tracks))
//        sections.append(.relatedAlbums(viewModels: album))
    }
    
    private func configure() {
        albumNameLabel.text = album.name
        artistNameLabel.text = album.artists.first?.name
        topImageView.sd_setImage(with: URL(string: album.images.first?.url ?? ""))
    }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .tracklist(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            let track = tracks[indexPath.row]
            cell.configure(with: track, index: indexPath.row)
            return cell
        }
    }
}
