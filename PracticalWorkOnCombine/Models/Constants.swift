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
    
    let symbolsForStrings = ["AAAA AAA", "BBBBB BB BBB", "CCC", "DDDDD DD","E EE EEE ","FFF FF F","GGG GGG GGG"]
    let timeIntervalsForPublisherOfStrings: [TimeInterval] = [0.1, 0.3, 0.2, 0.2, 0.1, 0.3, 0.1]
    let timeIntervalsForPublisherOfCharacters: [TimeInterval] = [0.1, 0.5, 1.3, 0.7, 1.5, 0.4, 0.1]
    let emojiRange = [0x1F600, 0x1f601, 0x1f602, 0x1f603, 0x1f604, 0x1f605]
    let emojiRangeForCasino = [0x1F600, 0x1f601, 0x1f602, 0x1f603, 0x1f604, 0x1f606, 0x1f607, 0x1f608, 0x1f609, 0x1f610, 0x1f611, 0x1f612, 0x1f613, 0x1f614, 0x1f615]
    let rendezvousDate = "2022-02-15"
}
