import UIKit
import Foundation

struct Item: Codable {
    var id: Int
    var value: String
}

func fetchData() async throws -> Item {
    let url = URL(string: "http://10.55.200.152:9000/data2.json")!
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let item = try JSONDecoder().decode(Item.self, from: data)
    return item
    
}

func uploadData(item: Item) async throws {
    let url = URL(string: "http://localhost:9000/upload")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let jsonData = try JSONEncoder().encode(item)
    request.httpBody = jsonData
    
    let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        throw URLError(URLError.Code.badServerResponse)
    }
}

Task {
    do {
        let uploadItem = Item(id: 2, value: "test2")
        try await uploadData(item: uploadItem)
        
        let item = try await fetchData()
        print(item)
    } catch {
        print("Error: \(error)")
    }
}
