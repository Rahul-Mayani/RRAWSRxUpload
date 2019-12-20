# RRAWSRxUpload
Multiple image uploading on AWS S3 server by RxSwift

## Requirements

pod 'RxCocoa'

pod 'RxSwift'

pod 'AWSS3'

## Installation

#### Manually
1. Download and drop ```RRAWSRxUpload.swift & RRAWSstruct.swift``` in your project.
2. Add your AWS S3 account poolId, bucket name and region type in your project.
3. Congratulations!  

## Usage example
To run the example project, clone the repo, and run pod install from the Example directory first.


```swift

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

```

## Contribute

We would love you for the contribution to **RRAWSRxUpload**, check the ``LICENSE`` file for more info.


## License

RRAWSRxUpload is available under the MIT license. See the LICENSE file for more info.
