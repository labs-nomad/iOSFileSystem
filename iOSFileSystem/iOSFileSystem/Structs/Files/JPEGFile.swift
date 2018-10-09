//
//  JPEGFile.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/9/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

public struct JPEGFile: File {
    
    public var type: String
    
    public var directory: Directory?
    
    public var name: String
    
    public var hashValue: Int {
        return self.path?.hashValue ?? 0
    }
    
    public init(_ url: URL) {
        self.type = url.pathExtension
        self.name = url.pathComponents.last ?? ""
    }
    
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    
    static public  func == (lhs: JPEGFile, rhs: JPEGFile) -> Bool {
        return lhs.path == rhs.path
    }
    
}