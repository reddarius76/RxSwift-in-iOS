//
//  FilterService.swift
//  CameraFilter
//
//  Created by Oleg Krikun on 21.05.2021.
//

import UIKit
import CoreImage
import RxSwift

final class FilterService {
    
    static let shared = FilterService()
    
    private var context = CIContext()
    
    func applyFilter(to image: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { [weak self] observer in
            print("1")
            if let self = self {
                print("2")
                self.filter(to: image) { filtredImage in
                    print("3")
                    observer.onNext(filtredImage)
                    print("4")
                }
            }
            print("5")
            return Disposables.create()
        }
    }
    
    private func filter(to image: UIImage, completion: @escaping (UIImage) -> Void) {
        guard let filter = CIFilter(name: "CICMYKHalftone") else { return }
        
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: image) {
            filter.setValue(sourceImage, forKey:  kCIInputImageKey)
            
            guard let outputImage = filter.outputImage else { return }
            guard let outputImageExtent = filter.outputImage?.extent else { return }
            
            if let cgImage = context.createCGImage(outputImage, from: outputImageExtent) {
                let processedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
                completion(processedImage)
            }
        }
    }
    
    private init() {}
}
