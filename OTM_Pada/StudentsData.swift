//
//  StudentsData.swift
//  OTM_Pada
//
//  Created by Brenna Pada on 9/14/22.
//

import Foundation

// from my first project submission feedback and with help from https://knowledge.udacity.com/questions/900468
class StudentsData: NSObject {
    
    var students = [Locations]()
    
    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }
}

