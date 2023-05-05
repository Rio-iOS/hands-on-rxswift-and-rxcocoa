import UIKit
import RxSwift
import RxCocoa

/*
 Chapter07の【11.】のViewController
 */
class Ep2ViewController: UIViewController {

    let tableViewItems = Observable.just([
        Food.init(name: "Hamburger", image: "hamburger"),
        Food.init(name: "Pizza", image: "pizza"),
        Food.init(name: "Salmon", image: "salmon"),
        Food.init(name: "Spaghetti", image: "spaghetti")
    ])
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Menu"
        
        // tableView.delegate = self
        // tableView.dataSource = self
        
        tableViewItems
            .bind(to: tableView.rx.items(cellIdentifier: "myCell", cellType: FoodTableViewCell.self)) { (row, tableViewItem, cell) in
                cell.foodLabel.text = tableViewItem.name
                cell.foodImageView.image = UIImage(named: tableViewItem.image)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Food.self)
            .subscribe(
                onNext: {
                    foodObject in
                    let foodVC = self.storyboard?.instantiateViewController(withIdentifier: "FoodVC") as! Ep2FoodDetailViewController
                    foodVC.imageName = foodObject.image
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
