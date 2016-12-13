//
//  User.swift
//  fienlute-pset6
//
//  Created by Fien Lute on 13-12-16.
//  Copyright © 2016 Fien Lute. All rights reserved.
//

import Foundation
import Firebase 

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
