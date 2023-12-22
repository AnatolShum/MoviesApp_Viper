//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 22/12/2023.
//

import UIKit

class MovieDetailController: UIViewController {
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    

}
