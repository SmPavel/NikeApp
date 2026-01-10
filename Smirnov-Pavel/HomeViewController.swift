import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadProducts()
        setupNotifications()
    }
    
    private func loadProducts() {
        ProductsManager.shared.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.collectionView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(error: error)
            }
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesUpdate),
            name: NSNotification.Name("FavoritesUpdated"),
            object: nil
        )
    }
    
    @objc private func handleFavoritesUpdate(notification: Notification) {
        // Просто перезагружаем все данные
        collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка загрузки",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "productCell",
            for: indexPath
        ) as? ProductCollectionViewCell else {
            fatalError("Не удалось создать ячейку ProductCollectionViewCell")
        }
        cell.product = products[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2.1
        return CGSize(width: width, height: width * 1.9354)
    }
}
