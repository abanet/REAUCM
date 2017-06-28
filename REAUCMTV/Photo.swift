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
  
  var remoteURL: URL?
  var photoID: String?
  var image: UIImage?
  let session: URLSession?
  let URLCache = Foundation.URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
  
  
  init() {
    // TODO: dejar caché para modo producción
    // Configuramos la caché
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData //.ReturnCacheDataElseLoad
    session = URLSession(configuration: config)

  }
  
  convenience init(photoID: String, remoteURL: URL) {
    //print("photoID: \(photoID), remoteURL: \(remoteURL)")
    self.init()
    self.photoID = photoID
    self.remoteURL = remoteURL
    //print("URL imagen \(remoteURL)")
    self.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
        case let .success(image):
          self.image = image
        case let .failure(error):
          print("Error descargando imagen: \(error) desde \(remoteURL)")
      }
    }
  }
  
  func obtenerImagen(_ completion: @escaping (ImageResult) -> Void) {
    let request = URLRequest(url: self.remoteURL!)
    let task = session!.dataTask(with: request, completionHandler: {
      [weak self] (data, response, error) -> Void in
      if let resultado = self?.procesarImagen(data, error: error as NSError?) {
        if case let .success(image) = resultado {
          self?.image = image
        }
      completion(resultado)
      }
    })
    
    task.resume()
  }
  
  
  func procesarImagen(_ data: Data?, error: NSError?) -> ImageResult {
    guard let
      imageData = data,
      let image = UIImage(data: imageData) else {
        // No se ha podido crear la imagen con los datos recibidos
        if (data == nil) {
          return .failure(error!)
        } else {
          return .failure(ImageError.imageCreationError)
        }
    }
    return .success(image)
  }
  
  
  // Obtiene una imagen de la foto correspondiente
  func obtenerImagenDeFoto(_ completion: @escaping (UIImage?) -> Void) {
    let request = URLRequest(url: self.remoteURL!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0)
    if let response = URLCache.cachedResponse(for: request) {
      let image = UIImage(data: response.data)
      DispatchQueue.main.async {
        completion(image)
        return
      }
    }
    
    session!.dataTask(with: request, completionHandler: {
      (data: Data?, response: URLResponse?, error: NSError?) -> Void in
      guard let response = response, let data = data else {
        completion(nil)
        return
      }
      Photo.shareInstance.URLCache.storeCachedResponse(CachedURLResponse(response:response, data:data, userInfo:nil, storagePolicy: .allowed), for: request)
      let downloadImage = UIImage(data: data)
      DispatchQueue.main.async {
        completion(downloadImage)
      }
    } as! (Data?, URLResponse?, Error?) -> Void) .resume()
    
  }
  
}

// No utilizado.
extension UIImageView {
  func setImageFromPhoto(_ photo: Photo) {
    image = nil
    Photo.shareInstance.obtenerImagenDeFoto {
      image in
      if self.image == nil {
        self.image = image
      }
    }
  }
}
