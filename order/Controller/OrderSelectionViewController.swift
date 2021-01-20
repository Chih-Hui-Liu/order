//
//  ViewController.swift
//  order
//
//  Created by Leo on 2021/1/13.
//

import UIKit

class OrderSelectionViewController: UIViewController {
    var drinkData:DrinkData? //接受第一個頁面選擇的資料
    var editData = [Records]()//接收修改頁面的資料
    var editRow : Int?
    var images : UIImage?
    var number:Int?
    var checkSelectController:Bool! //主要是用segue action資料因要判別選擇與修改因此一開始的選擇會用true list清單則用false
    var id:String?
    @IBOutlet weak var customSelectionTableView: UITableView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var describe: UILabel!
  
    var sizeChecked = Array(repeating: false, count: Size.allCases.count)
    var tempChecked = Array(repeating: false, count: Temp.allCases.count)
    var sugarChecked = Array(repeating: false, count: Sugar.allCases.count)
    var feedChecked = Array(repeating: false, count: Feed.allCases.count)
    var delegate : OrderListViewController?//是為了dismiss後顯示原本頁面做跟新的動作因此用來存放
    var sugar:String?
    var temp:String?
    var size:String?
    var userNames:String?
    var feed = ["",""]
    var total : Int = 0
    var price :Int = 0
    var largePrice:Int = 0
    var mediumPrice = 0
    var feedPrice:Int  = 0
    var quantity:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate 要就用左變物件連起來,不然就用.delegate = self(自己viewController)
        customSelectionTableView.delegate = self
        customSelectionTableView.dataSource = self
        if checkSelectController{ //判斷第一個頁面還是修改頁面
            image.image = images
            describe.text = drinkData!.records[number!].fields.describe
            drinkName.text = drinkData!.records[number!].fields.drinkName
            mediumPrice = drinkData!.records[number!].fields.mediumPrice
            largePrice = drinkData!.records[number!].fields.largePrice
            price = mediumPrice
            priceTotal()
        }else{
            image.image = UIImage(named: "0")
            drinkName.text = editData[editRow!].fields.drinkName
            describe.text = "編輯中畫面"
            userName.text = userNames!
            quantityLabel.text = String(quantity)
            priceLabel.text = String(total)
        }
        
    }
    
    @IBAction func addOrMinus(_ sender: UIButton) {
            if sender.tag == 1{
                quantity += 1
            }else if sender.tag == 0{
                if quantity > 1{
                    quantity -= 1
                }else{
                    quantity = 1
                }
            }
        quantityLabel.text = String(quantity)
        priceTotal()
    }
    @IBAction func updateToList(_ sender: UIButton) {
        let controller = UIAlertController(title:"加入訂單", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
            guard self.checkOption() else{return}
            self.userUpdate()
            self.dismiss(animated: true) {
                self.delegate?.fetchData()//回到原本頁面後能使用原本頁面的function
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
    }
    func checkOption()->Bool{
        var check = false //forEash 如 for in 一個一個呈現 因為checked陣列內只會有一個是true每過一個forEach內檢查若只要其中一個陣列內全都是false check 就會false
        sizeChecked.forEach{
            guard $0 == true else{ return}
            sugarChecked.forEach{
                guard $0 == true else { return}
                tempChecked.forEach{
                    guard $0 == true else{return}
                    guard ((userName.text?.isEmpty) == false) else{return}
                    check = true
                }
            }
        }
        if check == false{
            let controller = UIAlertController(title: "", message: "資料未填寫完全", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
        return check
    }
    
    
}

extension OrderSelectionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        OrderInfo.allCases.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch OrderInfo.allCases[section] {
        case .size:
            return "容量"
        case .sugar :
            return "甜度"
        case .temp :
            return "溫度"
        case .feed :
            return "加料"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch OrderInfo.allCases[section] {
        case .size:
            return Size.allCases.count
        case .sugar :
            return Sugar.allCases.count
        case .temp :
            return Temp.allCases.count
        case .feed :
            return Feed.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch OrderInfo.allCases[indexPath.section] {
        case .size:
             cell.textLabel?.text = Size.allCases[indexPath.row].rawValue//顯示建立好的資料
            checkMark(type: sizeChecked, cell: cell, row: indexPath.row)//show出打勾勾
        case .sugar :
            cell.textLabel?.text = Sugar.allCases[indexPath.row].rawValue
            checkMark(type: sugarChecked, cell: cell, row: indexPath.row)
        case .temp :
            cell.textLabel?.text = Temp.allCases[indexPath.row].rawValue
            checkMark(type: tempChecked, cell: cell, row: indexPath.row)
        case .feed :
            cell.textLabel?.text = Feed.allCases[indexPath.row].rawValue
            checkMark(type: feedChecked, cell: cell, row: indexPath.row)
        }
       return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch OrderInfo.allCases[indexPath.section] {
        case .size:
            sizeChecked = Array(repeating: false, count: Size.allCases.count)//再存一次空的概念是為了只能選擇一個
            sizeChecked[indexPath.row] = !sizeChecked[indexPath.row]//是為了選了之後變true 因此表格會跟新
            size = Size.allCases[indexPath.row].rawValue
            if sizeChecked[indexPath.row]{
                if indexPath.row == 0{
                    price = mediumPrice
                }else{
                    price = largePrice
                }
            }
            priceTotal()
        case .sugar:
            sugarChecked = Array(repeating: false, count: Sugar.allCases.count)
            sugarChecked[indexPath.row] = !sugarChecked[indexPath.row]
            sugar = Sugar.allCases[indexPath.row].rawValue
            
        case .temp:
            tempChecked = Array(repeating: false, count: Temp.allCases.count)
            tempChecked[indexPath.row] = !tempChecked[indexPath.row]
            temp = Temp.allCases[indexPath.row].rawValue
        case .feed:
            feedChecked[indexPath.row] = !feedChecked[indexPath.row]
            if feedChecked[indexPath.row]{
                feed[indexPath.row] = Feed.allCases[indexPath.row].rawValue// 判斷陣存放加料字串
                if indexPath.row == 0{//判斷價錢的計算
                    feedPrice += 10
                }else if indexPath.row == 1{
                    feedPrice += 15
                }
            }else{
                feed[indexPath.row] = ""
                if indexPath.row == 0{
                    feedPrice -= 10
                }else if indexPath.row == 1{
                    feedPrice -= 15
                }
            }
            priceTotal()
        }
        tableView.reloadData()//隨時跟新tableView
    }
    func checkMark(type:[Bool],cell:UITableViewCell,row:Int){//一開始都是儲存false ，didseletRowAt上判斷是否該顯示checkmark選到的就會變true
        if type[row]{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
    }
    func feedToString()->String{ //讓珍珠加再一起
        var feedStr = ""
        for feed in feed{
            feedStr += feed + ""
        }
        return feedStr
    }
    func priceTotal(){//計算多少錢
        total = 0
        total = (feedPrice + price) * quantity
        priceLabel.text = String(total)
    }
    //MARK: - 資料上傳與修改
    func userUpdate(){
        let fields = Fiedls(userName: userName.text!, drinkName: drinkName.text!, sugar: sugar!, temp: temp!, size: size!, feed: feedToString(), price:total , quantity: quantity,mediumPrice:price,largePrice:largePrice)
        let drinkOrder = PostDrinkOrder(fields: fields)
        var string = String()
        var httpMethod = String()
        if checkSelectController {//判別是哪個頁面需要做什麼的功能
           string = key.updateUrl
            httpMethod = "POST" //創建
        }else{
            string = key.updateUrl + "/" + id!
            httpMethod = "PATCH" //修改
        }
        let url = URL(string:string)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = httpMethod
        // set HTTPHeaderField
        urlRequest.setValue("Bearer \(key.apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(drinkOrder){
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, urlRespone, error) in
                if let response = urlRespone as? HTTPURLResponse,response.statusCode == 200,error == nil{
                    print("success")
                }else{
                    print("error")
                }
            }.resume()
        }
    }
}
