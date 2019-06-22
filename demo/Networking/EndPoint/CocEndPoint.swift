//
//  EndPointType.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/16.
//  Copyright © 2019 Chun yu Tung. All rights reserved.


import Foundation

enum NetworkEnvironment {
    case demo
}


public enum CocApi {
    case player(tag: String)
}

extension CocApi: EndPointType {

    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .demo:
            return "http://122.116.128.12:5000/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }

    
    var path: String {
        switch self {
            case .player(let tag):
            return "player/\(tag)"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        switch self {
        default:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

