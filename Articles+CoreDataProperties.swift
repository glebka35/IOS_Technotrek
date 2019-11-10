//
//  Articles+CoreDataProperties.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 10/11/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//
//

import Foundation
import CoreData


extension Articles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Articles> {
        return NSFetchRequest<Articles>(entityName: "Articles")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var category: Categories?

}
