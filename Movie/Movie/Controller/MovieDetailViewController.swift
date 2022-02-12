//
//  MovieDetailViewController.swift
//  Movie
//
//  Created by admin on 2022/02/08.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    var VCtitle : String?
    var VCrating : Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rating = Double?(VCrating ?? 0){ // optional(X.x) -> X.x로 변환 과정
            self.rating.text = "\(rating)"
        }
        
        if self.movieTitle.adjustsFontSizeToFitWidth == false{
            self.movieTitle.adjustsFontSizeToFitWidth = true
        }
        movieTitle.text = VCtitle
    }
    

}
