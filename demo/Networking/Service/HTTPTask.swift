//
//  HTTPTask.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/15.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
