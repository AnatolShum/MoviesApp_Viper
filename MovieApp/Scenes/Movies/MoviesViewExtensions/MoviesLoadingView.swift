//
//  MoviesLoadingView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 12.03.2024.
//

import Foundation

extension MoviesController {
    func showLoadingView() {
        loadingView = LoadingView()
        addChild(loadingView!)
        loadingView?.view.frame = view.frame
        view.addSubview(loadingView!.view)
        loadingView?.didMove(toParent: self)
    }
    
    func stopShowingLoadingView() {
        loadingView?.willMove(toParent: nil)
        loadingView?.view.removeFromSuperview()
        loadingView?.removeFromParent()
        loadingView = nil
    }
}
