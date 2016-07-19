//
//  Photo.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 11/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

class Photo {
  static let shareInstance = Photo()
  
  var remoteURL: NSURL?
  var photoID: String?
  var image: UIImage?
  let session: NSURLSession?
  let URLCache = NSURLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
  
  init() {
    // TODO: dejar caché para modo producción
    // Configuramos la caché
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    config.requestCachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData //.ReturnCacheDataElseLoad
    session = NSURLSession(configuration: config)

  }
  
  convenience init(photoID: String, remoteURL: NSURL) {
    self.init()
    self.photoID = photoID
    self.remoteURL = remoteURL
    self.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
        case let .Success(image):
          self.image = image
        case let .Failure(error):
          print("Error descargando imagen: \(error) desde \(remoteURL)")
      }
    }
  }
  
  func obtenerImagen(completion: (ImageResult) -> Void) {
    let request = NSURLRequest(URL: self.remoteURL!)
    let task = session!.dataTaskWithRequest(request) {
      (data, response, error) -> Void in
      let resultado = self.procesarImagen(data, error: error)
      if case let .Success(image) = resultado {
        self.image = image
      }
      completion(resultado)
    }
    
    task.resume()
  }
  
  
  func procesarImagen(data: NSData?, error: NSError?) -> ImageResult {
    guard let
      imageData = data,
      image = UIImage(data: imageData) else {
        // No se ha podido crear la imagen con los datos recibidos
        if (data == nil) {
          return .Failure(error!)
        } else {
          return .Failure(ImageError.ImageCreationError)
        }
    }
    return .Success(image)
  }
  
  
  // Obtiene una imagen de la foto correspondiente
  func obtenerImagenDeFoto(completion: (UIImage?) -> Void) {
    let request = NSURLRequest(URL: self.remoteURL!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30.0)
    if let response = URLCache.cachedResponseForRequest(request) {
      let image = UIImage(data: response.data)
      dispatch_async(dispatch_get_main_queue()) {
        completion(image)
        return
      }
    }
    
    session!.dataTaskWithRequest(request) {
      (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      guard let response = response, data = data else {
        completion(nil)
        return
      }
      Photo.shareInstance.URLCache.storeCachedResponse(NSCachedURLResponse(response:response, data:data, userInfo:nil, storagePolicy: .Allowed), forRequest: request)
      let downloadImage = UIImage(data: data)
      dispatch_async(dispatch_get_main_queue()) {
        completion(downloadImage)
      }
    }.resume()
    
  }
  
}

// No utilizado.
extension UIImageView {
  func setImageFromPhoto(photo: Photo) {
    image = nil
    Photo.shareInstance.obtenerImagenDeFoto {
      image in
      if self.image == nil {
        self.image = image
      }
    }
  }
}