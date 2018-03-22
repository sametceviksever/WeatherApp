//
//  CoreData.swift
//  WeatherApp
//
//  Created by Samet Çeviksever on 22.03.2018.
//  Copyright © 2018 Samet Çeviksever. All rights reserved.
//

import Foundation
import CoreData

struct CoreCity {
    var cityName:String
    var uuid:String
}

class CoreData {
    static var shared:CoreData = CoreData()
    
    func getCityData() -> [CoreCity]{
        var cities = [CoreCity]()
        for item in getCities(){
            if let name = item.value(forKey: "cityName") as? String,
                let uuid = item.value(forKey: "id") as? String{
                let city = CoreCity(cityName: name, uuid: uuid)
                cities.append(city)
            }
        }
        return cities
    }
    
    func getCities(uuid:String? = nil) -> [NSManagedObject]{
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        if uuid != nil{
            request.predicate = NSPredicate(format: "id = %@", uuid!)
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if let items = result as? [NSManagedObject]{
                return items.sorted(by: { (lhs, rhs) -> Bool in
                    if let lhsDate = lhs.value(forKey: "lastUseDate") as? Date,
                        let rhsDate = rhs.value(forKey: "lastUseDate") as? Date{
                        return lhsDate > rhsDate
                    }
                    return false
                })
            } else {
                return [NSManagedObject]()
            }
        } catch {
            return [NSManagedObject]()
        }
    }
    
    func saveCity(cityName:String) -> CoreCity?{
        let context = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)
        let newCity = NSManagedObject(entity: entity!, insertInto: context)
        let uuid = UUID().uuidString
        newCity.setValue(uuid, forKey: "id")
        newCity.setValue(cityName, forKey: "cityName")
        newCity.setValue(Date(), forKey: "lastUseDate")
        
        do{
            try context.save()
            return CoreCity(cityName: cityName, uuid: uuid)
        } catch {
            print("Failed saving")
            return nil
        }
        
    }
    
    func updateCity(uuid:String,cityName:String){
        let result = getCities(uuid: uuid)
        for data in result {
            data.setValue(Date(), forKey: "lastUseDate")
        }
    }
    
    
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { }
        })
        return container
    }()
}
