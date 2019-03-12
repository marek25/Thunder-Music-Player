//
//  SongsObject.swift
//  Thunder Music Player
//
//  Created by OSX on 3/12/19.
//  Copyright © 2019 AppDoctor. All rights reserved.
//

import UIKit

class SongsObject: NSObject {

    var name : String
    var url : String
        init(name : String, url : String) {
            self.name=name
            self.url=url
        }
    
    
    deinit {
        print("Songs object deinitialized")
    }
    
}
