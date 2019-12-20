//
//  ViewController.swift
//  RRAWSRxUpload
//
//  Created by Rahul Mayani on 20/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let rxbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Multiple image uploading
        RRAWSRxUpload.upload(dataList: [AWSImageData(type: .image1, image: #imageLiteral(resourceName: "chekbox")), AWSImageData(type: .image2, image: #imageLiteral(resourceName: "l_star_h"))])
        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: rxbag)
        
        // single image uploading
        RRAWSRxUpload.upload(data: AWSImageData(type: .image1, image: #imageLiteral(resourceName: "chekbox")))
        .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: rxbag)
    }
}


extension UIImage {
    
    func reduceImageFileSize() -> Data {
        
        var compression = 0.9
        let maxCompression = 0.1
        let maxFileSize = 500*1024
        
        var data = self.jpegData(compressionQuality: CGFloat(compression))!
        
        while (data.count > maxFileSize) && (compression > maxCompression) {
            
            compression -= 0.1
            data = self.jpegData(compressionQuality: CGFloat(compression))!
        }
        
        return data
    }
}
