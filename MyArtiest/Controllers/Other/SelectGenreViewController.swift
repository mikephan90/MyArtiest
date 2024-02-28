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
    private var genres: [String] = []
    private var selectedGenres: Set<String> = []
    
    // MARK: - Views
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Genre(s)"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    
    private var continueButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.configuration?.baseBackgroundColor = .customPrimary
        var buttonText = AttributedString.init("CONTINUE")
        buttonText.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.configuration?.attributedTitle = buttonText
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .customBackground
        
        setupUI()
        fetchData()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(GenreOptionCell.self, forCellWithReuseIdentifier: GenreOptionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    
    @objc func didTapContinue() {
        if selectedGenres.count > 0 {
            AppDataManager.shared.addGenresToCoreData(genres: selectedGenres)
            
            let mainVC = TabBarViewController()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
        } else {
            genreSelectionErrorAlert()
        }
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
    
    private func genreSelectionErrorAlert() {
        let alert = UIAlertController(title: "Error!", message: "Please select at least 1 genre.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        present(alert, animated: true)
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
