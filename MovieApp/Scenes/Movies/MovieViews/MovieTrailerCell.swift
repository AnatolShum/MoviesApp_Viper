//
//  MovieTrailerCell.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 18/12/2023.
//

import UIKit
import Combine

protocol MovieTrailerCellDelegate: AnyObject {
    func playTrailer(key: String)
}

class MovieTrailerCell: UICollectionViewCell {
    static let reuseIdentifier = "TrailerCell"
    
    weak var delegate: MovieTrailerCellDelegate?
    private var videoKey: String?
    private var cancellable: [AnyCancellable] = []
    @Published private var trailerImage: UIImage? = nil
    
    let trailerImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "film")
        image.tintColor = .white.withAlphaComponent(0.02)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white.withAlphaComponent(0.7)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let trailerTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        createUI()
        subscribe()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playTapped() {
        guard let key = videoKey else { return }
        delegate?.playTrailer(key: key)
    }
    
    private func createUI() {
        addSubview(trailerImageView)
        addSubview(playButton)
        addSubview(trailerTitle)
        
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            trailerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            trailerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            trailerImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            playButton.centerXAnchor.constraint(equalTo: trailerImageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: trailerImageView.centerYAnchor),
            trailerTitle.topAnchor.constraint(equalTo: trailerImageView.bottomAnchor, constant: 10),
            trailerTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            trailerTitle.heightAnchor.constraint(equalToConstant: 20),
            trailerTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    func configureCell(with trailer: Trailer) {
        DispatchQueue.main.async {
            self.trailerTitle.text = trailer.title
            self.videoKey = trailer.videoKey
            self.setButtonImage(trailer)
            if let image = trailer.getImage() {
                self.trailerImageView.contentMode = .scaleAspectFill
                self.trailerImage = image
            } else {
                self.getImage(trailer.imagePath)
            }
        }
    }
    
    private func subscribe() {
        $trailerImage
            .receive(on: DispatchQueue.main)
            .assign(to: \.subscribeImage, on: trailerImageView)
            .store(in: &cancellable)
    }
    
    private func getImage(_ path: String?) {
        DispatchQueue.main.async {
            Task {
                do {
                    let image = try await Network.Client.shared.fetchImage(with: path)
                    self.trailerImageView.contentMode = .scaleAspectFill
                    self.trailerImage = image
                } catch {
                    print(error)
                    self.trailerImage = UIImage(systemName: "film")
                    self.trailerImageView.tintColor = .white.withAlphaComponent(0.1)
                    self.trailerImageView.contentMode = .scaleAspectFit
                }
            }
        }
    }
    
    private func setButtonImage(_ trailer: Trailer) {
        var image: UIImage
        var configuration: UIImage.Configuration
        if trailer.videoKey == nil {
            image = UIImage(systemName: "play.slash.fill")!
            configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        } else {
            image = UIImage(systemName: "play.circle")!
            configuration = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
        }
        
        playButton.setImage(image.withConfiguration(configuration), for: .normal)
    }
}
