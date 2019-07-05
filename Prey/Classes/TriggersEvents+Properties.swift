//
//  TriggersEvents+CoreDataProperties.swift
//  Prey
//
//  Created by Javier Cala Uribe on 4/7/19.
//  Copyright © 2019 Fork Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension TriggersEvents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TriggersEvents> {
        return NSFetchRequest<TriggersEvents>(entityName: "TriggersEvents")
    }

    @NSManaged public var type: String?
    @NSManaged public var info: String?

}
