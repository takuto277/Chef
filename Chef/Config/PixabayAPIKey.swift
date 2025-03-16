//
//  PixabayAPIKey.swift
//  Chef
//
//  Created by 小野拓人 on 2025/03/16.
//

import Foundation

enum PixabayAPIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Pixabay_API_KEY") as? String else {
            fatalError("Couldn't find key 'Pixabay_API_KEY' in 'Info.plist'.")
        }
        if value.starts(with: "_") {
            fatalError(
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
}
