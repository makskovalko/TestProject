//
//  Queue Sugar.swift
//  TestProject
//
//  Created by Maxim Kovalko on 6/24/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

func execute(on queue: DispatchQueue, _ callback: @escaping () -> ()) {
    queue.async { callback() }
}
