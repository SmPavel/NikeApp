//
//  CategoryViewController.swift
//  Smirnov-Pavel
//
//  Created by CSF on 29.11.2025.
//

import Foundation

import UIKit
struct Category {
    let name: String
    let imageName: String
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
        @IBOutlet weak var tableView: UITableView!
    
    let categories: [Category] = [
        Category(name: "Baseball", imageName: "baseball"),
        Category(name: "Big & Tall", imageName: "big_tall"),
        Category(name: "Cross-Training", imageName: "cross_training"),
        Category(name: "Dance", imageName: "dance"),
        Category(name: "Lacrosse", imageName: "lacrosse"),
        Category(name: "Maternity", imageName: "maternity"),
        Category(name: "N7", imageName: "n7"),
        Category(name: "Nike Sportswear", imageName: "nike_sportswear")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
          tableView.delegate = self
          tableView.dataSource = self
          tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
          tableView.rowHeight = 70
          tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
          tableView.backgroundColor = UIColor.black
      }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.black
    
        if let circularImage = createCircularImageFromAssets(
            imageName: category.imageName,
            size: CGSize(width: 50, height: 50)
        ) {
            cell.imageView?.image = circularImage
        }
        
        return cell
    }
    
    // MARK: - Создание круглого изображения
    
    private func createCircularImageFromAssets(imageName: String, size: CGSize) -> UIImage? {
        guard let originalImage = UIImage(named: imageName) else {
            return createPlaceholderCircle(size: size)
        }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            let path = UIBezierPath(ovalIn: rect)
            path.addClip()
            
            originalImage.draw(in: rect)
        }
    }
    
    private func createPlaceholderCircle(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.systemGray4.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected: \(categories[indexPath.row].name)")
    }
}
