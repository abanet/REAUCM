//
//  ReaViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 11/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

//BARRASTIEMPO
//struct MyVariables {
//  static var idVideo = "000"
//  static let keyTiempoTotal = "tiempo"
//  static let keyTranscurrido = "transcurrido"
//}

class ReaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  var almacenRea: VideoStore!
  var listaRea = [Rea]()
  var imageStore: ImageStore!
  
  fileprivate var indexReaSeleccionado = 0
  
  
  @IBOutlet var reaCollectionView: UICollectionView!
  fileprivate let reuseIdentifier = "ReaCell"
  
  
  @IBOutlet var tituloReaLabel: UILabel!
  @IBOutlet var descripcionReaLabel: UILabel!
  @IBOutlet var bannerImageView: UIImageView!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Limpiamos los label que vienen con información del storyboard
      tituloReaLabel.text = ""
      descripcionReaLabel.text = ""
      bannerImageView.image = nil
      
      // Asignación de datasource y delegate
      reaCollectionView.dataSource = self
      reaCollectionView.delegate = self
      
      // Lectura de vídeos y actualización del collectionView cuando acaba la descarga.
      almacenRea.leerDatosRea() { reas in
        self.listaRea = reas
        self.reaCollectionView?.reloadData()
      }
      
      print("datos leídos")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "SegueDetalleRea" {
      if let destinationViewController = segue.destination as? DetalleReaViewController {
        // coger información de la celda y configurarla en el viewcontroller destino
        
        // Alimentar tiempos de video del Rea seleccionado
        
        //BARRASTIEMPO
        //destinationViewController.gestorTiempos = GestorTiempos(id: listaRea[indexReaSeleccionado].ucIdentifier)
        
        destinationViewController.rea = listaRea[indexReaSeleccionado]
        destinationViewController.imageStore = imageStore
        
      }
    }
  }

}


// MARK: UICollectionViewDataSource
extension ReaViewController {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("Número de rea: \(reaEnSeccion(section).count)")
    return reaEnSeccion(section).count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = reaCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReaCollectionViewCell
    
    // Lo dejamos preparado para cuando haya varias secciones.
    let sectionRea = reaEnSeccion(indexPath.section)
    let rea = sectionRea[indexPath.item]
    
    if let idPhoto = rea.fotoSeleccion?.photoID {
      if let imagenCache = imageStore.imageForKey(key: idPhoto) {
        cell.reaImageView.image = imagenCache
      } else {
        rea.fotoSeleccion!.obtenerImagen {
          [weak self] (imageResult) -> Void in
          switch imageResult {
          case let . success(image):
            DispatchQueue.main.async {
              cell.reaImageView.image = image
              self?.imageStore.setImage(image: image, forKey: idPhoto)
            }
          case let .failure(error):
            print("Error descargando imagen: \(error)")
          }
        }
      }
    }
    
    
    cell.reaLabel.text = rea.title
    
    return cell
  }
  
}

// MARK: UICollectionViewDelegate
extension ReaViewController {
  
  
  func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    
    guard let indice = context.nextFocusedIndexPath else { return }
    
    let sectionRea = reaEnSeccion(indice.section)
    let rea = sectionRea[indice.item]
    indexReaSeleccionado = indice.item  // actualizamos el índice del rea seleccionado para que esté disponible en el segue. De momento trabajamos con una sóla sección así que nos vale el indice.item.
    
    
    tituloReaLabel.text = rea.title
    descripcionReaLabel.text = rea.description
    
    if let idPhoto = rea.fotoLarga?.photoID {
      if let imagenCache = imageStore.imageForKey(key: idPhoto) {
        self.bannerImageView.image = imagenCache
      } else {
        rea.fotoLarga!.obtenerImagen {
          [weak self] (imageResult) -> Void in
          switch imageResult {
          case let . success(image):
            DispatchQueue.main.async {
              self?.bannerImageView.image = image
              self?.imageStore.setImage(image: image, forKey: idPhoto)
              self?.bannerImageView.alpha = 0
              UIView.animate(withDuration: 1.0, animations: {
                self?.bannerImageView.alpha = 1.0
              })
            }
            
          case let .failure(error):
            print("Error descargando imagen: \(error)")
          }
        }
      }
    }
    
  }
  
  
}


// MARK: UICollectionViewDelegateFlowLayout
extension ReaViewController: UICollectionViewDelegateFlowLayout {
  
  // Tamaño de las celdas
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 550, height: 430)
  }
  
  // Espacio entre cabera de sección, celdas y pies
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}


// MARK: Métodos privados
private extension ReaViewController {
  // Preparado para cuando haya diferentes secciones
  func reaEnSeccion(_ seccion: Int) -> [Rea] {
    return self.listaRea
  }
}
