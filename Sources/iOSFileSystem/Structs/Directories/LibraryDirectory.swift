//
//  LibraryDirectory.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/9/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

import Foundation

public struct LibraryDirectory: Directory {
    public var manager: FileManager
    
    public var path: String? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths.first
    }
    
    public var url: URL? {
        guard let path = self.path else {
            return nil
        }
        let url = URL(fileURLWithPath: path, isDirectory: true)
        return url
    }
    
    public init(_ manager: FileManager) throws {
        self.manager = manager
        guard let url = self.url else {
            throw DirectoryError.noURL
        }
        try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        
    }
    
}
