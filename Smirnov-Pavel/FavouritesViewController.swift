import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var favorites: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadFavorites),
            name: Notification.Name("FavoritesChanged"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    @objc func loadFavorites() {
        // Убедитесь что данные загружены в ProductsManager
        favorites = ProductsManager.shared.getFavorites()
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        
        // Убедитесь что product устанавливается
        let product = favorites[indexPath.item]
        cell.product = product
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.1
        return CGSize(width: width, height: width * 1.9354)
    }
}
