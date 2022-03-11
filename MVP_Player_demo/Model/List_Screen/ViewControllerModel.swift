//
//  ViewControllerModel.swift
//  MVP_Player_demo
//
//  Created by Adsum MAC 1 on 05/01/2022.
//

struct viewModel: Codable {
    let categories : [CategoriesModel]?
}

struct CategoriesModel: Codable {
    let name : String?
    let videos : [VC_Model]?
}

struct VC_Model: Codable{
    let description : String?
    let sources : [String]?
    let subtitle : String?
    let thumb : String?
    let title : String?
}
