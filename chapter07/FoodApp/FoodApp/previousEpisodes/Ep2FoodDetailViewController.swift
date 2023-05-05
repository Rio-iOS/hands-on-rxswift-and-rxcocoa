//
//  Ep2FoodDetailViewController.swift
//  FoodApp
//
//  Created by 藤門莉生 on 2023/05/02.
//

import Foundation
import UIKit

class Ep2FoodDetailViewController: UIViewController {
    @IBOutlet weak var foodImageView: UIImageView!
    
    var imageName: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImageView.image = UIImage(named: imageName)
    }
}
