//
//  ShowTableViewController.swift
//  order
//
//  Created by Leo on 2021/1/14.
//

import UIKit
class ShowTableViewController: UITableViewController {
    var drinkData : DrinkData?
    override func viewDidLoad() {
        super.viewDidLoad()
        getDrinkData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drinkData?.records.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        let data = drinkData?.records[indexPath.row].fields
        guard let medium = data?.mediumPrice, let large = data?.largePrice ,let drinkName = data?.drinkName ,let describe = data?.describe else { return cell}
        cell.drinkImage.image = getImage(index: indexPath.row)
        cell.name.text = "飲品：" + drinkName
        cell.describe.text = describe
        cell.mediumPrice.text = "中杯：" + String(medium)
        cell.largePrice.text = "大杯：" + String(large)
        return cell
    }
    func getImage(index row:Int)->UIImage?{
        var image:UIImage?
        do {
            if let url = drinkData?.records[row].fields.drinkImage[0].url{
                let data = try Data(contentsOf:url )
                    image = UIImage(data: data)
            }
        }catch  {
            print("error")
        }
        return image
    }
    func getDrinkData(){
        if let url = URL(string:key.orderUrl ){
            var request = URLRequest(url: url)
            request.setValue("Bearer \(key.apiKey)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
            let decoder = JSONDecoder()
                if let data = data{
                    do {
                        let dataRespone = try decoder.decode(DrinkData.self, from: data)
                        self.drinkData = dataRespone
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch  {
                        print("error")
                    }
                }
            }.resume()
        }
       
    }
    
    @IBSegueAction func showToView(_ coder: NSCoder) -> OrderSelectionViewController? {//傳遞給select的那頁所需呈現的資料
        guard let number = tableView.indexPathForSelectedRow?.row,let image = getImage(index: number),let drinkData = drinkData else{ return nil }
        let controller =  OrderSelectionViewController(coder: coder)
        controller?.drinkData = drinkData
        controller?.images = image
        controller?.number = number
        controller?.checkSelectController = true
        
        return  controller
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

