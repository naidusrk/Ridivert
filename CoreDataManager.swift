 //
//  CoreDataManager.swift
//  Lists
//
//  Created by Bart Jacobs on 07/03/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import CoreData

final class CoreDataManager {

    // MARK: - Properties

    private let modelName: String

    // MARK: - Initialization

    init(modelName: String) {
        self.modelName = modelName
    }

    // MARK: - Core Data Stack

    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")
            else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
     func saveUserlocations(miles:Double,latitude:Double,longitude:Double,selectedDataDic:NSDictionary,pauseCount:Int,isCampaignRunning:Bool,campaignId:String)
    {
           let managedObjectContext = self.managedObjectContext
        // Create Entity Description
            let entityDescription = NSEntityDescription.entity(forEntityName: "Map", in: managedObjectContext)
        if let entityDescription = entityDescription {
            // Create Managed Object
            let list = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)

            list.setValue(latitude, forKey: "latitude")
            list.setValue(longitude, forKey: "longitude")
            list.setValue(selectedDataDic["name"], forKey: "name")
            list.setValue(miles, forKey: "miles")
            list.setValue(selectedDataDic["campaignId"], forKey: "campaignId")
            list.setValue(NSDate(), forKey: "timestamp")
            list.setValue(selectedDataDic["zipcode"], forKey: "zipcode")
            list.setValue(pauseCount, forKey: "pauseCount")
            list.setValue(isCampaignRunning, forKey: "isCampaignRunning")

            print(list)

            do {
                // Save Changes
                try managedObjectContext.save()

            } catch {
                // Error Handling
            }
            

        }

       // return result
        
    }
    
    
    
     func updateSelectedCampaign(miles:Double,latitude:Double,longitude:Double,selectedDataDic:NSDictionary,pauseCount:Int,isCampaignRunning:Bool,campaignId:String)
    {
    
     
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Map")
        let predicate = NSPredicate(format: "campaignId = %@",campaignId)
        fetchRequest.predicate = predicate
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
                
            }
            
            for location in result {
                location.setValue(latitude, forKey: "latitude")
                location.setValue(longitude, forKey: "longitude")
                location.setValue(selectedDataDic["name"], forKey: "name")
                location.setValue(miles, forKey: "miles")
                location.setValue(selectedDataDic["campaignId"], forKey: "campaignId")
                location.setValue(NSDate(), forKey: "timestamp")
                location.setValue(selectedDataDic["zipcode"], forKey: "zipcode")
                location.setValue(pauseCount, forKey: "pauseCount")
                location.setValue(isCampaignRunning, forKey: "isCampaignRunning")
                
                print("fetched values is \(location.value(forKey: "name")!)"  )
                do {
                    // Save Changes
                    try managedObjectContext.save()
                    
                } catch {
                    // Error Handling
                }
            }
            
        }
        catch {
            //  print("Unable to fetch managed objects for entity \(entity).")
        }
        
    }
    
    
    
     func fetchAllCampaigns(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            
            
            if let records = records as? [NSManagedObject] {
                result = records
                
            }
            
            for location in result {
                print("fetched values is \(location.value(forKey: "name")!)"  )
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    func fetchSelectedCampaign(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext,campaignId:String) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let predicate = NSPredicate(format: "campaignId = %@",campaignId)
        fetchRequest.predicate = predicate
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
            for location in result {
                print("fetched values is \(location.value(forKey: "name")!)"  )
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }

        return result
    }
    
    func cancelSelectedCampaign(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext,campaignId:String) -> [NSManagedObject] {
        // Create Fetch Request
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let predicate = NSPredicate(format: "campaignId = %@",campaignId)
        fetchRequest.predicate = predicate
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
                
            }
            
            for location in result {
                location.setValue(false, forKey: "isCampaignRunning")
                print("fetched values is \(location.value(forKey: "name")!)"  )
                do {
                    // Save Changes
                    try managedObjectContext.save()
                    
                } catch {
                    // Error Handling
                }
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    

}
