//
//  ViewController.swift
//  ErrorParse
//
//  Created by Viktor Olesenko on 07.03.17.
//  Copyright © 2017 Viktor Olesenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let error = ["Key" : "Value"]
        
        let errorData = try! JSONSerialization.data(withJSONObject: error, options: [])
        let parsedError = APIErrorParser.parse(errorData)
        print("Parsed: \(parsedError.error.localizedDescription)")
    }
}

