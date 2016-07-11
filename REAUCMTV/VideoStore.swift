//
//  VideoStore.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 6/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import Foundation


// Clase de comunicación con las API de datos
// Inicialmente no existirán API y se limitará a descargar los datos de un fichero json.

import Foundation

struct reaAPI {
  static let baseURLStringVideos = "http://callejon.sim.ucm.es/vodREA/mp4:"
  static let finURLStringVideos  = "/playlist.m3u8"
  static let urlStringJson   = "http://apps.ucm.es/reaucmtv/datareaucmtv.json"
}

class VideoStore {
  
  
  let session: NSURLSession = {
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession(configuration: config)
  }()
  
  var videoStore: [Rea]!
  
  
  
  func leerDatosRea(){
    let request = NSURLRequest(URL: NSURL(string:reaAPI.urlStringJson)!)
    
    
    let task = session.dataTaskWithRequest(request) {
      (data, response, error) -> Void in
      
      if let jsonData = data {
        
//        do {
//          let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [.AllowFragments])
//          print(jsonObject)
//        }
//        catch let error {
//          print("Error al crear JSON: \(error)")
//        }
        
        let json:JSON = JSON(data: jsonData)
        self.videoStore = [Rea]()
        let reaArray = json["reaucmtv"].arrayValue
        for reaJson in reaArray {
          let unRea = Rea(fromJson: reaJson)
          self.videoStore.append(unRea)
        }
        
//        if let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
//          print(jsonString)
//        }
      } else if let requestError = error {
        print("Error leyendo json: \(requestError)")
      } else {
        print("Error no esperado leyendo json")
      }
    }
    task.resume()
  }
  
  
  
}

