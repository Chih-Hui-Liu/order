//
//  UserUpdate.swift
//  order
//
//  Created by Leo on 2021/1/15.
//

import Foundation

struct UserUpdate: Codable{
    var records:[Records]
}

struct PostDrinkOrder: Codable {
    var fields: Fiedls
}
struct Records: Codable {
    var id:String
    var createdTime: String
    var fields: Fiedls
}
struct Fiedls: Codable {
    var userName: String
    var drinkName: String
    var sugar: String
    var temp: String
    var size: String
    var feed: String?
    var price:Int
    var quantity:Int
    var mediumPrice:Int
    var largePrice:Int
}
struct DeleteData: Codable {
    var deleted: Bool
}
    


