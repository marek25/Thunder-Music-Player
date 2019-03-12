//
//  CoreDataTester.swift
//  Thunder Music Player
//
//  Created by OSX on 3/12/19.
//  Copyright © 2019 AppDoctor. All rights reserved.
//

import Foundation
import CoreData
import UIKit


struct DataTester {
    
    let coreDataL = CoreDataLogic()
    
    
    func coreDataResultsPrinter () {
        
        print("------------------------")
        
       
        print("results from NSOBJECT: \(coreDataL.coreDataResult.count)")
        
    }
    
}
