//
//  ViewController.swift
//  WeatherRX
//
//  Created by Oleg Krikun on 24.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { [weak self] in
                self?.cityTextField.text
            }
            .subscribe(onNext: { [weak self] city in
                if let self = self,
                   let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: {
                print("onCompleted cityTextField")
            }, onDisposed: {
                print("onDisposed cityTextField")
            }).disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            temperatureLabel.text = "\(weather.temp) ℃"
            humidityLabel.text = "\(weather.humidity) %"
        } else {
            temperatureLabel.text = "🙊"
            humidityLabel.text = "⭐️"
        }
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForOpenWeatherAPI(city: cityEncoded) else { return }
        
        let resource = Resource<WeatherResult>(url: url)

        let search = URLRequest.load(resource: resource)
            .retry(3)
            .observe(on: MainScheduler.instance)
            .catch { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
            
        search.map { "Temperature: \($0.main.temp) ℃" }
            .drive(temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "Humidity: \($0.main.humidity) %" }
            .drive( humidityLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

