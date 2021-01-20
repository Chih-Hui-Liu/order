//
//  OrderListViewController.swift
//  order
//
//  Created by Leo on 2021/1/17.
//

import UIKit

class OrderListViewController: UIViewController {

    @IBOutlet weak var listOrderTableView: UITableView!
    var listData = [Records]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        print(#function)
    }
    override func viewWillAppear(_ animated: Bool) {
        // 主要是選好後可以隨時跟新上傳的data！，因此要做一個loading畫面不然太慢出現會覺得app 有問題
        fetchData()
        print(#function)
    }
   
    @IBSegueAction func editToSelect(_ coder: NSCoder) -> OrderSelectionViewController? {
        guard let row = listOrderTableView.indexPathsForSelectedRows?.first?.row else { return nil }
        let controller = OrderSelectionViewController(coder: coder)
        controller?.editData = listData
        controller?.editRow = row
        controller?.checkSelectController = false
        controller?.id = listData[row].id
        controller?.userNames = listData[row].fields.userName
        controller?.quantity = listData[row].fields.quantity
        controller?.mediumPrice = listData[row].fields.mediumPrice
        controller?.largePrice = listData[row].fields.largePrice
        controller?.total = listData[row].fields.price
        controller?.delegate = self
      return controller
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    

}
extension OrderListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        cell.userNameLabel.text = listData[indexPath.row].fields.userName
        cell.drinkNameLabel.text = listData[indexPath.row].fields.drinkName
        cell.feedLabel.text = listData[indexPath.row].fields.feed
        cell.sizeLabel.text = listData[indexPath.row].fields.size
        cell.sugarLabel.text = listData[indexPath.row].fields.sugar
        cell.tempLabel.text = listData[indexPath.row].fields.temp
        cell.priceLabel.text = "$" + String(listData[indexPath.row].fields.price)
        cell.quantityLabel.text = String(listData[indexPath.row].fields.quantity) + "杯"
       
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteRow = UIContextualAction(style: .destructive, title: "刪除") { (action, view, completionHandler) in// completionHandler is @escaping(Bool)->Void type
            let controller = UIAlertController(title: "確定刪除？", message:"", preferredStyle:.alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: "確定", style: .default) { (action) in
                let dataID = self.listData[indexPath.row].id
                self.deleteData(id: dataID)
                    self.listData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            controller.addAction(cancelAction)
            controller.addAction(confirmAction)
            self.present(controller, animated: true, completion: nil)
            completionHandler(true)
        }
     
        deleteRow.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteRow])
    }
    func fetchData(){
        if let url = URL(string: key.updateUrl){
            var urlRequest = URLRequest(url: url)
            //urlRequest.httpMethod = ""
            urlRequest.setValue("Bearer \(key.apiKey)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data{
                    do {
                        var result = try decoder.decode(UserUpdate.self, from: data)
                        result.records.sort { (data1,data2) -> Bool in //排序創立的時間
                            data1.createdTime < data2.createdTime
                        }
                        self.listData = result.records
                        DispatchQueue.main.async {
                            self.listOrderTableView.reloadData()
                        }
                    } catch  {
                        print("error")
                    }
                }
            }.resume()
        }
    }
    func deleteData(id:String){
        let deleteUrlStr = key.updateUrl + "/" + id
        if let url = URL(string: deleteUrlStr){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("Bearer \(key.apiKey)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
                if let data = data{
                    do {
                        _ = try JSONDecoder().decode(DeleteData.self, from: data)
                        DispatchQueue.main.async {
                            self.listOrderTableView.reloadData()
                        }
                    } catch  {
                        print("error")
                    }
                }
            }.resume()
        }else{
            print("URL fail")
        }
    }
    
}
    

