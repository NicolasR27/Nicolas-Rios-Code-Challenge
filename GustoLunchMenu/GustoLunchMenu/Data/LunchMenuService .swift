//
//   LunchMenuService .swift
//  GustoLunchMenu
//
//  Created by Nicolas Rios on 3/7/25.
//

import Foundation

protocol LunchMenuService {
    func fetchLunchMenu() async -> [[String]]
}
