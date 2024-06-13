//
//  TumbleUser.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-01.
//

import Foundation

class TumbleUser: Decodable, Encodable {
    var username: String
    var name: String
    var school: School
    
    init(username: String, name: String, school: School) {
        self.username = username
        self.name = name
        self.school = school
    }
}
