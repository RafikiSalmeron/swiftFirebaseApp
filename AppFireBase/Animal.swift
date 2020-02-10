//
//  Animal.swift
//  AppFireBase
//
//  Created by dani on 06/02/2020.
//  Copyright © 2020 dani. All rights reserved.
//

import Foundation

class Animal{
    var key: String
    var nombre: String
    var nombreCientifico: String
    var clase: String
    
    init(nombre:String, nombreCientifico:String,clase:String){
        self.key=""
        self.nombre=nombre
        self.nombreCientifico=nombreCientifico
        self.clase=clase
    }
    
    init(key:String, nombre:String, nombreCientifico:String,clase:String){
        self.key=key
        self.nombre=nombre
        self.nombreCientifico=nombreCientifico
        self.clase=clase
    }
    
    
    
}
