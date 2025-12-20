import UIKit

// MARK: - Модели данных
struct FirstShopItem {
    let imageName: String
    let text: String
}

struct SecondShopItem {
    let imageName: String
    let text: String
}

// MARK: - Ячейки
class FirstShopCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UITextView!
}

class SecondShopCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UITextView!
}

// MARK: - ViewController
class ShopViewController: UIViewController {
    
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    let firstItems = [
        FirstShopItem(imageName: "0cfdee7b0e7e0d09887af6e3ad0d36fe437164d6", text: "Best Sellers"),
        FirstShopItem(imageName: "d04afce40d1dc42548cbfbcee1edfe898ef42f80", text: "Featured in Nike Air")
    ]
    
    let secondItems = [
        SecondShopItem(imageName: "Runner", text: "New & Featured"),
        SecondShopItem(imageName: "Runner", text: "Shoes")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCollectionView.dataSource = self
        firstCollectionView.delegate = self
        
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case firstCollectionView:
            return firstItems.count
        case secondCollectionView:
            return secondItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case firstCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstShopCell", for: indexPath) as! FirstShopCell
            let item = firstItems[indexPath.row]
            cell.imageView.image = UIImage(named: item.imageName)
            cell.name.text = item.text
            return cell
            
        case secondCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondShopCell", for: indexPath) as! SecondShopCell
            let item = secondItems[indexPath.row]
            cell.imageView.image = UIImage(named: item.imageName)
            cell.name.text = item.text
            return cell
            
        default:
            fatalError("Unknown collection view")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case firstCollectionView:
            return CGSize(width: 220, height: 280)
        case secondCollectionView:
            return CGSize(width: 390, height: 111) // другой размер
        default:
            return CGSize(width: 100, height: 100)
        }
    }
}
