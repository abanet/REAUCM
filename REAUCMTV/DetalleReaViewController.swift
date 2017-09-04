//
//  DetalleReaViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 13/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

// Notas 1 versión
// Al no dar tiempo a completar comentamos el código orientado a la visualización de barras de estado con el código //BARRASTIEMPO
import UIKit
import AVKit



class DetalleReaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var rea: Rea!
  var imageStore: ImageStore!
  
  //BARRASTIEMPO
  //var gestorTiempos: GestorTiempos!
  
  // Variables para visualización del vídeo
  var fullScreenPlayerViewController: AVPlayerViewController!
  var asset: AVAsset!
  var video: Video! {
    didSet {
      asset = AVAsset(url: self.video.urlVideo as URL)
    }
  }

  
  // Variable para almacenar los tiempos de visionado de los vídeos
  //var videosTimes: [String:VideoTime]!
  

  
  // Outlets
  @IBOutlet var reaImageView: UIImageView!
  @IBOutlet var tituloReaLabel: UILabel!
  @IBOutlet var creatorLabel: UILabel!
  @IBOutlet var descripcionLabel: UILabel!
  @IBOutlet var indiceTableView: UITableView!
  

  
  fileprivate let reuseIdentifier = "CellTablaVideos"
  
  
  override func viewDidLoad() {
    
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
    
    if let idPhoto = rea.fotoSeleccion?.photoID {
      if let imagenCache = imageStore.imageForKey(key: idPhoto) {
        self.reaImageView.image = imagenCache
      } else {
        rea.fotoSeleccion!.obtenerImagen {
          [weak self] (imageResult) -> Void in
          switch imageResult {
          case let . success(image):
            DispatchQueue.main.async {
              self?.reaImageView.image = image
              self?.imageStore.setImage(image: image, forKey: idPhoto)
            }
            
          case let .failure(error):
            print("Error descargando imagen: \(error)")
          }
        }
      }
    }
    
  
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Estadísticas de acceso a REA:
    let etiqueta = rea.ucIdentifier + ": " + rea.title
    GATracker.sharedInstance.event(category: "Rea iOS", action: "Entrando", label: etiqueta, customParameters: ["idRea":rea.ucIdentifier])
    print("viewWillAppear")
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    print("viewDidAppear")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    //BARRASTIEMPO
    //self.gestorTiempos.updateGestorTiempo()
  }
  
  // MARK: UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return rea.unidades.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let unidad = rea.unidades[section]
    return unidad.videos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = indiceTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VideoTableViewCell
    
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    
    self.video = video // actualizamos la variable de clase para actualizar el asset.
    
    
    // Cogemos los datos de tiempo del NSUserDefaults
    
//BARRASTIEMPO
//    if let unTiempoVideo = gestorTiempos.tiempos[self.video.ucIdentifier] {
//      let duracion = unTiempoVideo.duracion
//      let transcurrido = unTiempoVideo.transcurrido
//
//      if duracion != 0 && transcurrido != 0 {
//        // Existe un datos grabado
//        // Dibujar el % de tiempo visto
//        let anchoMaximo = cell.contenedorDuracionView.frame.width
//        let anchoTranscurrido = (Float(anchoMaximo) * transcurrido) / duracion
//      
//        let vistaDuracion = UIView(frame:cell.contenedorDuracionView.frame)
//        vistaDuracion.frame.size.width = CGFloat(anchoTranscurrido)
//        vistaDuracion.backgroundColor = UIColor.redColor()
//        cell.contentView.addSubview(vistaDuracion)
//      
//        print("\(video.ucIdentifier): \(transcurrido) de \(duracion)")
//      
//    }
//    }
 
    // Cargamos la imagen de la celda
    if let idPhoto = video.miniatura?.photoID {
      if let imagenCache = imageStore.imageForKey(key: idPhoto) {
        if cell.miniaturaVideoImageView != nil {
          cell.miniaturaVideoImageView.image = imagenCache
        }
      } else {
        video.miniatura!.obtenerImagen {
          [weak self] (imageResult) -> Void in
          switch imageResult {
          case let . success(image):
            self?.imageStore.setImage(image: image, forKey: idPhoto)
            DispatchQueue.main.async {
              if cell.miniaturaVideoImageView != nil {
                cell.miniaturaVideoImageView.image = image
                
              }
            }
            
          case let .failure(error):
            print("Error descargando imagen: \(error)")
          }
        }

      }
    }
    
    cell.tituloVideoLabel.text = video.title
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return rea.unidades[section].title
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
  {
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = UIColor.lightGray
  }
  
  // MARK: UITableViewDelegate
  
  // Evitamos que deje de verse el texto cuando la celda tiene el focus.
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if let celdaPrevia = context.previouslyFocusedView as? VideoTableViewCell {
      celdaPrevia.tituloVideoLabel.textColor = UIColor.lightGray
    }
    
    if let siguienteCelda = context.nextFocusedView as? VideoTableViewCell {
      siguienteCelda.tituloVideoLabel.textColor = UIColor.black
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // Obtenemos el vídeo que estamos tratando
    let unidadDidactica = rea.unidades[indexPath.section]
    let video = unidadDidactica.videos[indexPath.row]
    
    // actualizamos la variable de clase para actualizar el asset.
    self.video = video  //esto no se guarda
    
    //BARRASTIEMPO
    //MyVariables.idVideo = video.ucIdentifier
    
    self.reproducirVideo()
  
  }
  
  // MARK: Funciones de Video
  
  func reproducirVideo() {
    print("Preparando para visualizar \(self.video.urlVideo)")
    let playerItem = AVPlayerItem(asset: asset)
    let fullScreenPlayer = AVPlayer(playerItem: playerItem)
    
    //Estadística de visualización de vídeo
    let etiqueta = rea.ucIdentifier + "->" + video.ucIdentifier + ": " + video.title
    GATracker.sharedInstance.event(category: "Vídeo iOS", action: "Visualizando", label: etiqueta, customParameters: ["idRea":rea.ucIdentifier, "idVideo":self.video.ucIdentifier])
    
    // obtenemos el total en segundos
    
    //BARRASTIEMPO
    // Cargamos datos del video sin no existe un tiempo de duración.
//    if let unTiempoVideo = gestorTiempos.tiempos[self.video.ucIdentifier] {
//      if unTiempoVideo.duracion == 0.0 {
//        self.getDatosVideo()
//      }
//    } else { self.getDatosVideo() }
    
    fullScreenPlayerViewController!.player = fullScreenPlayer
    NotificationCenter.default.addObserver(self, selector: #selector(DetalleReaViewController.playerDidFinishPlaying(_:)),
                                                     name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: fullScreenPlayerViewController!.player!.currentItem)
    
   
    //BARRASTIEMPO
//    if let unTiempoVideo = gestorTiempos.tiempos[self.video.ucIdentifier] {
//      let transcurrido = unTiempoVideo.transcurrido
//      let seekTime = CMTimeMakeWithSeconds(Float64(transcurrido-1.0),60000)
//      if seekTime.isValid {
//        fullScreenPlayerViewController!.player?.currentItem?.seekToTime(seekTime)
//      }
//    }
    
    fullScreenPlayerViewController!.player?.play()
    present(fullScreenPlayerViewController, animated: true, completion: nil)
  }

  //BARRASTIEMPO
//  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//    print("obsrved")
//  }
  
   //BARRASTIEMPO
//  func videoTerminado() {
//    // Si volvemos de ver un video
//    if let player = fullScreenPlayerViewController.player {
//      let tiempo =  Float(player.currentTime().value)
//      let escala =  Float(player.currentTime().timescale)
//      let transcurrido = tiempo/escala
//      print("Tiempo transcurrido recuperado en viewWillAppear para video \(MyVariables.idVideo): \(transcurrido)")
//      if let tiempo = gestorTiempos.tiempos[MyVariables.idVideo] {
//        gestorTiempos.tiempos[MyVariables.idVideo]?.transcurrido = tiempo.transcurrido
//      } else {
//        let newTiempo = VideoTime(ucIdentifier: MyVariables.idVideo, duracion: 0.0, transcurrido: transcurrido)
//        gestorTiempos.tiempos[MyVariables.idVideo] = newTiempo
//      }
//      dispatch_async(dispatch_get_main_queue()) {
//        self.indiceTableView.reloadData()
//      }
//    }
//  }
  
  func playerDidFinishPlaying(_ note: Notification) {
    print("Video Finished")
    
    
    // Estadística de finalización de vídeo
    
    // Reseteamos el seekTime para que la próxima vez empieza desde cero.
    fullScreenPlayerViewController!.player?.seek(to: kCMTimeZero)
    
    let etiqueta = rea.ucIdentifier + "->" + video.ucIdentifier + ": " + video.title
    GATracker.sharedInstance.event(category: "Vídeo iOS", action: "Terminado", label: etiqueta, customParameters: ["idRea":rea.ucIdentifier, "idVideo":self.video.ucIdentifier])
    
    //BARRASTIEMPO
//    if let tiempo = gestorTiempos.tiempos[MyVariables.idVideo] {
//      tiempo.transcurrido = 0.0
//    } else {
//      let newTiempo = VideoTime(ucIdentifier: MyVariables.idVideo, duracion: 0.0, transcurrido: 0.0)
//      gestorTiempos.tiempos[MyVariables.idVideo] = newTiempo
//    }

    // Eliminamos el viewController del vídeo
    
    fullScreenPlayerViewController.dismiss(animated: true, completion: nil)
  }
  
  
  deinit {
       NotificationCenter.default.removeObserver(self)
  }
  
  //BARRASTIEMPO
//  private func getDatosVideo() {
//       asset.loadValuesAsynchronouslyForKeys(["duration"], completionHandler: {
//      [unowned self]() in
//      var error: NSError?
//      let status = self.asset.statusOfValueForKey("duration", error: &error)
//      if status != AVKeyValueStatus.Loaded {
//        print("No podemos acceder a la duración del vídeo")
//        if let error = error {
//          print("\(error)")
//        }
//        return
//      }
//      
//      let totalTiempoSegundos = CMTimeGetSeconds(self.asset.duration)
//      
//      let tiempoEnSegundos = Float(totalTiempoSegundos)
//      
//      if let tiempo = self.gestorTiempos.tiempos[MyVariables.idVideo] {
//        tiempo.duracion = tiempoEnSegundos
//      } else {
//        let newTiempo = VideoTime(ucIdentifier: MyVariables.idVideo, duracion: tiempoEnSegundos, transcurrido: 0.0)
//        self.gestorTiempos.tiempos[MyVariables.idVideo] = newTiempo
//      }
//           // Actualización de la interfaz caso de queramos mostrar el tiempo total en pantalla.
//      dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        //print("Duración \(tiempoEnMinutos) minutos, \(tiempoEnSegundos)")
//        //self.lblDuracion.text = "Duración: \(tiempoEnMinutos)m, \(tiempoEnSegundos)s."
//      })
//      })
//  }
  

  
}


