//
//  APIKey.swift
//  AutoBOT
//
//  Created by Ashutosh Anand on 12/07/24.
//

import Foundation

enum APIKey{
    //Fetch API Key from 'GenerativeAi-info.plist'
    
    static var `default`: String{
        guard let filePath = Bundle.main.path(forResource: "GenerativeAi-Info", ofType: "plist")
        else{
            fatalError(" Couldn't find the file 'GenerativeAI-info-plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else{
            fatalError(" Couldn't find the file 'GenerativeAI-info-plist'.")
        }
        if value.starts(with: "_"){
            fatalError(
                "Follow the instructions at ai.google.dev/tutorial/setup to get an API Key."
            )
        }
        return value
    }
}
