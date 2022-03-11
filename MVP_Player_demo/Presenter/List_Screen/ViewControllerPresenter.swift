//
//  ViewControllerPresenter.swift
//  MVP_Player_demo
//
//  Created by Adsum MAC 1 on 05/01/2022.
//


import UIKit

protocol playListDelegate : AnyObject{
    func presentPlayList(videos:[CategoriesModel])
    func goToNextVC(vc:UIViewController)
}

typealias playListVCDelegate = playListDelegate & UIViewController
class playListPresenter{
    
    var delegate : playListDelegate?
    
    func getPlayList(){
        if let path = Bundle.main.path(forResource: "playlist", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONDecoder().decode(viewModel.self, from: data)
                print(jsonResult)
                self.delegate?.presentPlayList(videos: jsonResult.categories ?? [])
              } catch {
                 print("data not decode")
              }
        }else{
            print("path not found")
        }

    }
    func setViewdelegate(delegate:playListVCDelegate){
        self.delegate = delegate
    }
}
