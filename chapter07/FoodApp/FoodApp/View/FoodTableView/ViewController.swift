//
//  ViewController.swift
//  FoodApp
//
//  Created by 藤門莉生 on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {
    
    let tableViewItemsSectioned = BehaviorRelay.init(value: [
        SectionModel(header: "Main Courses", items: [
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
        ]),
        SectionModel(header: "Desserts", items: [
            Food.init(name: "Pancakes", image: "pancakes"),
            Food.init(name: "Tiramisu", image: "tiramisu"),
            Food.init(name: "Cake", image: "cake"),
        ]),
    ])
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
        configureCell: { datasource, tableView, indexPath, item in
            let cell: FoodTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FoodTableViewCell
            cell.foodLabel.text = item.name
            cell.foodImageView.image = UIImage(named: item.image)
            
            return cell
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    )
    
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
                self.tableViewItemsSectioned.value.map { sectionModel in
                    SectionModel(
                        header: sectionModel.header,
                        items: sectionModel.items.filter({ food in
                            query.isEmpty || food.name.lowercased().contains(query.lowercased())
                        })
                    )
                }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
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
