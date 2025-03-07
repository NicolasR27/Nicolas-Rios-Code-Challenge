//
//  LunchMenuDataSource.swift
//  Gusto Lunch Menu
//
//  Created by GustoBot on 6/14/22.
//

import Foundation

class LunchMenuDataSource {
    
    func getLunchMenu(_ completion: @escaping (Array<Array<String>>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(
                [
                    ["Chicken and waffles", "Tacos", "Curry", "Pizza", "Sushi"],
                    ["Breakfast for lunch", "Hamburgers", "Spaghetti", "Salmon", "Sandwiches"]
                ]
            )
        }
    }
}
