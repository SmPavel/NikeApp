import Foundation

class ProductsManager {
    static let shared = ProductsManager()
    
    private var allProducts: [Product] = []
    private let favoritesKey = "favoriteProducts"
    
    private init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        // Позже загрузим сохраненные избранные
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            let error = NSError(
                domain: "ProductsManager",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Файл products.json не найден"]
            )
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                var products = try decoder.decode([Product].self, from: data)
                
                // Восстанавливаем сохраненные состояния избранного
                let savedFavorites = UserDefaults.standard.array(forKey: self.favoritesKey) as? [String] ?? []
                for i in 0..<products.count {
                    if savedFavorites.contains(products[i].productIdentifier) {
                        products[i].isLiked = true
                    }
                }
                
                self.allProducts = products
                
                DispatchQueue.main.async {
                    completion(.success(products))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveFavoriteState() {
        let favoriteIdentifiers = allProducts
            .filter { $0.isLiked }
            .map { $0.productIdentifier }
        UserDefaults.standard.set(favoriteIdentifiers, forKey: favoritesKey)
    }
    
    func getFavorites() -> [Product] {
        return allProducts.filter { $0.isLiked }
    }
    
    func toggleFavorite(for productIdentifier: String) {
        if let index = allProducts.firstIndex(where: { $0.productIdentifier == productIdentifier }) {
            allProducts[index].isLiked.toggle()
            
            // Сохраняем состояние
            saveFavoriteState()
            
            // Отправляем уведомление
            NotificationCenter.default.post(
                name: NSNotification.Name("FavoritesUpdated"),
                object: nil,
                userInfo: ["productIdentifier": productIdentifier]
            )
        }
    }
    
    func isFavorite(productIdentifier: String) -> Bool {
        return allProducts.first(where: { $0.productIdentifier == productIdentifier })?.isLiked ?? false
    }
    
    func getAllProducts() -> [Product] {
        return allProducts
    }
}
