//
//  PLFileProccessing.swift
//  Pods
//
//  Created by Christian Sihombing on 4/7/16.
//
//

import Foundation
import Alamofire
import KVNProgress

public class PLFileProccessing{
    
    required public init() {
        print("Init")
    }
    
    public func loadAsyncImage(url:String, completion:(UIImage)->()){
        KVNProgress.show()
        //set image name
        let imageNameArr = url.characters.split{$0 == "/"}.map(String.init)
        //        print("url \(url) \nImage Arr \(imageNameArr)")
        let imageName = imageNameArr[imageNameArr.count-1]
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let imagePath = paths.stringByAppendingString("/\(imageName)")
        let checkValidation = NSFileManager.defaultManager()
        
        //check if image is exist
        if (checkValidation.fileExistsAtPath(imagePath)){
            KVNProgress.dismiss()
            //image cached
            let image =  UIImage(contentsOfFile: imagePath)
            if image != nil {
                completion(image!)
            }
            
        }else{
            //load image and save to cache
            Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
                KVNProgress.dismiss()
                if data?.length > 0{
                    let image = UIImage(data: data! as NSData,scale: 0.5)
                    
                    let ok = NSFileManager.defaultManager().createFileAtPath(imagePath, contents: data, attributes: nil)
                    if !ok{
                        print("error save cache")
                        KVNProgress.showErrorWithStatus("error save cache")
                    }
                    if image != nil {
                        completion(image!)
                    }
                }
            }
        }
    }
    
    public func uploadSyncFile(url:String,data:NSData,userId:String,view:UIView,completion:(imgUrl:String)->()){
        // init paramters Dictionary
        let param = [
            "id" : userId
        ]
        
        //        let urlRequest = urlRequestWithComponents(url, imageData: data,param: param)
        let urlRequest = urlRequestWithComponents(url, parameters: param, imageData: data)
        print("urlRequest \(urlRequest.0)")
        KVNProgress.showProgress(0.0, status: "Uploading..", onView: view)
        Alamofire.upload(urlRequest.0, data: urlRequest.1)
            .authenticate(user: "admin", password: "1234")
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                dispatch_async(dispatch_get_main_queue()){
                    let percent = (CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite))
                    print("percent \(percent)")
                    KVNProgress.updateProgress(percent, animated: true)
                }
            }
            .responseJSON{ response in
                switch response.2 {
                case .Success:
                    if let jsonData  = response.2.value{
                        if response.1?.statusCode == 200{
                            KVNProgress.showSuccessWithStatus(jsonData.objectForKey("message") as! String, onView: view)
                            print("json data \(jsonData)")
                            completion(imgUrl: jsonData.objectForKey("avatar") as! String)
                        }else{
                            print(jsonData)
                            KVNProgress.dismiss()
                            let msg = jsonData.objectForKey("error") as! String
                            KVNProgress.showErrorWithStatus(msg, onView: view)
                        }
                    }
                    break;
                case .Failure(let error):
                    print(error)
                    // Error response
                    KVNProgress.showErrorWithStatus("Please check your internet connection.", onView: view)
                    break;
                }
        }
        
        
    }
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"image\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
}