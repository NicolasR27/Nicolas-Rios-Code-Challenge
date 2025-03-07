//
//  MainUIKitViewController.swift
//  Gusto Lunch Menu
//
//  Created by GustoBot on 6/14/22.
//

import UIKit

class MainUIKitViewController: UIViewController {
  lazy var label: UILabel = {
    let it = UILabel()
    it.translatesAutoresizingMaskIntoConstraints = false
    it.numberOfLines = 0
    it.textAlignment = .center
    return it
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    let safeArea = view.safeAreaLayoutGuide
    view.backgroundColor = UIColor.white
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: safeArea.topAnchor),
      label.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      label.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])

    label.text = "Your UI goes here,\nin MainUIKitViewController"
  }
}
