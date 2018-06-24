//
//  SearchRouter.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

final class SearchRouter<SearchView> {
    func showMapView(presentationContext: SearchView, data: CityData) {
        guard let mapViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "mapViewController")
            as? MapViewController else { return }
        
        mapViewController.coordinate = data.coord
        
        (presentationContext as? UIViewController)?
            .navigationController?
            .pushViewController(mapViewController, animated: true)
    }
}
