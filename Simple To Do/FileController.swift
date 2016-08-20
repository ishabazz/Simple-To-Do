//
//  FileController.swift
//  Simple To Do
//
//  Created by Demo on 8/19/16.
//  Copyright © 2016 Illuminated Bits LLC. All rights reserved.
//

import Foundation


class FileController{
    
    
    class func  documentsDirctory() -> URL?{return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first}

    class func filePath() -> URL? {
        
       let path =   FileController.documentsDirctory()?.appendingPathComponent("list", isDirectory: false).appendingPathExtension("data")
        
        return path
    }
    
}
