//
//  PhoneNumberCodes.swift
//  PracticalWorkOnCombine
//
//  Created by Eduard on 05.02.2022.
//

import Foundation

class Constants {
    private init(){}
    static let shared = Constants()
    let phoneNumberCodes = [911, 912, 917, 919, 981, 982, 987, 988, 989, 904, 921, 922, 927, 929, 931, 932, 937, 939, 999, 900, 901, 902, 904, 908, 950, 951, 952, 953, 991, 992].map{String($0)}
    let firstNames = ["Олег ","Антон","Петр","Алексей","Игорь","Виталий","Сергей","Владислав", "Евгений"]
    let secondNames = ["Иванов","Петров","Сидоров","Алексеев","Виталиев","Быстрый","Медленный","Светлый", "Темный"]
}
