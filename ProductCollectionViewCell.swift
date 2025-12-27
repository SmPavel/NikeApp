//
//  ProductCollectionViewCell.swift
//  Smirnov-Pavel
//
//  Created by CSF on 20.12.2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet var ivLogo: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblSoldout: UILabel!
    @IBOutlet var lblBestseller: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    private var dataTask: URLSessionDataTask? = nil
    
    var product: Product? {
        didSet{
            guard let product else{
                return
            }
            self.lblTitle.text = product.brand
            self.lblSubtitle.text = product.productName
            
            self.lblSoldout.isHidden = product.quantity > 0
            self.lblBestseller.isHidden = !product.isBestseller
            
            self.lblPrice.text = String(format: "$%0.2f", product.price)
            
            if let url = URL(string: product.imageUrl){
                self.dataTask?.cancel()
                self.dataTask = self.ivLogo.setImage(from: url) { img in
                    self.dataTask = nil
                }
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.ivLogo.image = nil
    }
}

extension UIImageView {
    func setImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, completion: ((UIImage) -> Void)?) ->
    URLSessionDataTask {
    contentMode = mode
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async() {
                self.image = image
                completion?(image)
            }
        }
        task.resume()
        return task
    }
}
