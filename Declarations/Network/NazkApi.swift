//
//  NazkApi.swift
//  Declarations
//
//  Created by Yaroslava Hlibochko on 23.12.2019.
//  Copyright © 2019 Yaroslava Hlibochko. All rights reserved.
//

import Foundation
import Moya

enum NazkApi {
    case peoplesList(String, Int)
}

extension NazkApi: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://public-api.nazk.gov.ua/v1/declaration/")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .peoplesList(let query, let page):
            let parametrs = ["q" : query, "page" : page] as [String : Any]
            return .requestParameters(parameters: parametrs, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    public var validationType: ValidationType {
      return .successCodes
    }
}
