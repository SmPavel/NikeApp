import Foundation

class ProductsManager {
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        // Проверяем, какие файлы есть в бандле
        print("=== Начинаем загрузку продуктов ===")
        
        // Список всех файлов в бандле
        if let urls = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            print("Найдены JSON файлы в бандле:")
            for url in urls {
                print("- \(url.lastPathComponent)")
            }
        } else {
            print("JSON файлы не найдены в бандле")
        }
        
        // Пытаемся найти файл products.json
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            print("❌ ОШИБКА: Файл products.json не найден")
            
            // Выводим путь к бандлю для отладки
            print("Путь к бандлю: \(Bundle.main.bundlePath)")
            
            // Проверяем содержимое бандля
            if let contents = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.bundlePath) {
                print("Содержимое бандля:")
                for item in contents.sorted() {
                    print("- \(item)")
                }
            }
            
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
        
        print("✅ Файл найден: \(url.path)")
        
        // Проверяем размер файла
        if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
           let fileSize = attributes[.size] as? UInt64 {
            print("Размер файла: \(fileSize) байт")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Читаем данные
                let data = try Data(contentsOf: url)
                print("✅ Данные прочитаны: \(data.count) байт")
                
                // Пробуем вывести содержимое как строку для проверки
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Первые 500 символов JSON:")
                    let preview = jsonString.prefix(500)
                    print(String(preview))
                    
                    if jsonString.count > 500 {
                        print("... (еще \(jsonString.count - 500) символов)")
                    }
                }
                
                // Декодируем
                let decoder = JSONDecoder()
                let products = try decoder.decode([Product].self, from: data)
                
                print("✅ Успешно декодировано \(products.count) продуктов")
                if products.count > 0 {
                    print("Первый продукт: \(products[0].brand) - \(products[0].productName)")
                }
                
                DispatchQueue.main.async {
                    completion(.success(products))
                }
                
            } catch let decodingError as DecodingError {
                print("❌ Ошибка декодирования: \(decodingError)")
                
                // Детальная информация об ошибке декодирования
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Данные повреждены: \(context)")
                case .keyNotFound(let key, let context):
                    print("Ключ '\(key)' не найден: \(context)")
                case .typeMismatch(let type, let context):
                    print("Несоответствие типа '\(type)': \(context)")
                case .valueNotFound(let type, let context):
                    print("Значение '\(type)' не найдено: \(context)")
                @unknown default:
                    print("Неизвестная ошибка декодирования")
                }
                
                DispatchQueue.main.async {
                    completion(.failure(decodingError))
                }
                
            } catch {
                print("❌ Другая ошибка: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
