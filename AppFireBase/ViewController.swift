//
//  ViewController.swift
//  AppFireBase
//
//  Created by dani y rafa on 03/02/2020.
//  Copyright © 2020 dani. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfNombreCientifico: UITextField!
    @IBOutlet weak var tfClase: UITextField!
    
    var animalArray = [String]()
    var animalesArray = [Animal]()
    let databaseref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        tableView.delegate = self
        self.tableView.rowHeight=30
        escuchaDatos()
    }
    
    func escuchaDatos(){
        databaseref.child("ANIMALES").observe(.value) { snapshot in
            if let dict = snapshot.value as? NSDictionary{
                let keys = dict.allKeys
                self.animalesArray.removeAll()
                for key in keys{
    
                    if let nestedDict = dict[key] as? [String:Any]{
                        
                        let nombre = nestedDict["nombre"] as! String
                        let nombreCientifico = nestedDict["nombreCientifico"] as! String
                        let clase = nestedDict["clase"] as! String
                        print(nombreCientifico)
                        print(clase)
                        print(nombre)
                        self.animalesArray.append(Animal(key: key as! String, nombre: nombre, nombreCientifico: nombreCientifico, clase: clase))
                        
                        
                    }
                    
                }
                
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.animalesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let labelNombre = cell.viewWithTag(123) as! UILabel
        let labelCientifico = cell.viewWithTag(124) as! UILabel
        let labelClase = cell.viewWithTag(125) as! UILabel
        labelNombre.text = animalesArray[indexPath.section].nombre
        labelCientifico.text = animalesArray[indexPath.section].nombreCientifico
        labelClase.text = animalesArray[indexPath.section].clase
        
        return cell
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    
    @IBAction func botonDelete(_ sender: Any) {
        if(tableView.indexPathForSelectedRow != nil){
            let pos = tableView.indexPathForSelectedRow?.section ?? -1
            //Te muestra el index seleccionado de la tabla, si no esta
            //seleccionado, te muestra -1
            databaseref.child("ANIMALES").child(animalesArray[pos].key).removeValue()
        }else{
            showToast(controller: self, message: "Selecciona primero un elemento el elemento que quieras modificar.", seconds: 2)
        }
    }
    
    @IBAction func botonModificar(_ sender: Any){
        if(tableView.indexPathForSelectedRow != nil){
            //Te muestra el index seleccionado de la tabla, si no esta
            //seleccionado, te muestra -1
            let pos = tableView.indexPathForSelectedRow?.section ?? -1
            if(tfNombre.text == "") || (tfClase.text == "") || (tfNombreCientifico.text == "") {
                showToast(controller: self, message: "Los campos no pueden estar vacíos.", seconds: 2)
            }else{
                let animalDictionary=[
                    "nombre":tfNombre.text,
                    "nombreCientifico":tfNombreCientifico.text,
                    "clase":tfClase.text]
                databaseref.child("ANIMALES").child(animalesArray[pos].key).setValue(animalDictionary)
                //limpiamos los campos al modificar
                tfNombreCientifico.text = ""
                tfClase.text = ""
                tfNombre.text = ""
            }
        }else{
            showToast(controller: self, message: "Selecciona primero un elemento el elemento que quieras eliminar.", seconds: 2)
        }
        
    }
    
    @IBAction func botonAdd(_ sender: Any) {
        if(tfNombre.text == "") || (tfClase.text == "") || (tfNombreCientifico.text == "") {
            showToast(controller: self, message: "Los campos no pueden estar vacíos.", seconds: 2)
        }else{
            let animalDictionary=[
                "nombre":tfNombre.text,
                "nombreCientifico":tfNombreCientifico.text,
                "clase":tfClase.text
            ]
            databaseref.child("ANIMALES").childByAutoId().setValue(animalDictionary)
        }
        tfNombreCientifico.text = ""
        tfClase.text = ""
        tfNombre.text = ""
        
    
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tfNombre.text = animalesArray[indexPath.section].nombre
        tfNombreCientifico.text = animalesArray[indexPath.section].nombreCientifico
        tfClase.text = animalesArray[indexPath.section].clase

    }
    
    
}


