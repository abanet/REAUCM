//
//  DetalleReaViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 13/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit
import AVKit

class DetalleReaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var rea: Rea!
  
  // Variables para visualización del vídeo
  var fullScreenPlayerViewController: AVPlayerViewController!
  var asset: AVAsset!
  var video: Video! {
    didSet {
      asset = AVAsset(URL: self.video.urlVideo)
    }
  }

  
  // Outlets
  @IBOutlet var reaImageView: UIImageView!
  @IBOutlet var tituloReaLabel: UILabel!
  @IBOutlet var creatorLabel: UILabel!
  @IBOutlet var descripcionLabel: UILabel!
  @IBOutlet var indiceTableView: UITableView!

  
  private let reuseIdentifier = "CellTablaVideos"
  
  
  override func viewDidLoad() {
    
    guard rea != nil else { return } // no vaya a ser...
    
    // Delegato y datasource que alimentarán la tabla de índice.
    indiceTableView.delegate = self
    indiceTableView.dataSource = self
    
    tituloReaLabel.text = rea.title
    creatorLabel.text = rea.creator
    descripcionLabel.text = rea.description
    
    rea.fotoSeleccion!.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
      case let . Success(image):
        dispatch_async(dispatch_get_main_queue()) {
          // cuidado con memory leaks
          self.reaImageView.image = image
        }
        
      case let .Failure(error):
        print("Error descargando imagen: \(error)")
      }
    }
  }
  
  
  // MARK: UITableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return rea.unidades.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let unidad = rea.unidades[section]
    return unidad.videos.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = indiceTableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! VideoTableViewCell
    print("Título de vídeo: \(rea.unidades[indexPath.section].videos[indexPath.row].title)")
    
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    self.video = video // actualizamos la variable de clase para actualizar el asset.

    // Cargamos la imagen de la celda
    video.miniatura!.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
      case let . Success(image):
        dispatch_async(dispatch_get_main_queue()) {
          cell.miniaturaVideoImageView.image = image
        }
        
      case let .Failure(error):
        print("Error descargando imagen: \(error)")
      }
    }
    
    cell.tituloVideoLabel.text = video.title
    
    return cell
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return rea.unidades[section].title
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
  {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = UIColor.lightGrayColor()
  }
  
  // MARK: UITableViewDelegate
  
  // Evitamos que deje de verse el texto cuando la celda tiene el focus.
  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    if let celdaPrevia = context.previouslyFocusedView as? VideoTableViewCell {
      celdaPrevia.tituloVideoLabel.textColor = UIColor.whiteColor()
    }
    
    if let siguienteCelda = context.nextFocusedView as? VideoTableViewCell {
      siguienteCelda.tituloVideoLabel.textColor = UIColor.blackColor()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    
    // actualizamos la variable de clase para actualizar el asset.
    self.video = video
    
    self.reproducirVideo()
  
  }
  
  // MARK: Funciones de Video
  
  func reproducirVideo() {
    print("Preparando para visualizar \(self.video.urlVideo)")
    let playerItem = AVPlayerItem(asset: asset)
    let fullScreenPlayer = AVPlayer(playerItem: playerItem)
    fullScreenPlayerViewController = AVPlayerViewController()
    fullScreenPlayerViewController!.player = fullScreenPlayer
    presentViewController(fullScreenPlayerViewController, animated: true, completion: nil)
  }

  
  private func getDatosVideo() {
    asset.loadValuesAsynchronouslyForKeys(["duration"], completionHandler: {
      [unowned self]() in
      var error: NSError?
      let status = self.asset.statusOfValueForKey("duration", error: &error)
      if status != AVKeyValueStatus.Loaded {
        print("No podemos acceder a la duración del vídeo")
        if let error = error {
          print("\(error)")
        }
        return
      }
      
      let totalTiempoSegundos = CMTimeGetSeconds(self.asset.duration)
      let tiempoEnMinutos = Int(totalTiempoSegundos / 60)
      let tiempoEnSegundos = Int(totalTiempoSegundos % 60)
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //print("Duración \(tiempoEnMinutos) minutos, \(tiempoEnSegundos)")
        //self.lblDuracion.text = "Duración: \(tiempoEnMinutos)m, \(tiempoEnSegundos)s."
      })
      })
  }
  
  
}


