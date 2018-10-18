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
    
    /// Function that calcualtes the disk space the Apps documents and libraries directories use up.
    ///
    /// - Parameter formatter: formatter: The `ByteCountFormatter` you want to use. Defaults to the `mbFormatter` property of the `ByteFormatters` struct.
    /// - Returns: A tuple with the human readable string calcualted by the `ByteCountFormatter` and the raw balue of bytes represented as an `Int64`
    /// - Throws: Can throw a file system error or a `CapacityReadError`
    public func appDiskSpace(_ formatter: ByteCountFormatter = ByteFormatters().mbFormatter) throws -> (string: String, intValue: Int64) {
        let documentsDirectory = try DocumentsDirectory(self.manager)
        let libraryDirectory = try LibraryDirectory(self.manager)
        guard let documentsPath = documentsDirectory.path, let libraryPath = libraryDirectory.path else {
            throw DirectoryError.noPath
        }
        let documentsSize = try self.sizeOfFolder(documentsPath)
        let librarySize = try self.sizeOfFolder(libraryPath)
        let totalSize = documentsSize + librarySize
        return (string: formatter.string(fromByteCount: totalSize), intValue: totalSize)
    }
    
    
    
    internal func sizeOfFolder(_ folderPath: String) throws -> Int64 {
        let contents = try self.manager.contentsOfDirectory(atPath: folderPath)
        var folderSize: Int64 = 0
        for content in contents {
            do {
                let fullContentPath = folderPath + "/" + content
                let fileAttributes = try self.manager.attributesOfItem(atPath: fullContentPath)
                let folderAttributes = try self.manager.attributesOfFileSystem(forPath: fullContentPath)
                folderSize += fileAttributes[FileAttributeKey.size] as? Int64 ?? 0
                folderSize += folderAttributes[FileAttributeKey.size] as? Int64 ?? 0
            } catch _ {
                continue
            }
        }
        return folderSize
    }
    
}
