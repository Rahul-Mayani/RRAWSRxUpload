//
//  RRAWSstruct.swift
//  RRAWSRxUpload
//
//  Created by Rahul Mayani on 20/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

enum AWSImageType {
    case image1
    case image2
    
    var title: String {
        switch self {
        case .image1:
            return "image1"
        case .image2:
            return "image2"
        }
    }
}

enum StatusCode: Int {
    case ok = 200
    case create = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case noFound = 404
    case methodNotAllow = 405
    case conflict = 409
    case serverError = 500
    case unavailable = 503
    case requestTimeout = 408
    case noInternetConnection = -1009
}


public struct AWSImageData {
    var type: AWSImageType
    var image: UIImage
}

public struct AWSImageKey {
    var type: AWSImageType
    var key: String
}

public struct AppNetworkReachability {
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
