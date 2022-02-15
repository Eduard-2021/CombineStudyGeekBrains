//
//  PracticalTask#4.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 13.02.2022.
//

import UIKit
import Combine
import Kingfisher

class PracticalTaskNumber_4: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var earthUIImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let apiClient = APIClient()
    var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    func start(){
        apiClient.feed()
            .print("****PUBLISHER****")
            .sink(receiveCompletion: {_ in
                print("\n\nДанные с сайта NASA получены успешно и обработаны\n\n")
            },
                  receiveValue: {
                print("\nВозле земли 13.02.22 пролетело \($0.elementCount) астероидов")
                print("Первый из них:")
                print("Имеет официальное название: ", $0.nearEarthObjects.rendezvousDate[0].name)
                print("Его приблизительный минимальный диаметр в метрах: ", $0.nearEarthObjects.rendezvousDate[0].estimatedDiameter.meters.estimatedDiameterMin)
                print("Приблизительный максимальный диаметр в метрах: ", $0.nearEarthObjects.rendezvousDate[0].estimatedDiameter.meters.estimatedDiameterMax)
                print("Опасен ли он для Земли: ", $0.nearEarthObjects.rendezvousDate[0].isPotentiallyHazardousAsteroid ? "Да" : "Нет")
                print("Скорость астероида в километрах в секунду: ", $0.nearEarthObjects.rendezvousDate[0].otherSpecifications[0].relativeVelocity.kilometersPerSecond)
                print("Минимальное расстояние от астероида до Земли в километрах: ", $0.nearEarthObjects.rendezvousDate[0].otherSpecifications[0].missDistance.kilometers)
                print("Движется ли астероид по циклицеской орбите (можно ли ожидать его возвращение) : ", $0.nearEarthObjects.rendezvousDate[0].isSentryObject ? "Да" : "Нет")
            })
            .store(in: &subscriptions)
        
        apiClient.apod()
            .handleEvents(receiveSubscription: { _ in
                print("###### Network request will start ######")
            }, receiveOutput: { _ in
                print("###### Network request data received ######")
            }, receiveCancel: {
                print("###### Network request cancelled ######")
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {value in
                DispatchQueue.main.async {
                    self.earthUIImage.kf.setImage(with: URL(string: value.url))
                    self.titleLabel.text = value.title
                    self.dateLabel.text = value.date
                }
                print()
                print(value.explanation)
            })
            .store(in: &subscriptions)
    }
}

