import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadData),
            name: Notification.Name("FavoritesChanged"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @objc func loadData() {
        ProductsManager.shared.fetchProducts { products in
            self.products = products
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        cell.product = products[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.1
        return CGSize(width: width, height: width * 1.9354)
    }
}
