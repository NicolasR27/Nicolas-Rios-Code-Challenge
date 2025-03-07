//
//  MainSwiftUIHostController.swift
//  Gusto Lunch Menu
//
//  Created by GustoBot on 7/10/24.
//

import UIKit
import SwiftUI

class MainSwiftUIHostController: UIHostingController<ContentView> {
  init() {
    super.init(rootView: ContentView())
  }

  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
