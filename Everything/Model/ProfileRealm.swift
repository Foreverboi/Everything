//
//  ProfileRealm.swift
//  Everything
//
//  Created by Fuxin Bi on 1/2/2023.
//

import Foundation
import RealmSwift

class ProfileRealm: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var email: String?
    @Persisted var profilePic: String?

    
    required override init() {
        super.init()
    }
    init(_id: String, email: String? = nil, profilePic: String? = nil) {
        super.init()
        self._id = _id
   
        self.email = email
        self.profilePic = profilePic
    }
}
