//
//  ViewController.swift
//  DCLoadingV
//
//  Created by JunWin on 2019/9/9.
//  Copyright © 2019 freeWorld. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _vc = self
        navigationItem.title = "全局hud"
        
        DCLoadingV.Showing(false)
        MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "ok", timeInterval: 3, queue: .main, repeats: true, atOnce: false) {
            DCLoadingV.ShowMes("加载完成\n\(String.randomStr(len: 7))")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 99
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c")
        cell!.backgroundColor = UIColor.randomColor
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    @IBOutlet weak var tv: UITableView!
}

extension UIColor {
    //返回随机颜色
    open class var randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
