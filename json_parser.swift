import Foundation

struct User: Codable {
    let name: String
    let age: Int
}

let json = """
[
    {"name": "Alice", "age": 25},
    {"name": "Bob", "age": 30}
]
""".data(using: .utf8)!

do {
    let users = try JSONDecoder().decode([User].self, from: json)
    for u in users {
        print("Name: \(u.name), Age: \(u.age)")
    }
} catch {
    print("Error decoding JSON: \(error)")
}

