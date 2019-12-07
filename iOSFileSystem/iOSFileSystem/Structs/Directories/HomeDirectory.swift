//
//  HomeDirectory.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 12/7/19.
//  Copyright © 2019 Nomad Company. All rights reserved.
//

import Foundation

public struct HomeDirectory: Directory {
    public var manager: FileManager
    
    public var path: String? {
        return NSHomeDirectory()
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
