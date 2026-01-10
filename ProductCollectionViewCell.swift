import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet var ivLogo: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblSoldout: UILabel!
    @IBOutlet var lblBestseller: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var bFavourite: UIButton!
    
    private var dataTask: URLSessionDataTask? = nil
    private var productIdentifier: String?
    
    var product: Product? {
        didSet {
            guard let product else { return }
            self.productIdentifier = product.productIdentifier
            self.lblTitle.text = product.brand
            self.lblSubtitle.text = product.productName
            
            self.lblSoldout.isHidden = product.quantity > 0
            self.lblBestseller.isHidden = !product.isBestseller
            
            self.lblPrice.text = String(format: "$%0.2f", product.price)
            
            // Устанавливаем изображение кнопки
            updateFavoriteButton(isFavorite: product.isLiked)
            
            // Загружаем изображение продукта
            if let url = URL(string: product.imageUrl) {
                self.dataTask?.cancel()
                self.dataTask = self.ivLogo.setImage(from: url) { img in
                    self.dataTask = nil
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bFavourite.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let productIdentifier = productIdentifier else { return }
        
        // Сохраняем текущее состояние ДО изменения
        let wasFavorite = ProductsManager.shared.isFavorite(productIdentifier: productIdentifier)
        
        // Переключаем состояние
        ProductsManager.shared.toggleFavorite(for: productIdentifier)
        
        // Получаем новое состояние
        let isNowFavorite = ProductsManager.shared.isFavorite(productIdentifier: productIdentifier)
        
        // Обновляем кнопку
        updateFavoriteButton(isFavorite: isNowFavorite)
        
        // Обновляем локальный объект product
        if var currentProduct = product {
            currentProduct.isLiked = isNowFavorite
            self.product = currentProduct // Это вызовет didSet с обновленными данными
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let heartImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        bFavourite.setImage(heartImage, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ivLogo.image = nil
        self.productIdentifier = nil
        bFavourite.setImage(UIImage(systemName: "heart"), for: .normal)
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
