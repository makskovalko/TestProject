//
//  CidyData.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

struct CityData: Codable {
    struct Coordinate: Codable {
        let lon: Double
        let lat: Double
    }
    
    let _id: Int
    let country: String
    let name: String
    let coord: Coordinate
    
    var description: String {
        return name + ", " + country
    }
}
