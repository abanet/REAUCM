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
  case success(UIImage)
  case failure(Error)
}

enum ImageError: Error {
  case imageCreationError
}

class VideoStore {
  
  
  let session: URLSession = {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData //.ReturnCacheDataElseLoad
    return URLSession(configuration: config)
  }()
  
  
  var videoStore: [Rea]!
  
  
  func leerDatosRea(_ completion:@escaping ([Rea]) -> Void){
    let request = URLRequest(url: URL(string:reaAPI.urlStringJson)!)
    let task = session.dataTask(with: request, completionHandler: {
      [weak self] (data, response, error) -> Void in
      
      if let jsonData = data {
        
        let json:JSON = JSON(data: jsonData)
        self?.videoStore = [Rea]()
        let reaArray = json["reaucmtv"].arrayValue
        for reaJson in reaArray {
          let unRea = Rea(fromJson: reaJson)
          self?.videoStore.append(unRea)
        }
        DispatchQueue.main.async {
          if let videos = self?.videoStore {
            completion(videos)
          }
        }
        //print("json: \(json)")
        print("Metadatos Rea leídos")
      } else if let requestError = error {
        print("Error leyendo json: \(requestError)")
        
      } else {
        print("Error no esperado leyendo json")
      }
    }) 
    task.resume()
  }
  
  
  
}

