//
//  Talk5Manager.swift
//  Everything
//
//  Created by Fuxin Bi on 6/2/2023.
//

import Foundation
import CoreLocation
import Alamofire
import CoreImage
import CoreImage.CIFilterBuiltins

protocol Talk5ManagerDelegate {
    func didUpdateTalk5(_ talk5Manager: Talk5Manager, talk5: Talk5Model)
    func didFailWithError(error: Error)
}

struct Talk5Manager {
    let talk5URL = "https://qa-talk5api.azurewebsites.net/api/mobile/auth"
    
    var delegate: Talk5ManagerDelegate?
    
    let context = CIContext()
    
    func fetchTalk5() {
        let urlString = "\(talk5URL)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // prepare json data
        let parameters = ["grant_type": "password",
                          "accessCode": "sample255",
                          "password": "password"]
        
        AF.request("https://qa-talk5api.azurewebsites.net/api/mobile/auth", method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default
        ).responseDecodable(of: Talk5Data.self) { response in
            switch response.result{
            case .success(let talk5Data):
                let image = generateQRCode(from: talk5Data.user_qrcode)
                let talk5Model = Talk5Model(fullName: talk5Data.full_name, qrcode: image)
                self.delegate?.didUpdateTalk5(self, talk5: talk5Model)
                break
            case .failure(_):
                print("Failed AF Request")
                break
            }
        }
    }


//    
//    func parseJSON(_ talk5Data: Data) -> Talk5Model? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(Talk5Data.self, from: talk5Data)
//            let fullName = decodedData.full_name
//            
//            let talk5 = Talk5Model(fullName: fullName, qrcode: qrcode)
//            return talk5
//            
//        } catch {
//            delegate?.didFailWithError(error: error)
//            return nil
//        }
//    }
    
    
    /*
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    */
    
    private func generateQRCode(from text: String) -> UIImage {
        
        var qrImage = UIImage(systemName: "xmark.circle") ?? UIImage()
        let data = Data(text.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 2, y: 2)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            if let image = context.createCGImage(
                outputImage,
                from: outputImage.extent) {
                qrImage = UIImage(cgImage: image)
            }
        }
        return qrImage
    }
    
    
}
