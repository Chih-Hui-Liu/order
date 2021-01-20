//
//  DrinkData.swift
//  order
//
//  Created by Leo on 2021/1/13.
//

import Foundation
struct DrinkData: Codable{
    var records:[Records]
    struct Records: Codable {
        var fields:Fields
        struct Fields:Codable{
            var mediumPrice:Int
            var largePrice:Int
            var drinkName:String
            var describe:String
            var drinkImage:[DrinkImage]
            struct DrinkImage:Codable{
                var url:URL
            }

        }
    }
}


