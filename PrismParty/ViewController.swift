import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    var displayLink: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target: self, selector: #selector(ViewController.onFrame))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        motionManager.startDeviceMotionUpdates()
    }
    
    func onFrame() {
        guard let deviceMotion = motionManager.deviceMotion else { return }
        // http://nshipster.com/cmdevicemotion/
        let rotation = atan2(deviceMotion.gravity.x, deviceMotion.gravity.y) / (2 * M_PI) + 0.5
        
        self.view.backgroundColor = UIColor(hue: CGFloat(rotation), saturation: 1, brightness: 1, alpha: 1)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

