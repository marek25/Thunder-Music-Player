//
//  CoreData.swift
//  Thunder Music Player
//
//  Created by OSX on 3/12/19.
//  Copyright © 2019 AppDoctor. All rights reserved.
//

import Foundation
import CoreData
import UIKit



struct CoreDataLogic {
    
    
    
    
    
    var coreDataResult = [SongsObject]()
    
    var songsList = [Songs]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    func createData(nameFromLabel: String?, urlFromLabel: String?){
        print("TO WRITE DATA TO CORE DATA")
        
        
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let SongsEntity = NSEntityDescription.entity(forEntityName: "Songs", in: managedContext)!
        
        guard let nameFromLabel = nameFromLabel else {return}
        guard let urlFromLabel = urlFromLabel else {return}
        
            let user = NSManagedObject(entity: SongsEntity, insertInto: managedContext)
            
            user.setValue("name: \(nameFromLabel) ", forKey: "name")
            user.setValue("url: \(urlFromLabel) ", forKey: "url")
            
   
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    
    
    mutating func retreiveData() -> [SongsObject]? {
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        
        var listOfSongs = [SongsObject]()
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "url") as! String)
                
//                guard let name : String = data.value(forKey: "name") as? String else {return}
//                guard let url : String = data.value(forKey: "url") as? String else {return}
                
                if let name : String = data.value(forKey: "name") as? String,
                   let url : String = data.value(forKey: "url") as? String  {
                    
                        coreDataResult.append(SongsObject(name: name, url: url))

                        listOfSongs.append(SongsObject(name: name, url: url))

                }
                
            }
            
        } catch {
            print("Failed")
        }
        
        return listOfSongs
    }
    
    
    
    mutating func goodFetch() {
        
        let fetchRequest:NSFetchRequest<Songs> = Songs.fetchRequest()
        do{
            songsList = try context.fetch(fetchRequest)
//            tvNotesList.reloadData()
            print("objekti iz core date \(songsList)")
        }catch{
            print("Can not read from the database")
        }
        
    }
    
    func updateData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Songs")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Ankur1")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "name")
            objectUpdate.setValue("newURL", forKey: "url")
            
            do {
                try managedContext.save()
            }catch {
                print(error)
            }
            
        }catch {
            print(error)
            
        }
        
    }
    
    
    func deleteData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Ankur3")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
                
            } catch {
                
                print(error)
            }
            
        }catch {
            print(error)
            
            
        }
        
        
    }
    
    
    
}
