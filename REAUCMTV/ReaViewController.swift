//
//  ReaViewController.swift
//  REAUCMTV
//
//  Created by Alberto Banet Masa on 11/7/16.
//  Copyright © 2016 UCM. All rights reserved.
//

import UIKit

class ReaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

  var almacenRea: VideoStore!
  var listaRea = [Rea]()
  
  
  @IBOutlet var reaCollectionView: UICollectionView!
  private let reuseIdentifier = "ReaCell"
  
  
  @IBOutlet var tituloReaLabel: UILabel!
  @IBOutlet var descripcionReaLabel: UILabel!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
    

}


// MARK: UICollectionViewDataSource
extension ReaViewController {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("Número de rea: \(reaEnSeccion(section).count)")
    return reaEnSeccion(section).count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = reaCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ReaCollectionViewCell
    
    // Lo dejamos preparado para cuando haya varias secciones.
    let sectionRea = reaEnSeccion(indexPath.section)
    let rea = sectionRea[indexPath.item]
    
    rea.fotoSeleccion!.obtenerImagen {
      (imageResult) -> Void in
      switch imageResult {
      case let . Success(image):
        dispatch_async(dispatch_get_main_queue()) {
          cell.reaImageView.image = image
        }
          
      case let .Failure(error):
        print("Error descargando imagen: \(error)")
      }
    }
    
    cell.reaLabel.text = rea.title
    
    return cell
  }
  
}

// MARK: UICollectionViewDelegate
extension ReaViewController {
  func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    let indice = context.nextFocusedIndexPath!
    let sectionRea = reaEnSeccion(indice.section)
    let rea = sectionRea[indice.item]
    tituloReaLabel.text = rea.title
    descripcionReaLabel.text = rea.description
  }
}


// MARK: UICollectionViewDelegateFlowLayout
extension ReaViewController: UICollectionViewDelegateFlowLayout {
  
  // Tamaño de las celdas
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: 550, height: 430)
  }
  
  // Espacio entre cabera de sección, celdas y pies
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}


// MARK: Métodos privados
private extension ReaViewController {
  // Preparado para cuando haya diferentes secciones
  func reaEnSeccion(seccion: Int) -> [Rea] {
    return self.listaRea
  }
}