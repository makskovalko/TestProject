//
//  JsonLoader.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

protocol DataSourceLoader {
    init(fileName: String, type: String)
    
    func load<T: Decodable>() -> T?
    func loadArray<T: Decodable>() -> [T]
}

final class JSONLoader: DataSourceLoader {
    
    private let fileName: String
    private let type: String
    
    required init(fileName: String, type: String) {
        self.fileName = fileName
        self.type = type
    }
    
    func load<T: Decodable>() -> T? {
        guard let data = self.data,
            let json: T = decodeJSON(from: data) else { return nil }
        return json
    }
    
    func loadArray<T: Decodable>() -> [T] {
        guard let data = self.data,
            let json: [T] = decodeJSON(from: data) else { return [] }
        return json
    }
    
}

private extension JSONLoader {
    var path: String? {
        return Bundle.main.path(
            forResource: fileName,
            ofType: type
        )
    }
    
    var data: Data? {
        guard let path = self.path else { return nil }
        return try? Data(contentsOf: .init(fileURLWithPath: path))
    }
}

//MARK: - Decode JSON

private extension JSONLoader {
    func decodeJSON<T: Decodable>(from data: Data) -> T? {
        guard let json = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return json
    }
}
