//
//  PeopleList.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 23.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import Foundation

struct PeopleList: Codable {
    var items: [Human]?
    var page: Page?
}

struct Human: Codable, Equatable{
    var position: String?
    var id: String?
    var lastname: String?
    var placeOfWork: String?
    var firstname: String?
    var linkPDF: String?
    var comment: String?
    
    static public func ==(lhs: Human, rhs: Human) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Page: Codable {
    var batchSize: Int?
    var totalItems: String?
    var currentPage: Int?
}
