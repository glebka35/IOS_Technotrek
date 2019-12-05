//
//  UserDataSaver.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 05/12/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import Foundation

protocol GUUserDataManager {
    func saveWithNSO()
    func saveWithGCD()
}
