//
//  FirstViewController.swift
//  GOC
//
//  Created by Patrick Pannuto on 7/19/16.
//  Copyright © 2016 CubeWorks. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var gocFrequencyTextField: UITextField!
    @IBOutlet weak var gocAddressLabel: UILabel!
    @IBOutlet weak var gocAddressTextField: UITextField!
    @IBOutlet weak var gocDataLabel: UILabel!
    @IBOutlet weak var gocDataTextField: UITextField!
    @IBOutlet weak var gocMessageLabel: UILabel!
    @IBOutlet weak var gocVersionSegmentedControl: UISegmentedControl!

    var propertyObservers = [NSObjectProtocol]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let defaults = NSUserDefaults.standardUserDefaults()
        gocFrequencyTextField.text = String(defaults.floatForKey("goc_frequency_slow"))
        gocAddressTextField.text = defaults.objectForKey("goc_address") as? String ?? "AA"
        gocDataTextField.text = defaults.objectForKey("goc_data") as? String ?? "12345678"
        gocVersionSegmentedControl.selectedSegmentIndex = defaults.integerForKey("goc_protocol_version") - 1

        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        let observer = notificationCenter.addObserverForName(UITextFieldTextDidChangeNotification, object: nil, queue: mainQueue) { (notification) -> Void in
            self.update()
        }

        self.propertyObservers.append(observer)

        updateMessage()

        debugPrint(self)
        debugPrint("viewDidLoad complete")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        let notificationCenter = NSNotificationCenter.defaultCenter()
        for observer in self.propertyObservers {
            notificationCenter.removeObserver(observer)
        }
    }

    func update() {
        updateMessage()
        updateDefaults()
    }

    func updateDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let freq = (gocFrequencyTextField.text! as NSString).floatValue
        let address = gocAddressTextField.text! as NSString
        let data = gocDataTextField.text! as NSString
        let version = gocVersionSegmentedControl.selectedSegmentIndex + 1

        defaults.setFloat(freq, forKey: "goc_frequency_slow")
        defaults.setObject(address, forKey: "goc_address")
        defaults.setObject(data, forKey: "goc_data")
        defaults.setInteger(version, forKey: "goc_protocol_version")
    }

    func validateAddressText() -> Bool {
        let address = Int(gocAddressTextField.text!, radix:16)
        debugPrint(address)

        if (address == nil) || (address < 0) || (address > 255) {
            gocAddressLabel.textColor = UIColor.redColor()
            return false
        } else if (gocAddressTextField.text! as NSString).length != 2 {
            gocAddressLabel.textColor = UIColor.orangeColor()
            return false
        } else {
            gocAddressLabel.textColor = UIColor.blackColor()
            return true
        }
    }

    func validateDataText() -> Bool {
        let data = Int(gocDataTextField.text!, radix: 16)
        debugPrint(data)

        if (data == nil) || (data < 0) || (data > 0xffffffff) {
            gocDataLabel.textColor = UIColor.redColor()
            return false
        } else if (gocDataTextField.text! as NSString).length != 8 {
            gocDataLabel.textColor = UIColor.orangeColor()
            return true
        } else {
            gocDataLabel.textColor = UIColor.blackColor()
            return true
        }
    }

    func updateMessage() {
        var allGood = true
        allGood = allGood && validateAddressText()
        allGood = allGood && validateDataText()

        if !allGood {
            gocMessageLabel.textColor = UIColor.redColor()
            gocMessageLabel.text = "Error building message"
        }
        gocMessageLabel.textColor = UIColor.blackColor()

        // http://stackoverflow.com/questions/30197819/given-a-hexadecimal-string-in-swift-convert-to-hex-value
        // n.b. the simpler-looking char array doesn't handle odd length strings properly

        let addrStr = gocAddressTextField.text!
        var addr = [UInt8]()
        var addrFrom = addrStr.startIndex
        while addrFrom != addrStr.endIndex {
            let to = addrFrom.advancedBy(2, limit: addrStr.endIndex)
            addr.append(UInt8(addrStr[addrFrom ..< to], radix: 16) ?? 0)
            addrFrom = to
        }

        let dataStr = gocDataTextField.text!
        var data = [UInt8]()
        var dataFrom = dataStr.startIndex
        while dataFrom != dataStr.endIndex {
            let to = dataFrom.advancedBy(2, limit: dataStr.endIndex)
            data.append(UInt8(dataStr[dataFrom ..< to], radix: 16) ?? 0)
            dataFrom = to
        };

        let payload = addr + data

        var message: [UInt8] = []
        let ret = buildInjectionMessageInterruptForGocV2(payload, message: &message)
        debugPrint("buildInjection done")
        debugPrint(ret)
        debugPrint(message)
        if ret != nil {
            gocMessageLabel.text = ret
        } else {
            var s = ""
            for b in message {
                s += String(format: "%02X", b)
            }
            gocMessageLabel.text = s
        }
    }

    func buildInjectionMessageInterruptForGocV2 (
        data: [UInt8],
        run_after: UInt8 = 1,
        inout message: [UInt8]
        ) -> String? {
        return buildInjectionMessage(data: data, run_after: run_after, memory_address: 0x78, goc_version: 2, message: &message)
    }

    func buildInjectionMessage (
        // Byte 0: Control
        chip_id_mask: UInt8 = 0xFF,    // [0:3] Chip ID Mask
        reset_request: UInt8 = 0,       //   [4] Reset Request
        chip_id_coding: UInt8 = 0,      //   [5] Chip ID coding
        is_mbus: UInt8 = 0,             //   [6] Indicated transmission is MBus message [addr+data]
        run_after: UInt8 = 0,           //   [7] Run code after programming?

        // (v1) Bytes 1,2: Chip ID
        // (v2) Bytes 1,2: Chip ID
        chip_id: UInt16 = 0,

        // (v1) Bytes 3,4: Memory Address
        // (v2) Data bytes 0-3: Memory Address
        memory_address: UInt32 = 0,

        // Data to send
        data: [UInt8] = [],

        // GOC protocol version
        goc_version: Int = 0,

        // Resulting message
        inout message: [UInt8]
        ) -> String? {
        if goc_version == 0 {
            return "Err: Bad GOC version"
        }

        var chip_id_mask = chip_id_mask;
        if chip_id_mask == 0xFF {
            if goc_version == 1 {
                chip_id_mask = 0
            } else if goc_version == 2 {
                chip_id_mask = 0xF
            }
        }

        var HEADER: [UInt8] = []

        // Control Byte
        let control = chip_id_mask |  (reset_request << 4) | (chip_id_coding << 5) | (is_mbus << 6) | (run_after << 7)
        HEADER.append(control)

        // Chip ID
        HEADER.append(UInt8(truncatingBitPattern: chip_id.bigEndian >> 8))
        HEADER.append(UInt8(truncatingBitPattern: chip_id.bigEndian))

        // Memory Address
        if goc_version == 1 {
            HEADER.append(UInt8(truncatingBitPattern: memory_address.bigEndian >> 8))
            HEADER.append(UInt8(truncatingBitPattern: memory_address))
        }

        // Program Lengh
        var length: Int32
        if data.count != 0 {
            length = Int32(data.count)
            if goc_version == 2 {
                length -= 1
            }
            if (length < 0) {
                return "Err: Bad message length"
            }
            length = length.bigEndian
        } else {
            length = 0
        }
        HEADER.append(UInt8(truncatingBitPattern: length >> 8))
        HEADER.append(UInt8(truncatingBitPattern: length))

        // Bit-wise XOR parity of header
        var header_parity: UInt8 = 0
        for byte in HEADER {
            header_parity ^= byte;
        }
        HEADER.append(header_parity)

        var DATA = data
        if data.count > 0 {
            if goc_version == 2 {
                DATA.insert(UInt8(truncatingBitPattern: memory_address >> 24), atIndex: 0)
                DATA.insert(UInt8(truncatingBitPattern: memory_address >> 16), atIndex: 0)
                DATA.insert(UInt8(truncatingBitPattern: memory_address >> 8), atIndex: 0)
                DATA.insert(UInt8(truncatingBitPattern: memory_address), atIndex: 0)
            }

            // Bit-wise XOR parity of data
            var data_parity: UInt8 = 0
            for byte in DATA {
                data_parity ^= byte
            }

            if goc_version == 1 {
                // DATA = parity + DATA
                DATA.insert(data_parity, atIndex: 0)
            } else if goc_version == 2 {
                // DATA = DATA + parity
                DATA.append(data_parity)
            }
        }

        message = HEADER + DATA
        return nil
    }
}

