//
//  ViewController.swift
//  FoodApp
//
//  Created by 藤門莉生 on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa

class Ep5ViewController: UIViewController {

    let tableViewItems = BehaviorRelay.init(value: [
        Food.init(name: "Hamburger", image: "hamburger"),
        Food.init(name: "Pizza", image: "pizza"),
        Food.init(name: "Salmon", image: "salmon"),
        Food.init(name: "Spaghetti", image: "spaghetti"),
        Food.init(name: "Club-sandwich", image: "club-sandwich"),
        Food.init(name: "Curry", image: "curry"),
        Food.init(name: "Salad cheese", image: "salad-cheese"),
        Food.init(name: "Salad veggy", image: "salad-veg"),
        Food.init(name: "Ribs", image: "ribs"),
        Food.init(name: "Chana masala", image: "chana-masala"),
        Food.init(name: "Pancakes", image: "pancakes"),
        Food.init(name: "Tiramisu", image: "tiramisu"),
        Food.init(name: "Cake", image: "cake"),
    ])
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        
        // tableView.delegate = self
        // tableView.dataSource = self
        
        let foodQuery = searchBar
            .searchTextField
            .rx
            .text
            .orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in
                self.tableViewItems.value.filter { food in
                    query.isEmpty || food.name.lowercased().contains(query.lowercased())
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: "myCell", cellType: FoodTableViewCell.self)) { (row, tableViewItem, cell) in
                cell.foodLabel.text = tableViewItem.name
                cell.foodImageView.image = UIImage(named: tableViewItem.image)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Food.self)
            .subscribe(
                onNext: {
                    foodObject in
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodVC") as! FoodDetailViewController
                    // foodVC.imageName = foodObject.image
                    foodVC.imageName.accept(foodObject.image)
                    self.navigationController?.pushViewController(foodVC, animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe(
                onNext: { indexPath in
                    print(indexPath.row)
                }
            )
            .disposed(by: disposeBag)
        
    }
}

/*
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodVC") as! FoodDetailViewController
        foodVC.imageName = "hamburger"
        self.navigationController?.pushViewController(foodVC, animated: true)
    }
}
*/

