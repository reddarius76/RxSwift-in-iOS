//
//  ViewController.swift
//  CameraFilter
//
//  Created by Oleg Krikun on 21.05.2021.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Camera Filter"
        navigationController?.navigationBar.prefersLargeTitles = true
        applyFilterButton.isHidden = true
    }
    
    @IBAction func applyFilterPressed(_ sender: UIButton) {
        guard let sourceImage = imageView.image else { return }

        FilterService.shared.applyFilter(to: sourceImage)
            .subscribe { [weak self] filtredImage in
                if let self = self {
                    DispatchQueue.main.async {
                        self.updateUI(with: filtredImage)
                    }
                }
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                print("onCompleted applyFilter")
            } onDisposed: {
                print("onDisposed applyFilter")
            }.disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        imageView.image = image
        applyFilterButton.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let photoCVC = navController.viewControllers.first as? PhotoCollectionViewController else {
            fatalError("Destination is not found!")
        }
        
        photoCVC.selectedPhoto.subscribe { [weak self] image in
            if let self = self {
                DispatchQueue.main.async {
                    self.updateUI(with: image)
                }
            }
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("onCompleted selectedPhoto")
        } onDisposed: {
            print("onDisposed selectedPhoto")
        }.disposed(by: disposeBag)

    }
}
