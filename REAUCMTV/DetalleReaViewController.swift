//
//  DetalleReaViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 13/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

class DetalleReaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var rea: Rea!
  
  
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
}


