//
//  Directory.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/9/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

/// Protocol that an object can conform to, to signal that it is a directory
public protocol Directory {
    /// The `FileManager` objec that will be used when operating on this directory. The default implementation returns the default file manamger -> `FileManager.default`.
    var manager: FileManager { get }
    /// A directory has to have a path
    var path: String? { get }
    /// A directory has to have a `URL`.
    var url: URL? { get }
    
    /// Initalizer that takes a `FileManager`. The initalizer asks the file manager to create the directory if it does not exist.
    ///
    /// - Parameter manager: The `FileManager` to initalize this `Directory` with
    /// - Throws: Will throw a `DirectoryError.noURL` error if no `URL` is composed for this protocol. Will then throw an error from the `FileManager` if their was an error creating the directory.
    init(_ manager: FileManager) throws
    /// All the files in the directory
    func files<T: File>() throws -> [T]
    /// Add `File` to the directory on the current thread
    func save<T: File>(data: Data, atfile file: T) throws
    /// Remove `File` from the directory on the current thread
    func remove<T: File>(file: T) throws
    /// Add `File` to the directory on a background thread
    func save<T: File>(data: Data, atfile file: T, completion: @escaping((_ error: Error?) -> Void))
    /// Remove `File` from the directory on a background thread
    func remove<T: File>(file: T, completion: @escaping((_ error: Error?) -> Void))
    
    func exists<T: File>(file: T) throws -> Bool
    
    func create<T: File>(file: T) throws -> Bool
}


public extension Directory {
    
    
    func files<T: File>() throws -> [T] {
        guard let url = self.url else {
            return []
        }
        let urls = try self.manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
        var files = [T]()
        for url in urls {
            var retreivedFile = T(url)
            retreivedFile.directory = self
            files.append(retreivedFile)
        }
        return files
    }
    
    /// Add `File` to the directory on the current thread
    func save<T: File>(data: Data, atfile file: T) throws {
        guard let url = file.url else {
            throw DirectoryError.noURL
        }
        try data.write(to: url)
    }
    /// Remove `File` from the directory on the current thread
    func remove<T: File>(file: T) throws {
        guard let url = file.url else {
            throw DirectoryError.noURL
        }
        try self.manager.removeItem(at: url)
    }
    /// Add `File` to the directory on a background thread
    func save<T: File>(data: Data, atfile file: T, completion: @escaping((_ error: Error?) -> Void)) {
        guard let url = file.url else {
            completion(DirectoryError.noURL)
            return
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            do{
                try data.write(to: url)
                completion(nil)
            }catch{
                completion(error)
            }
        }
        
    }
    /// Remove `File` from the directory on a background thread
    func remove<T: File>(file: T, completion: @escaping((_ error: Error?) -> Void)) {
        guard let url = file.url else {
            completion(DirectoryError.noURL)
            return
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            do{
                try self.manager.removeItem(at: url)
                completion(nil)
            }catch{
                completion(error)
            }
        }
    }
    
    
    func exists<T: File>(file: T) throws -> Bool {
        var mutableFile = file
        mutableFile.directory = self
        guard let path = file.path else {
            throw DirectoryError.noPath
        }
        return self.manager.fileExists(atPath: path)
    }
    
    func create<T: File>(file: T) throws -> Bool {
        guard let path = file.path else {
            throw DirectoryError.noPath
        }
        return self.manager.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
}
