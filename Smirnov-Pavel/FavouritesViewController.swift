import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    private var favoriteProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupNotifications()
        updateEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoritesList()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavoritesList),
            name: NSNotification.Name("FavoritesUpdated"),
            object: nil
        )
    }
    
    @objc private func updateFavoritesList() {
        favoriteProducts = ProductsManager.shared.getFavorites()
        updateEmptyState()
        
        // Плавное обновление
        UIView.transition(with: collectionView,
                         duration: 0.3,
                         options: .transitionCrossDissolve,
                         animations: {
                            self.collectionView.reloadData()
                         })
    }
    
    private func updateEmptyState() {
        if favoriteProducts.isEmpty {
            // Создаем сообщение при пустой коллекции
            let messageLabel = UILabel()
            messageLabel.text = "Нет избранных товаров"
            messageLabel.textAlignment = .center
            messageLabel.textColor = .gray
            messageLabel.font = UIFont.systemFont(ofSize: 18)
            messageLabel.frame = collectionView.bounds
            collectionView.backgroundView = messageLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "productCell",
            for: indexPath
        ) as? ProductCollectionViewCell else {
            fatalError("Не удалось создать ячейку ProductCollectionViewCell")
        }
        cell.product = favoriteProducts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.1
        return CGSize(width: width, height: width * 1.9354)
    }
}
