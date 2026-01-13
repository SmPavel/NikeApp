import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblSoldout: UILabel!
    @IBOutlet weak var lblBestseller: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var bFavourite: UIButton!
    
    private var productId: String?
    
    var product: Product? {
        didSet {
            guard let p = product else { return }
            productId = p.productIdentifier
            
            lblTitle.text = p.brand
            lblSubtitle.text = p.productName
            lblSoldout.isHidden = p.quantity > 0
            lblBestseller.isHidden = !p.isBestseller
            lblPrice.text = String(format: "$%.2f", p.price)
            
            let heartImage = p.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            bFavourite.setImage(heartImage, for: .normal)
            
            loadImage(from: p.imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bFavourite.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        bFavourite.tintColor = .red
    }
    
    @objc func favoriteTapped() {
        guard let id = productId else { return }
        
        ProductsManager.shared.toggleFavorite(for: id)
        
        if var p = product {
            p.isLiked.toggle()
            self.product = p
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.ivLogo.image = image
            }
        }.resume()
    }
}
