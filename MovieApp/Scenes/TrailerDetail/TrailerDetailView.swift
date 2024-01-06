//
//  TrailerDetailView.swift
//  MovieApp
//
//  Created by Anatolii Shumov on 22/12/2023.
//

import UIKit

class TrailerDetailController: UIViewController {
    
    let trailer: Trailer
    
    init(trailer: Trailer) {
        self.trailer = trailer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemMint
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
