//
//  DetalleReaViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 13/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit
import AVKit

struct MyVariables {
  static var idVideo = "000"
  static let keyTiempoTotal = "tiempo"
  static let keyTranscurrido = "transcurrido"
}

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

  // Variable para almacenar los tiempos de visionado de los vídeos
  var videosTimes: [String:VideoTime]!
  

  
  // Outlets
  @IBOutlet var reaImageView: UIImageView!
  @IBOutlet var tituloReaLabel: UILabel!
  @IBOutlet var creatorLabel: UILabel!
  @IBOutlet var descripcionLabel: UILabel!
  @IBOutlet var indiceTableView: UITableView!
  

  
  private let reuseIdentifier = "CellTablaVideos"
  
  
  override func viewDidLoad() {
    
    for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
      print("->\(key)")
    }
    
    guard rea != nil else { return } // no vaya a ser...
    
    // Inicialización AVPlayerViewController
    fullScreenPlayerViewController = AVPlayerViewController()
    fullScreenPlayerViewController.showsPlaybackControls = true
    fullScreenPlayerViewController.requiresLinearPlayback = false

    // Delegato y datasource que alimentarán la tabla de índice.
    indiceTableView.delegate = self
    indiceTableView.dataSource = self
    
    tituloReaLabel.text = rea.title
    creatorLabel.text = rea.creator
    descripcionLabel.sizeToFit()
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
  
  
  override func viewWillAppear(animated: Bool) {
    
    // Estadísticas:
    GATracker.sharedInstance.screenView("DetalleViewController", customParameters: nil)
    
    print("viewWillAppear")
    
    // Si volvemos de ver un video
    if let player = fullScreenPlayerViewController.player {
      let tiempo =  Float(player.currentTime().value)
      let escala =  Float(player.currentTime().timescale)
      let transcurrido = tiempo/escala
      print("Tiempo transcurrido recuperado en viewWillAppear para video \(MyVariables.idVideo): \(transcurrido)")
      NSUserDefaults.standardUserDefaults().setFloat (transcurrido, forKey: MyVariables.keyTranscurrido + MyVariables.idVideo)
      indiceTableView.reloadData()
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
    
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    
    self.video = video // actualizamos la variable de clase para actualizar el asset.
    
    
    // Cogemos los datos de tiempo del NSUserDefaults
    let duracion = NSUserDefaults.standardUserDefaults().floatForKey(MyVariables.keyTiempoTotal + self.video.ucIdentifier)
    let transcurrido = NSUserDefaults.standardUserDefaults().floatForKey(MyVariables.keyTranscurrido + self.video.ucIdentifier)

    if duracion != 0 && transcurrido != 0 {
      // Existe un datos grabado
      // Dibujar el % de tiempo visto
      let anchoMaximo = cell.contenedorDuracionView.frame.width
      let anchoTranscurrido = (Float(anchoMaximo) * transcurrido) / duracion
      
      let vistaDuracion = UIView(frame:cell.contenedorDuracionView.frame)
      vistaDuracion.frame.size.width = CGFloat(anchoTranscurrido)
      vistaDuracion.backgroundColor = UIColor.redColor()
      cell.contentView.addSubview(vistaDuracion)
      
      print("\(video.ucIdentifier): \(transcurrido) de \(duracion)")
      
    }
 
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
    self.video = video  //esto no se guarda
    MyVariables.idVideo = video.ucIdentifier
    
    self.reproducirVideo()
  
  }
  
  // MARK: Funciones de Video
  
  func reproducirVideo() {
    print("Preparando para visualizar \(self.video.urlVideo)")
    let playerItem = AVPlayerItem(asset: asset)
    let fullScreenPlayer = AVPlayer(playerItem: playerItem)
    
    // obtenemos el total en segundos
    // TODO: Hacer sólo si este vídeo no tiene duracionTotal, en otro caso ya se ha leído y no es necesario.
    self.getDatosVideo()
    
    fullScreenPlayerViewController!.player = fullScreenPlayer
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetalleReaViewController.playerDidFinishPlaying(_:)),
                                                     name: AVPlayerItemDidPlayToEndTimeNotification, object: fullScreenPlayerViewController!.player!.currentItem)
    
    //fullScreenPlayerViewController!.player?.seekToTime(kCMTimeZero)
    let transcurrido = NSUserDefaults.standardUserDefaults().floatForKey(MyVariables.keyTranscurrido + self.video.ucIdentifier)
    fullScreenPlayerViewController!.player?.currentItem?.seekToTime(CMTimeMakeWithSeconds(Float64(transcurrido-1.0),60000))
    fullScreenPlayerViewController!.player?.play()
    presentViewController(fullScreenPlayerViewController, animated: true, completion: nil)
  }

  
  func playerDidFinishPlaying(note: NSNotification) {
    print("Video Finished")
    
    // Reseteamos el seekTime para que la próxima vez empieza desde cero.
    fullScreenPlayerViewController!.player?.seekToTime(kCMTimeZero)
    NSUserDefaults.standardUserDefaults().setFloat (0.0, forKey: MyVariables.keyTranscurrido + MyVariables.idVideo)
   
    print("reseteado tiempo transcurrido a 0.0 para \(MyVariables.keyTranscurrido + MyVariables.idVideo)")
    
    // Eliminamos el viewController del vídeo
    fullScreenPlayerViewController.dismissViewControllerAnimated(true, completion: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, forKeyPath:"AVPlayerItemDidPlayToEndTimeNotification")
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
      
      let tiempoEnSegundos = Float(totalTiempoSegundos)
      NSUserDefaults.standardUserDefaults().setFloat (tiempoEnSegundos, forKey: MyVariables.keyTiempoTotal + MyVariables.idVideo)
      print("Tiempo total del video \(MyVariables.idVideo): \(tiempoEnSegundos)")
      
      // Actualización de la interfaz caso de queramos mostrar el tiempo total en pantalla.
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //print("Duración \(tiempoEnMinutos) minutos, \(tiempoEnSegundos)")
        //self.lblDuracion.text = "Duración: \(tiempoEnMinutos)m, \(tiempoEnSegundos)s."
      })
      })
  }
  

}


