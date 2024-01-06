//
//  MovieTrailerCell.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 18/12/2023.
//

import UIKit

protocol MovieTrailerCellDelegate: AnyObject {
    func playTrailer(key: String)
}

class MovieTrailerCell: UICollectionViewCell {
    static let reuseIdentifier = "TrailerCell"
    
    weak var delegate: MovieTrailerCellDelegate?
    var videoKey: String?
    
    let trailerImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "film")
        image.tintColor = .white.withAlphaComponent(0.1)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)
        let image = UIImage(systemName: "play.circle", withConfiguration: configuration)
        button.setImage(image, for: .normal)
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
            self.trailerImageView.contentMode = .scaleAspectFill
            self.trailerImageView.image = trailer.trailerImage
            self.trailerTitle.text = trailer.title
            self.videoKey = trailer.videoKey
            self.setButtonImage(trailer)
        }
    }
    
    private func setButtonImage(_ trailer: Trailer) {
        guard trailer.videoKey != nil else { return }
        guard let image = trailer.noTrailerImage else { return }
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        playButton.setImage(image.withConfiguration(configuration), for: .normal)
    }
}
