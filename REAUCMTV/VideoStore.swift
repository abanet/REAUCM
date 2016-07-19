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

import UIKit

struct reaAPI {
  static let baseURLStringVideos = "http://callejon.sim.ucm.es/vodREA/mp4:"
  static let finURLStringVideos  = "/playlist.m3u8"
  static let urlStringJson   = "http://apps.ucm.es/reaucmtv/datareaucmtv.json"
  static let baseURLImagenes = "http://apps.ucm.es/reaucmtv/img/"
}

enum ImageResult {
  case Success(UIImage)
  case Failure(ErrorType)
}

enum ImageError: ErrorType {
  case ImageCreationError
}

class VideoStore {
  
  
  let session: NSURLSession = {
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.requestCachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData //.ReturnCacheDataElseLoad
    return NSURLSession(configuration: config)
  }()
  
  
  var videoStore: [Rea]!
  
  
  func leerDatosRea(completion:([Rea]) -> Void){
    
    let request = NSURLRequest(URL: NSURL(string:reaAPI.urlStringJson)!)
    let task = session.dataTaskWithRequest(request) {
      (data, response, error) -> Void in
      
      if let jsonData = data {
        
        let json:JSON = JSON(data: jsonData)
        self.videoStore = [Rea]()
        let reaArray = json["reaucmtv"].arrayValue
        for reaJson in reaArray {
          let unRea = Rea(fromJson: reaJson)
          self.videoStore.append(unRea)
        }
        dispatch_async(dispatch_get_main_queue()) {
          completion(self.videoStore)
        }
        print("json: \(json)")
        print("Metadatos Rea leídos")
      } else if let requestError = error {
        print("Error leyendo json: \(requestError)")
        
      } else {
        print("Error no esperado leyendo json")
      }
    }
    task.resume()
  }
  
  
  
}

