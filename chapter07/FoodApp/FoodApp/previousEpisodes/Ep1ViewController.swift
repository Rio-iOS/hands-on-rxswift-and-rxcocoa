//
//  Ep1ViewController.swift
//  FoodApp
//
//  Created by 藤門莉生 on 2023/05/02.
//

import UIKit
import RxSwift
import RxCocoa

/*
 Chapter07の【10.】のViewController
 */
class Ep1ViewController: UIViewController {

    let tableViewItems = Observable.just(["Item 1", "Item 2", "Item 3", "Item 4"])
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.delegate = self
        // tableView.dataSource = self
        tableViewItems
            .bind(to: tableView.rx.items(cellIdentifier: "myCell")) { (row, tableViewItem, cell) in
                var contentConfiguration = cell.defaultContentConfiguration()
                contentConfiguration.text = tableViewItem
                cell.contentConfiguration = contentConfiguration
            }
            .disposed(by: disposeBag)
        
    }
}

/*
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
*/

/*
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = tableViewItems[indexPath.row]
        cell.contentConfiguration = contentConfiguration
        
        
        return cell
    }
}
*/
