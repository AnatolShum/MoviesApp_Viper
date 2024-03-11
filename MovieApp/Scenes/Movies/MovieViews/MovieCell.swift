//
//  MovieCell.swift
//  MoviesAppUIKit
//
//  Created by Anatolii Shumov on 03/10/2023.
//

import UIKit
import Combine

protocol MovieCellDelegate: AnyObject {
    func reloadDataSource()
}

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
    
    weak var delegate: MovieCellDelegate?

    private var favouriteManager: ProtocolFavouriteManager?
    private var cancellable: [AnyCancellable] = []
    @Published private var movieImage: UIImage? = nil
    
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
                let image = UIImage(
                    systemName: self.isFavourite ? "heart.fill" : "heart",
                    withConfiguration: configuration)
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
        subscribe()
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
        guard let favouriteManager else { return }
        favouriteManager.toggleFavourites()
        isFavourite.toggle()
    }
    
    func configureCell(with movie: Movie) {
        self.favouriteManager = FavouriteManager()
        favouriteManager?.delegate = self
        
        DispatchQueue.main.async {
            self.favouriteManager?.checkFavourite()
            self.titleLabel.text = movie.title
            self.releaseDateLabel.text = self.formattedDate(movie.releaseDate)
            self.circleProgressView.progressAnimation(movie.vote)
            self.circleProgressView.voteLabel.text = self.formattedString(movie.vote ?? 0)
            if let image = movie.getImage() {
                self.movieImage = image
            } else {
                self.getImage(movie.poster)
            }
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
    
    private func subscribe() {
        $movieImage
            .receive(on: DispatchQueue.main)
            .assign(to: \.subscribeImage, on: movieImageView)
            .store(in: &cancellable)
    }
    
    private func getImage(_ path: String?) {
        Network.Client.shared.fetchImage(with: path)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.movieImage = UIImage(systemName: "film")
                    self?.movieImageView.tintColor = .white.withAlphaComponent(0.1)
                    self?.movieImageView.contentMode = .scaleAspectFit
                }
            }, receiveValue: { [weak self] image in
                self?.movieImage = image
            })
            .store(in: &cancellable)
    }

}

extension MovieCell: ProtocolIsFavourites { }

