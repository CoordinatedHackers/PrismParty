import UIKit
import CoreMotion
import AudioToolbox.AudioServices

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    var displayLink: CADisplayLink!
    var latched = false
    var latchedRotation: CGFloat?

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
        
        if deviceMotion.userAcceleration.z > 1.5 && !latched {
            latched = true
            latchedRotation = CGFloat(rotation)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            print("rotation: \(rotation)")
        }

        if let latchedRotation = latchedRotation {
            self.view.backgroundColor = UIColor(hue: latchedRotation, saturation: 1, brightness: 1, alpha: 1)
        } else {
            self.view.backgroundColor = UIColor(hue: CGFloat(rotation), saturation: 1, brightness: 1, alpha: 1)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

