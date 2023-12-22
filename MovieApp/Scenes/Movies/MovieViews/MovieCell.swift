//
//  MovieCell.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 03/10/2023.
//

import UIKit

protocol MovieCellDelegate: AnyObject {
    func reloadDataSource()
}

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
    
    weak var delegate: MovieCellDelegate?
    
    private var movie: Movie!
    private var manager: ProtocolFavouriteManager!
    
    let movieImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let favouritesButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let image = UIImage(systemName: "heart", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .systemPink.withAlphaComponent(0.6)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var circleProgressView = CircularProgressView()
    
    var isFavourite: Bool = false {
        didSet {
            DispatchQueue.main.async {
                let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
                let image = UIImage(systemName: self.imageName(), withConfiguration: configuration)
                self.favouritesButton.setImage(image, for: .normal)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        DispatchQueue.main.async {
            self.movieImageView.image = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.backgroundColor = .black.withAlphaComponent(0.9)
        createUI()
        setConstraints()
        favouritesButton.addTarget(self, action: #selector(favouritesTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        addSubview(movieImageView)
        addSubview(favouritesButton)
        addSubview(circleProgressView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor),
            movieImageView.leftAnchor.constraint(equalTo: leftAnchor),
            movieImageView.rightAnchor.constraint(equalTo: rightAnchor),
            movieImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            favouritesButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            favouritesButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            circleProgressView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            circleProgressView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 50),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            releaseDateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            releaseDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    @objc func favouritesTapped() {
        delegate?.reloadDataSource()
        guard manager != nil else { return }
        manager.toggleFavourites()
        isFavourite.toggle()
    }
    
    func configureCell(with movie: Movie) {
        self.movie = movie
        self.manager = FavouriteManager()
        manager.delegate = self
        
        DispatchQueue.main.async {
            self.manager.checkFavourite()
            self.titleLabel.text = movie.title
            self.releaseDateLabel.text = self.formattedDate(movie.releaseDate)
            self.circleProgressView.progressAnimation(movie.vote)
            self.circleProgressView.voteLabel.text = self.formattedString(movie.vote ?? 0)
            self.fetchImage(movie.poster)
        }
    }
    
    private func formattedString(_ vote: Double) -> String {
        return String(format: "%.1f", vote)
    }
    
    func formattedDate(_ date: String?) -> String {
        guard let inputDate = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: inputDate) else { return "" }
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func fetchImage(_ poster: String?) {
        Task {
            do {
                let poster = try await Network.Client.shared.fetchImage(with: poster)
                DispatchQueue.main.async {
                    self.movieImageView.image = poster
                }
            } catch {
                DispatchQueue.main.async {
                    self.movieImageView.image = UIImage(systemName: "film")
                    self.movieImageView.tintColor = .white.withAlphaComponent(0.1)
                    self.movieImageView.contentMode = .scaleAspectFit
                }
                print(error.localizedDescription)
            }
        }
    }
    
    private func imageName() -> String {
        isFavourite ? "heart.fill" : "heart"
    }
}

extension MovieCell: ProtocolIsFavourites { }
