//
//  DeviceStorage.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/17/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

import Foundation


/// Struct that lets you retreive storage capacity information about your device and App
public struct DeviceStorage {
    //MARK: Properties
    let manager: FileManager
    
    public typealias AppSizeResults =  (formattedString: String, totalUnformattedBytes: Int64)?
    
    /// Type alias for the completion when calculating the size of the app. The calculation needs to happen on a different thread.
    public typealias CalculateAppSizeCompletion = (_ tuple: AppSizeResults, _ error: Error?) -> Void
    //MARK: Init
    /// Initalizer that takes a `FileManager`. The `FileManager` will be used in the calcualtions
    ///
    /// - Parameter manager: The `FileManager` you want the struct to use. Defaults to `FileManager.default`
    public init(_ manager: FileManager = FileManager.default) {
        //Assign the manager
        self.manager = manager
        
    }
    
    //MARK: Functions
    /// Function that calculates the capacity of the device
    ///
    /// - Parameter formatter: The `ByteCountFormatter` you want to use. Defaults to the `mbFormatter` property of the `ByteFormatters` struct.
    /// - Returns: A tuple with the human readable string calcualted by the `ByteCountFormatter` and the raw balue of bytes represented as an `Int64`
    /// - Throws: Can throw a file system error or a `CapacityReadError`
    public func diskCapacity(_ formatter: ByteCountFormatter = ByteFormatters().mbFormatter) throws -> (string: String, intValue: Int64) {
        let attributes = try self.manager.attributesOfFileSystem(forPath: NSHomeDirectory())
        guard let space = attributes[FileAttributeKey.systemSize] as? Int64 else {
            throw CapacityReadError.noAttribute
        }
        return (string: formatter.string(fromByteCount: space), intValue: space)
    }
    
    /// Function that calcualtes the free space on the device
    ///
    /// - Parameter formatter: formatter: The `ByteCountFormatter` you want to use. Defaults to the `mbFormatter` property of the `ByteFormatters` struct.
    /// - Returns: A tuple with the human readable string calcualted by the `ByteCountFormatter` and the raw balue of bytes represented as an `Int64`
    /// - Throws: Can throw a file system error or a `CapacityReadError`
    public func freeDiskSpace(_ formatter: ByteCountFormatter = ByteFormatters().mbFormatter) throws -> (string: String, intValue: Int64) {
        let attributes = try self.manager.attributesOfFileSystem(forPath: NSHomeDirectory())
        guard let space = attributes[FileAttributeKey.systemFreeSize] as? Int64 else {
            throw CapacityReadError.noAttribute
        }
        return (string: formatter.string(fromByteCount: space), intValue: space)
    }
    
    /// Function that calcualtes the used disk space on the device. Returns the difference of total space minus free space
    ///
    /// - Parameter formatter: formatter: The `ByteCountFormatter` you want to use. Defaults to the `mbFormatter` property of the `ByteFormatters` struct.
    /// - Returns: A tuple with the human readable string calcualted by the `ByteCountFormatter` and the raw balue of bytes represented as an `Int64`
    /// - Throws: Can throw a file system error or a `CapacityReadError`
    public func usedDiskSpace(_ formatter: ByteCountFormatter = ByteFormatters().mbFormatter) throws -> (string: String, intValue: Int64) {
        let attributes = try self.manager.attributesOfFileSystem(forPath: NSHomeDirectory())
        guard let freeSpace = attributes[FileAttributeKey.systemFreeSize] as? Int64, let totalSpace = attributes[FileAttributeKey.systemSize] as? Int64 else {
            throw CapacityReadError.noAttribute
        }
        let usedSpace = totalSpace - freeSpace
        return (string: formatter.string(fromByteCount: usedSpace), intValue: usedSpace)
    }
    
    /// Function that calcualtes the disk space the Apps documents and libraries directories use up. It's Async because if the recursive tree it large it will take a while. If you know that there are not many sub folders you could get away with the equivelent provided sync function.
    ///
    /// - Parameter formatter: formatter: The `ByteCountFormatter` you want to use. Defaults to the `mbFormatter` property of the `ByteFormatters` struct.
    /// - Returns: A tuple with the human readable string calcualted by the `ByteCountFormatter` and the raw balue of bytes represented as an `Int64`
    /// - Throws: Can throw a file system error or a `CapacityReadError`
    public func appDiskSpace(_ formatter: ByteCountFormatter = ByteFormatters().mbFormatter, completion: @escaping(CalculateAppSizeCompletion)) throws  {

        let documentsDirectory = try DocumentsDirectory(self.manager)
        let libraryDirectory = try LibraryDirectory(self.manager)
        guard let documentsURL = documentsDirectory.url, let libraryURL = libraryDirectory.url else {
            throw DirectoryError.noPath
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            do{
                let documentsSize = try self.manager.allocatedSizeOfDirectory(at: documentsURL)
                let librarySize = try self.manager.allocatedSizeOfDirectory(at: libraryURL)
                let totalSize: Int64 = Int64(documentsSize + librarySize)
                let tupel = (formatter.string(fromByteCount: totalSize), totalSize)
                completion(tupel, nil)
            }catch{
                completion(nil, error)
            }
        }
    }
    
    public func appDiskSpace(_ formatter: ByteCountFormatter = ByteFormatters().mbFormatter) throws -> AppSizeResults {
        let documentsDirectory = try DocumentsDirectory(self.manager)
        let libraryDirectory = try LibraryDirectory(self.manager)
        guard let documentsURL = documentsDirectory.url, let libraryURL = libraryDirectory.url else {
            throw DirectoryError.noPath
        }
        let documentsSize = try self.manager.allocatedSizeOfDirectory(at: documentsURL)
        let librarySize = try self.manager.allocatedSizeOfDirectory(at: libraryURL)
        let totalSize: Int64 = Int64(documentsSize + librarySize)
        let formattedString = formatter.string(fromByteCount: totalSize)
        return (formattedString, totalSize)
    }

    
}
