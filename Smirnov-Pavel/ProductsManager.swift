import Foundation

class ProductsManager {
    static let shared = ProductsManager()
    private var products: [Product] = []
    
    func fetchProducts(completion: @escaping ([Product]) -> Void) {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            completion([])
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                var products = try JSONDecoder().decode([Product].self, from: data)
                
                let savedLikes = self.loadSavedLikes()
                
                for i in 0..<products.count {
                    let id = products[i].productIdentifier
                    if savedLikes[id] != nil {
                        products[i].isLiked = savedLikes[id]!
                    }
                }
                
                self.products = products
                
                DispatchQueue.main.async {
                    completion(products)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func toggleFavorite(for productId: String) {
        if let index = products.firstIndex(where: { $0.productIdentifier == productId }) {
            products[index].isLiked.toggle()
            
            saveLike(for: productId, isLiked: products[index].isLiked)
            
            NotificationCenter.default.post(name: Notification.Name("FavoritesChanged"), object: nil)
        }
    }
    
    private func saveLike(for productId: String, isLiked: Bool) {
        var savedLikes = loadSavedLikes()
        savedLikes[productId] = isLiked
        UserDefaults.standard.set(savedLikes, forKey: "ProductLikes")
    }
    
    private func loadSavedLikes() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: "ProductLikes") as? [String: Bool] ?? [:]
    }
    
    func getFavorites() -> [Product] {
        return products.filter { $0.isLiked }
    }
    
    func getAllProducts() -> [Product] {
        return products
    }
}
