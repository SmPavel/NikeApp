// NetworkService.swift
import Foundation

class NetworkService {
    static func loadProducts(completion: @escaping ([Product]?) -> Void) {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            print("JSON file not found")
            completion(nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let products = try JSONDecoder().decode([Product].self, from: data)
            completion(products)
        } catch {
            print("Error loading products: \(error)")
            completion(nil)
        }
    }
    
    // Для загрузки из URL (если нужно загружать с сервера)
    static func loadProductsFromURL(urlString: String, completion: @escaping ([Product]?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    completion(products)
                }
            } catch {
                print("Error decoding: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
