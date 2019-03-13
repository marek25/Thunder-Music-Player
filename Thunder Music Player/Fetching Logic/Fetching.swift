//
//  Fetching.swift
//  Thunder Music Player
//
//  Created by OSX on 3/12/19.
//  Copyright © 2019 AppDoctor. All rights reserved.
//


import Foundation
import UIKit


import SwiftSoup


struct FetchedObjects {
    var html : String = ""
    var urlForCoreDataCourse = "https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc"
    
}





struct Fetching {
    let youtubeVar = "https://www.youtube.com"
    
    
    
    static var urls = [String]()
    
    
    static var html : String = ""
    
    static func scrapperData(url: String) {
    
        
    var adderSTR = AdderStruct()
        
        var temporaryURLs = [String]()
        
        let url = url
        if let initializedURL = URL.init(string: url) {
            let session = URLSession.shared
            let task = session.dataTask(with: initializedURL){ data, response, error in
                let error = error?.localizedDescription
                guard let data = data else {return }
                print(data)
                
                guard let EncoddedDocument = String(data: data, encoding: .utf8) else {return}
                
                
                do {
                    
                    let doc : Document = try SwiftSoup.parse(EncoddedDocument)
                    do {
                        //
                        //                let element = try doc.select("title").first()
                        //                let div = try doc.select("div").array()
                        //                let p = try doc.select("p").array()
                        let a  = try doc.select("a").array()
                        //                let link = try a?.attr("href")
//                        let textA : Element = try a.text()
                        //                let className = try a?.className()
                        //                let idName = try a?.id()
                        //
                        
                        
                        //                let recognitionkey = "list=PLRwOBqkqX-aPgVMzwPJ8hXj7fbhBxsNB0"
                        let recognitionKeyByIndex = "index"
                        let buggyWord = "index=32"
                        
                        
                        
                        for elementOfDIVTag in a {
                            let a = elementOfDIVTag
                            let specialA = try? a.getElementsByClass("compact-media-item-image")
                            
                            let titleInLoop = try a.attr("title")
                            let filteredHrefFromA = try a.attr("href")
                            let dataThumb = try a.attr("data-thumb")
                            
                            
                            
                            //                    print("a TAG:\(a)")
                            //                    print("special A: \(specialA)")
                            //                    print("TITLOVI PRE LOOP-A: \(titleInLoop)")
                            //                    print("A TAGOVI: \(a)")
                            //                    print("data-thumb: \(dataThumb)")
                            
                            //                    dataThumbImage?.append(dataThumb)
                            if filteredHrefFromA.contains(recognitionKeyByIndex) &&  filteredHrefFromA.contains(buggyWord) == false {
                                //                        print("SUPER FILTERED LINKS: \(filteredHrefFromA)")
                                var filth = filteredHrefFromA
                                //                        print("------- FILTH: \(filth)")
                                //                        print("--------TITLOVI U LOOP-U: \(title)")
                                let youtubeVar = "https://www.youtube.com"
                                
                                let finalLink =  youtubeVar + filth
                              
                                temporaryURLs.append(finalLink)
                                urls.append(finalLink)
                                //                                                        print("TITLES FROM FILTERED URLS: \(titleInLoop)")
                                print("link from finalLink: \(finalLink)")
                            }
                        }
                    }
                } catch {
                }
                
            }
            task.resume()
            
            AdderStruct.adderLoop(urlList: temporaryURLs)
        }
        
       
    }
    
    
    
    
    
    
    
}



struct AdderStruct {
    
   static func adderLoop(urlList: [String]) {
        if urlList.count != 0 {
            
            var counter = 0
            for url in urlList {
                //                var song : String?
                
                if  let InitializeURL = URL.init(string: url) {
                    let task = URLSession.shared.dataTask(with: InitializeURL) { data, response, error in
                        guard let data = data, error == nil else { return }
                        if  let EncoddedDocument = String(data: data, encoding: .utf8) {
                            
                            do {
                                let doc : Document = try SwiftSoup.parse(EncoddedDocument)
                                let element = try doc.select("title").first()
                                
                                
                                
                                let song = String(describing: element)
                                //                                        print("------SONG \(String(describing: song))")
                                //                                        print("------URL \(url)")
                                
                                //                                        self.List.append(DocumentToSave(nameToSave: song, urlToSave: url))
                                
                                counter = counter + 1
                                DispatchQueue.main.async {
                                    //                                    self.dbLogic.possibleFunc(name: song, url: url)
                                    //                                    self.tableView.reloadData()
                                    
                                    
                                    
                                    
                                    //                                    self.dataB.name = song
                                    //                                    self.dataB.url = url
                                    
                                    //SNIMAJ OVDE
                                }
                                print("-------------COUNTER IS:\(counter)")
                                
                                //                                        self.dbLogic.possibleFunc(name: song, url: url)
                                
                                
                                
                                //                                        print("LIST COUNT: \(self.List.count)")
                                //                                        print("""
                                //                                            LIST NAME: \(self.List[counter].nameToSave)
                                //                                            LIST URL: \(self.List[counter].urlToSave)
                                //                                            """)
                                
                            }catch {
                                print("nece da moze")
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
        
    }
}



