import UIKit
class HomeViewController: UIViewController {
    
    let productsManager: ProductsManager = ProductsManager()
    @IBOutlet var collectionView: UICollectionView!
    private var products: [Product] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
        self.productsManager.fetchProducts { result in
                   switch result {
                   case .success(let products):
                       print("✅ В HomeViewController получено \(products.count) продуктов")
                       self.products = products
                       self.collectionView.reloadData()
                       
                       // Дополнительная проверка
                       for (index, product) in products.prefix(3).enumerated() {
                           print("Продукт \(index + 1): \(product.brand) - \(product.productName)")
                       }
                       
                   case .failure(let error):
                       print("❌ Ошибка в HomeViewController: \(error.localizedDescription)")
                       self.showErrorAlert(error: error)
                   }
               }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
            cell.product = self.products[indexPath.item]
            return cell
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.size.width / 2.0
            return CGSize(width: width, height: width * 1.9354)
        }
    }
    
    extension HomeViewController: UICollectionViewDelegate {
        
    }
