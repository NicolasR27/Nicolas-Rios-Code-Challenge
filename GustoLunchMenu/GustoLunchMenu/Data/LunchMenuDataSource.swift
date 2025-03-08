//
//  LunchMenuDataSource.swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation


final class LunchMenuDataSource: LunchMenuService {
    func fetchLunchMenu() async -> [[String]] {
        return [
            ["Chicken and waffles", "Tacos", "Curry", "Pizza", "Sushi"],
            ["Breakfast for lunch", "Hamburgers", "Spaghetti", "Salmon", "Sandwiches"]
        ]
    }
}
