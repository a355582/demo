//
//  ParameterEncoding.swift
//  demo
//
//  Created by Chun yu Tung on 2019/5/15.
//  Copyright © 2019 Chun yu Tung. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter encoding failed"
    case missingURL = "URL is nil"
}
