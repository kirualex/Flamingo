//
//  Source.swift
//  Flamingo
//
//  Created by Alexis Creuzot on 07/06/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import Foundation
import RealmSwift

class Source : Object , Codable{
    
    @objc dynamic var domain : String = ""
    
    convenience init(domain: String) {
        self.init()
        self.domain = domain
    }
 
    func allow() {
        var blacklist = UserDefaults.standard.unallowedDomains
        if let index = blacklist.index(of: self.domain){
            blacklist.remove(at: index)
        }
        UserDefaults.standard.unallowedDomains = blacklist
    }
    
    func block() {
        var blacklist = UserDefaults.standard.unallowedDomains
        if !blacklist.contains(self.domain) {
            blacklist.append(self.domain)
        }
        UserDefaults.standard.unallowedDomains = blacklist
    }
    
    override static func primaryKey() -> String? {
        return "domain"
    }
    
    func toDict() -> [String : String] {
        return ["domain" : domain]
    }
    
    func toJSON() -> String {
        let dict = self.toDict()
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return ""
        }
    }
    
}

class Sources {
    static func toJSON() -> String {
        if  let sources = try? Array(Realm().objects(Source.self)),
            let jsonData = try? JSONSerialization.data(withJSONObject: sources.map {$0.toDict()}, options: [.prettyPrinted]),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return ""
        }
    }
}