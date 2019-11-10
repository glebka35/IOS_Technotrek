//
//  Categories+CoreDataProperties.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 10/11/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var name: String?
    @NSManaged public var article: NSSet?

}

// MARK: Generated accessors for article
extension Categories {

    @objc(addArticleObject:)
    @NSManaged public func addToArticle(_ value: Articles)

    @objc(removeArticleObject:)
    @NSManaged public func removeFromArticle(_ value: Articles)

    @objc(addArticle:)
    @NSManaged public func addToArticle(_ values: NSSet)

    @objc(removeArticle:)
    @NSManaged public func removeFromArticle(_ values: NSSet)

}
