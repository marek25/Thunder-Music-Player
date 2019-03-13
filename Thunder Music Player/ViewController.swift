//
//  ViewController.swift
//  Thunder Music Player
//
//  Created by OSX on 3/12/19.
//  Copyright © 2019 AppDoctor. All rights reserved.
//

import UIKit
import SwiftSoup
import Foundation
import CoreData

class ViewController: UIViewController {

//    var songs = [Songs]()
    var dataTester = DataTester()
    
    var fetching = Fetching()
    var adder = AdderStruct()
    
    
    
    var songs : [NSManagedObject] = []
    
    let helpingArray = ["one" , "two", "threee"]
    var coreDataLogic = CoreDataLogic()
    
    var urlsFromScrapper = Fetching.urls {
        didSet {
            AdderStruct.adderLoop(urlList: urlsFromScrapper)
            tableVController.reloadData()
        }
    }
    
    
    var NameAndURLFromCoreData = [SongsObject]()
    
    
  
    @IBOutlet weak var urlTextLabel: UITextField!
    
    
    @IBOutlet weak var saveOutlet: UIButton!
    
    @IBOutlet weak var youtubeOutlet: UIButton!
    

    @IBOutlet weak var nameOfPlaylistLabel: UITextField!
    
    
    @IBOutlet weak var tableVController: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        coreDataLogic.goodFetch()
        
        NameAndURLFromCoreData = coreDataLogic.retreiveData()!
        tableVController.reloadData()
        print("objects from VC \(NameAndURLFromCoreData)")
        
        tableVController.delegate=self
        tableVController.dataSource=self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDataPlaylist()
        
        tableVController.reloadData()
        
    }
    
    func createData(){
        print("TO WRITE DATA TO CORE DATA")
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
       
        
        let SongsEntity = NSEntityDescription.entity(forEntityName: "Songs", in: managedContext)!
        
        guard let urlFromLabel = urlTextLabel.text else {return}
        guard let nameOfPlaylist = nameOfPlaylistLabel.text else {return}
        
        
        
        for i in 1...5 {
            let user = NSManagedObject(entity: SongsEntity, insertInto: managedContext)
            
            user.setValue("name: \(nameOfPlaylist) \(i)", forKey: "name")
            user.setValue("url: \(urlFromLabel) \(i)", forKey: "url")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        }
    
    @IBAction func buSave(_ sender: Any) {
       
//        Fetching.scrapperData(url: "https://www.youtube.com/watch?v=0XazYz5fjos&list=PLKXVCVbOAjBNPqobI_hAQd3bPf2oVPWE2")
        
        
        
        guard let url = urlTextLabel.text else {return }
        guard let name = nameOfPlaylistLabel.text else {return}
        
        
        tableVController.reloadData()

        NameAndURLFromCoreData = coreDataLogic.retreiveData()!
        
    }
    

    @IBAction func buAdd(_ sender: Any) {
        
        
        
        let alertController = UIAlertController(title: "Create The Playlist", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter The Play List Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter The Youtube Play List URL"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let urlTextField = alertController.textFields![1] as UITextField
            
            let nameToSave = nameTextField.text
            let urlToSave = urlTextField.text

            self?.coreDataLogic.createData(nameFromLabel: nameToSave, urlFromLabel: urlToSave)
            
            self?.tableVController.reloadData()
            
            
        })
        
        
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func retreiveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Songs")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "url") as! String)
                
                
            }
            
        } catch {
            print("Failed")
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

extension ViewController {
    
    func fetchDataPlaylist() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Songs")
        do {
            songs = try managedContext.fetch(fetchRequest)
            tableVController.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
}



extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NameAndURLFromCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let name = NameAndURLFromCoreData[indexPath.row].name
        let url = NameAndURLFromCoreData[indexPath.row].url
        cell?.textLabel?.text = name
        cell?.detailTextLabel?.text = "\(url)"
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             let objectToDelete : NSManagedObject = songs[indexPath.row] as NSManagedObject
           
            context.delete(objectToDelete) // delete managedObjectContext
            print("Object deleted")
            songs.remove(at: indexPath.row)
            print("Object removed")
//            tableVController.deleteRows(at: [indexPath], with: .fade)
            
            
            //            container.viewContext.delete(commit)
            //            diary.remove(at: indexPath.row)
            
            //            NSManagedObjectContext.delete(at: diary[indexPath.row])
            do {
                //            Loader.loadStories()
               
                
                appDelegate.saveContext()
                print("object loaded")
                tableVController.deleteRows(at: [indexPath], with: .fade)
                print("row deleted")
            } catch let error {
                print("Object can not be deleted")
            }
        }
    }
    
    
    
    
    
    
}



