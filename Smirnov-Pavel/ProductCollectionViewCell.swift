// ProductCollectionViewCell.swift
import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets (свяжите их в Storyboard)
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bestsellerBadge: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    private var product: Product?
    var likeButtonTappedHandler: ((Product?) -> Void)?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        brandLabel.text = nil
        productNameLabel.text = nil
        priceLabel.text = nil
        bestsellerBadge.isHidden = true
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
    }
    
    // MARK: - Setup
    private func setupCell() {
        // Настройка внешнего вида
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.clipsToBounds = true
        
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        productImageView.backgroundColor = .systemGray6
        
        bestsellerBadge.layer.cornerRadius = 4
        bestsellerBadge.clipsToBounds = true
        bestsellerBadge.backgroundColor = .orange
        bestsellerBadge.textColor = .white
        bestsellerBadge.font = .systemFont(ofSize: 10, weight: .bold)
        bestsellerBadge.textAlignment = .center
        bestsellerBadge.text = "Bestseller"
        
        // Настройка кнопки лайка
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        
        // Настройка теней (опционально)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    // MARK: - Configuration
    func configure(with product: Product) {
        self.product = product
        
        brandLabel.text = product.brand
        productNameLabel.text = product.productName
        productNameLabel.numberOfLines = 2
        
        // Форматирование цены
        if product.price.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "$\(Int(product.price))"
        } else {
            priceLabel.text = String(format: "$%.2f", product.price)
        }
        
        // Статус наличия
        updateStockLabel(itemsLeft: product.itemsLeft)
        
        // Бейдж бестселлера
        bestsellerBadge.isHidden = !product.isBestseller
        
        // Кнопка лайка
        updateLikeButton(isLiked: product.isLiked)
        
        // Загрузка изображения
        loadImage(from: product.imageURL)
    }
    
    private func updateStockLabel(itemsLeft: Int) {
        if itemsLeft == 0 {
            stockLabel.text = "Out of stock"
            stockLabel.textColor = .red
        } else if itemsLeft <= 5 {
            stockLabel.text = "Only \(itemsLeft) left"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "In stock"
            stockLabel.textColor = .green
        }
    }
    
    private func updateLikeButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = isLiked ? .red : .gray
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            productImageView.image = UIImage(systemName: "photo")
            return
        }
        
        // Используйте SDWebImage или Kingfisher для production
        loadImageWithURLSession(url: url)
    }
    
    private func loadImageWithURLSession(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.productImageView.image = UIImage(systemName: "photo")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }.resume()
    }
    
    // MARK: - Actions
    @objc private func likeButtonPressed() {
        likeButtonTappedHandler?(product)
    }
}
