//
//  DCLoadingV.swift
//
//
//  Created by nn on 2017/10/24.
//
//

import UIKit

private var loadingV: DCLoadingV!//转圈
private var topMesV: DCLoadingV!//主要用于显示提示, 不会受DCLoadingV.Disapear()的影响
private var blankV: DCLoadingV!//UITableView无数据展示页面

class DCLoadingV: UIView {
    
    /*
     DCLoadingV.Showing() 显示加载中视图
     DCLoadingV.ShowMes(mes, after: 1.5)  显示提示信息, 1.5秒后自动隐藏
     DCLoadingV.Disapear() 隐藏加载中视图
     */
    
    @objc class func Showing(_ isCanDo: Bool = true) {//true 加载时能操作
        DCLoadingV.bitInit()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            blankV.removeFromSuperview()
            if loadingV.alpha == 1 {
                return
            }
            
            loadingV.addAnimat()
            loadingV.isUserInteractionEnabled = !isCanDo
            
            loadingV.nameV.alpha = 0
            loadingV.hudV.alpha = 1
            loadingV.alpha = 1
            loadingV.frame = winBounds
            
            _Window().addSubview(loadingV)
        }
    }
    
    @objc class func Disapear() {//取消显示
        DCLoadingV.bitInit()
        
        DispatchQueue.main.async {
            loadingV.alpha = 0
            loadingV.removeFromSuperview()
            loadingV.removeAnimat()
            DCLoadingV.BlankDo()
        }
    }
    
    
    @objc class func BlankDo() {//无数据
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {//特殊无需此操作VC
            if "ChatDetailVC SeeDoctorOffLineVC SeeDoctorManagerVC SeeDoctorOnLineVC".contains("\(type(of: _vc!))") {
                return
            }
            
            blankV.isUserInteractionEnabled = false
            blankV.hudV.alpha = 0
            blankV.nameV.alpha = 1
            blankV.nameV.backgroundColor = UIColor.clear
            blankV.blurV.alpha = 0
            blankV.alpha = 0
            
            blankV.nameL.text = "这里空空如也.."
            blankV.nameL.textColor = UIColor.lightGray
            blankV.nameL.font = UIFont.systemFont(ofSize: 15)
            blankV.imgV.image = UIImage.init(named: "无数据")
            
            var inV = _vc.view
            for vv in _vc.view.subviews {
                if vv.isKind(of: UITableView.self) && vv.frame.width >= winW*0.75 && vv.frame.height >= winH*0.5 {
                    inV = vv
                }
            }
            
            if inV!.isKind(of: UITableView.self) {
                let tv = inV as! UITableView
                if tv.visibleCells.isEmpty {
                    blankV.frame = CGRect(x: 0, y: 0, width: inV!.frame.width, height: inV!.frame.width)
                    inV!.addSubview(blankV)
                    UIView.animate(withDuration: 0.2, animations: {
                        blankV.alpha = 1
                    })
                }
            }
        }
    }
    
    
    @objc class func ShowMes(_ mes: String?) {
        DCLoadingV.ShowMes(mes, after: 2)
    }
    
    @objc class func ShowMes(_ mes: String?, after: Double) {//显示提示
        let mes = mes ?? ""
        print("打印消息", mes)
        
        if mes != "" {
            DCLoadingV.Disapear()
            
            DispatchQueue.main.async {
                topMesV.isUserInteractionEnabled = false
                topMesV.hudV.alpha = 0
                topMesV.nameV.alpha = 1
                topMesV.alpha = 1
                
                topMesV.nameL.text = mes
                topMesV.frame = CGRect(x: 0, y: 0, width: winW/2.1, height: winW/2.1)
                topMesV.center = CGPoint.init(x: winW/2, y: winH/2)
                topMesV.nameL.font = UIFont.boldSystemFont(ofSize: 15)
                _Window().addSubview(topMesV)
                
                if topMesV.lastMesTime + after > DispatchTime.now() {
                    MCGCDTimer.shared.cancleTimer(WithTimerName: "topMesV")
                }
                MCGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "topMesV", timeInterval: after, queue: DispatchQueue.main, repeats: false, atOnce: false) {
                    topMesV.alpha = 0
                    topMesV.removeFromSuperview()
                }
                topMesV.lastMesTime = DispatchTime.now()
            }
        }
    }
    
    
    private class func bitInit() {//初始化
        if loadingV == nil {
            DispatchQueue.main.async {
                loadingV = (Bundle.main.loadNibNamed("DCLoadingV", owner: nil, options: nil)?.last as! DCLoadingV)
            }
        }
        
        if topMesV == nil {
            DispatchQueue.main.async {
                topMesV = (Bundle.main.loadNibNamed("DCLoadingV", owner: nil, options: nil)?.last as! DCLoadingV)
            }
        }
        
        if blankV == nil {
            DispatchQueue.main.async {
                blankV = (Bundle.main.loadNibNamed("DCLoadingV", owner: nil, options: nil)?.last as! DCLoadingV)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        alpha = 0
        decotate(textC: nil, cornerR: 10, borderC: nil, borderW: nil)
        
        block1.decotate(textC: nil, cornerR: 7.5, borderC: nil, borderW: nil)
        block2.decotate(textC: nil, cornerR: 7.5, borderC: nil, borderW: nil)
        block3.decotate(textC: nil, cornerR: 7.5, borderC: nil, borderW: nil)
    }
    
    private func addAnimat() {
        let vs = [block1, block2, block3]
        for idx in 0..<vs.count {
            UIView.animate(withDuration: 0.4, delay: 0.4*(Double(idx)/2), options: [.repeat, .autoreverse], animations: {
                vs[idx]!.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            })
        }
    }
    
    private func removeAnimat() {
        let vs = [block1, block2, block3]
        for idx in 0..<vs.count {
            vs[idx]!.transform = CGAffineTransform.identity
        }
    }
    
    @IBOutlet weak var nameV: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var blurV: UIVisualEffectView!
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var hudV: UIView!
    @IBOutlet weak var block1: UIImageView!
    @IBOutlet weak var block2: UIImageView!
    @IBOutlet weak var block3: UIImageView!
    
    var lastMesTime = DispatchTime.now()
    
}


//MARK: 工具
class MCGCDTimer {
    
    func scheduledDispatchTimer(WithTimerName name: String?, timeInterval: Double, queue: DispatchQueue, repeats: Bool, atOnce: Bool, action: @escaping()->()) {//atOnce是否立即执行
        if name == nil {
            return
        }
        var timer = timerContainer[name!]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        
        timer?.schedule(deadline: .now()+(atOnce ? 0 : timeInterval), repeating: timeInterval, leeway: DispatchTimeInterval.milliseconds(100))//精度0.1秒
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats == false {
                self?.cancleTimer(WithTimerName: name)
            }
        })
    }
    
    func cancleTimer(WithTimerName name: String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }
    
    func isExistTimer(WithTimerName name: String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }
    
    static let shared = MCGCDTimer()
    lazy var timerContainer = [String: DispatchSourceTimer]()
    
}


func _Window() -> UIWindow {//获取最顶层可用Window
    for win in UIApplication.shared.windows.reversed() {
        if win.isOpaque && !win.isHidden && win.alpha > 0 && win.isKind(of: NSClassFromString("UITextEffectsWindow")!.self) {
            return win
        }
    }
    return UIApplication.shared.keyWindow!
}

extension UIView {
    func decotate(textC: UIColor?, cornerR: CGFloat?, borderC: UIColor?, borderW: CGFloat?) {//圆角
        self.layer.masksToBounds = true
        if textC != nil {
            if self.isKind(of: UIButton.self) {
                (self as! UIButton).setTitleColor(textC, for: .normal)
            }
            if self.isKind(of: UILabel.self) {
                (self as! UILabel).textColor = textC
            }
        }
        if cornerR != nil {
            self.layer.cornerRadius = cornerR!
        }
        if borderC != nil {
            self.layer.borderColor = borderC!.cgColor
        }
        if borderW != nil {
            self.layer.borderWidth = borderW!
        }
    }
}

extension String {
    static func randomStr(len: Int) -> String {
        let strs = "😏🥳🤩😝🙃🦑🐢🦉🦟🦎🦞机?=@#¥%&*字符串LHL这段时间研究了下弹幕的原理,并用swift实现了下.以此来记录.实现效果如下"
        var ranStr = ""
        for _ in 0..<len {
            ranStr.append(strs[strs.index(strs.startIndex, offsetBy: Int.random(in: 0..<strs.count))])
        }
        return ranStr
    }
}

var _vc: UIViewController!

let winBounds = UIScreen.main.bounds
let winSize = winBounds.size
let winW  = winSize.width
let winH = winSize.height
