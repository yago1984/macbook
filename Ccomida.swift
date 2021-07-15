//
//  File.swift
//  cocinita_ios
//
//  Created by Enrique Yair Elias Martinez .
//
import Foundation
 
 class Ccomida {
    
    var IdC : String = ""
    var Apodo: String = ""
    var Nombre: String
    var Tipo: String = ""
    var UrlFotoComida: String = ""
    var Descripcion: String = ""
    var PrecioLitro: String = ""
    var Cantidad: String = ""
    var Ventapor: String = ""
    static var MiCarrito = [Ccomida]()
  
 
    init(IdC: String, Apodo: String, Nombre: String, Tipo: String, UrlFotoComida: String, Descripcion: String, PrecioLitro: String, Cantidad:String, Ventapor: String) {
        
        self.IdC = IdC
        self.Apodo = Apodo
        self.Nombre = Nombre
        self.Tipo = Tipo
        self.UrlFotoComida = UrlFotoComida
        self.Descripcion = Descripcion
        self.PrecioLitro = PrecioLitro
        self.Cantidad = Cantidad
        self.Ventapor = Ventapor
    }
}
