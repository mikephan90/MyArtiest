//
//  ArtistViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/22/24.
//

import UIKit

class ArtistViewController: UIViewController {
    
    // MARK: - Properties
    
    enum AlbumSectionType {
        case tracklist(viewModels: [AudioTrack])
        case relatedAlbums(viewModels: [Album])
        
        var title: String {
            switch self {
            case .tracklist: return "Songs"
            case .relatedAlbums: return "Other Albums by"
            }
        }
    }
    
    private var viewModel = ArtistViewModel()
    
    private var artistId: String
    private var artist: Artist?
    
    private var collectionView: UICollectionView!
    private var isExpanded: Bool = false
    
    private var tracks: [AudioTrack] = []
    private var visibleTracks: [AudioTrack] = []
    private var albums: [Album] = []
    private var sections = [AlbumSectionType]()
    
    // MARK: - Init
    
    init(artistId: String) {
        self.artistId = "0du5cEVh5yTK9QJze8zA0C"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Views
    
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
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        
        return label
    }()
    
    private var expandButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(artistId: artistId)
        setupUI()
        setupGradientOverlay()
    }
    
    private func setupUI() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
                return self.createSectionLayout(section: sectionIndex)
            }
        )
        
        registerCollectionViews()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .customBackground
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        overlayView.frame = view.bounds
        
        view.addSubview(topImageView)
        view.addSubview(overlayView)
        view.addSubview(artistNameLabel)
        view.addSubview(collectionView)
        
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionConstraints()
    }
    
    private func registerCollectionViews() {
        collectionView.register(
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.register(
            ExpandFooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ExpandFooterCollectionReusableView.identifier)
        
        collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        
    }
    
    private func collectionConstraints() {
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
            artistNameLabel.bottomAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -20),
            artistNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20),
            artistNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
    }
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            ),
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(50),
                    heightDimension: .absolute(30)),
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
        ]
        
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14)
            
            // Expanded section
            if !isExpanded {
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                let footerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                section.boundarySupplementaryItems = [supplementaryViews[0], footerSupplementary]
            } else {
                section.boundarySupplementaryItems = [supplementaryViews[0]]
            }
            
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
            
            let headerView = supplementaryViews.first { $0.elementKind == UICollectionView.elementKindSectionHeader }
            section.boundarySupplementaryItems = [headerView].compactMap { $0 }
            
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
    
    private func fetchData(artistId: String) {
        viewModel.fetchArtistData(artistId: artistId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.artist = response.0
                    self?.tracks = response.1
                    self?.albums = response.2
                    
                    self?.visibleTracks = Array(self?.tracks.prefix(5) ?? [])
                    self?.configureModels()
                    self?.configure()
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
        sections.append(.relatedAlbums(viewModels: albums))
    }
    
    private func configure() {
        guard let artist else { return }
        
        artistNameLabel.text = artist.name
        topImageView.sd_setImage(with: URL(string: artist.images?.first?.url ?? ""))
    }
}

extension ArtistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTracks.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .tracklist:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let index = indexPath.row
            let track = tracks[index]
            cell.configure(with: track, index: index + 1)
            
            return cell
        case .relatedAlbums(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = indexPath.section
        let title = sections[section].title
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            let dynamicHeaderTitle = title
            headerView.configure(with: dynamicHeaderTitle)
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ExpandFooterCollectionReusableView.identifier, for: indexPath) as? ExpandFooterCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            footerView.delegate = self
            
            return footerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = sections[indexPath.section]
        switch type {
        case .relatedAlbums(let viewModels):
            let viewModel = viewModels[indexPath.row]
            let vc = AlbumViewController(album: viewModel)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case .tracklist(let viewModels):
            break
        }
    }
}

extension ArtistViewController: ExpandFooterCollectionReusableViewDelegate {
    func didTapExpandTrackList() {
        isExpanded = true
        visibleTracks = tracks
        collectionView.reloadData()
    }
}
