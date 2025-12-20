//
//  SecondViewController.swift
//  Smirnov-Pavel
//
//  Created by CSF on 08.11.2025.
//

import Foundation

import UIKit

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        for tag in 1...10 {
            if let imageView = view.viewWithTag(tag) as? UIImageView {
                imageView.layer.cornerRadius = 16
                imageView.layer.masksToBounds = true
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for tag in 1...10 {
            if let imageView = view.viewWithTag(tag) as? UIImageView {
                imageView.layer.cornerRadius = 16
                imageView.layer.masksToBounds = true
            }
        }
    }
}
