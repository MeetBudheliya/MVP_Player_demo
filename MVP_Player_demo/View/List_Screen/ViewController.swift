//
//  ViewController.swift
//  MVP_Player_demo
//
//  Created by Adsum MAC 1 on 05/01/2022.
//

import UIKit
import AVKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, playListDelegate, AVPlayerViewControllerDelegate {
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private let presenter = playListPresenter()
    private var videoList = [CategoriesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Playlist"
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.presenter.setViewdelegate(delegate: self)
        self.presenter.getPlayList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
        
    }
    
    //presenter delegate
    func presentPlayList(videos: [CategoriesModel]) {
        self.videoList = videos
        self.tableView.reloadData()
    }
    
    func goToNextVC(vc: UIViewController) {
        if #available(iOS 13.0, *) {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "")
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.videoList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.videoList[section].name
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoList[section].videos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let cellData = self.videoList[indexPath.section].videos?[indexPath.row]
        var stringComponents = cellData?.sources?.first?.components(separatedBy: "/")
        stringComponents?.removeLast()
        var urlStr = ""
        for i in stringComponents! {
            urlStr.append("\(i)/")
            if stringComponents?.last == i{
                urlStr.append(cellData?.thumb ?? "")
            }
        }
        cell.title.text = cellData?.title
        cell.subtitle.text = cellData?.subtitle
        cell.thumb.layer.cornerRadius = 10
        let newString = urlStr.replacingOccurrences(of: "http", with: "https", options: .caseInsensitive, range: nil)
        if let url = URL(string: newString){
            DispatchQueue.main.async {
                do{
                    let imgData = try Data(contentsOf: url)
                    cell.thumb?.image = UIImage(data: imgData)
                }catch{
                    if #available(iOS 13.0, *) {
                        cell.thumb.image = UIImage(systemName: "airpodspro")
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }else{
            if #available(iOS 13.0, *) {
                cell.thumb.image = UIImage(systemName: "airpodspro")
            } else {
                // Fallback on earlier versions
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlStr = self.videoList[indexPath.section].videos?[indexPath.row].sources?.first ?? ""
        let newString = urlStr.replacingOccurrences(of: "http", with: "https", options: .caseInsensitive, range: nil)
        if let url = URL(string: newString){
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

