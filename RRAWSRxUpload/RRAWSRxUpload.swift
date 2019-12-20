//
//  RRAWSRxUpload.swift
//  RRAWSRxUpload
//
//  Created by Rahul Mayani on 20/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
import RxCocoa
import RxSwift


#warning("Add your AWSS3 bucket name and poolId")
public struct AWSBucket {
    static let bucketName   = ""
    static let contentType  = "image/jpeg"
    static let poolId       = ""
}

public struct RRAWSRxUpload: ObservableType {

    public typealias Element = AWSImageKey
       
    var data: AWSImageData
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, RRAWSRxUpload.Element == Observer.Element {
        
        if !AppNetworkReachability.isInternetAvailable() {
            let errorTemp = NSError(domain:"", code: StatusCode.noInternetConnection.rawValue, userInfo:nil)
            observer.onError(errorTemp)
        }
        
        let data = self.data.image.reduceImageFileSize()
        let key = self.data.type.title + "_\(Int(Date().timeIntervalSince1970)).jpeg"
        
        var uploadTask : AWSS3TransferUtilityUploadTask?
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl")
        
        let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                uploadTask = task
                if let error = error {
                    observer.onError(error)
                }else{
                    observer.onNext(AWSImageKey(type: self.data.type, key: key))
                    observer.onCompleted()
                }
            })
        }
        
        AWSS3TransferUtility.default().uploadData(data, bucket: AWSBucket.bucketName, key: key, contentType: AWSBucket.contentType, expression: expression, completionHandler: completionHandler)
        
        return Disposables.create { uploadTask?.cancel() }
    }
    
    public static func upload(data: AWSImageData) -> Observable<Element> {
        return Observable.deferred {
            return RRAWSRxUpload.init(data: data).asObservable()
        }
    }

    public static func upload(dataList: [AWSImageData]) -> Observable<[Element]> {
        return Observable.deferred {
            return Observable.from(dataList).flatMap { (data) -> Observable<Element> in
                return RRAWSRxUpload.init(data: data).asObservable()
            }
        }.toArray().asObservable()
    }
}


// MARK: - Setup AWSS3
extension AppDelegate {
    
    func setupAWSCredentials() {
        #warning("Set AWS server region and bucket region type")
        //Setup credentials
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .APSouth1, identityPoolId: AWSBucket.poolId)
        
        //Setup the service configuration
        let configuration = AWSServiceConfiguration(region: .APSouth1, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
}



