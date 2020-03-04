//
//  File.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/9/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

import Foundation

public protocol File: Hashable {
    var data: Data? { get }
    var type: String { get }
    var directory: Directory? { get set }
    var path: String? { get }
    var url: URL? { get }
    var name: String { get }
    init(_ url: URL)
    init(name: String, type: String)
    func store(_ data: Data) throws
}

public extension File {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.path ?? "")
    }
    
    var path: String? {
        let url = self.directory?.url?.appendingPathComponent(self.name).appendingPathExtension(self.type)
        return url?.path
    }
    
    var url: URL? {
        guard let path = self.path else {
            return nil
        }
        let url = URL(fileURLWithPath: path, isDirectory: false)
        return url
    }
    
    var data: Data? {
        guard let url = self.url else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    func store(_ data: Data) throws {
        guard let url = self.url else {
            throw DirectoryError.noURL
        }
        
        try data.write(to: url)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.path == rhs.path
    }
    
}
