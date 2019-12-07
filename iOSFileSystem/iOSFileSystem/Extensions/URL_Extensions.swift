//
//  URL_Extensions.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 12/7/19.
//  Copyright © 2019 Nomad Company. All rights reserved.
//

import Foundation

public extension URL {

    func regularFileAllocatedSize() throws -> UInt64 {
        let resourceValues = try self.resourceValues(forKeys: FileManager.allocatedSizeResourceKeys)

        // We only look at regular files.
        guard resourceValues.isRegularFile ?? false else {
            return 0
        }

        // To get the file's size we first try the most comprehensive value in terms of what
        // the file may use on disk. This includes metadata, compression (on file system
        // level) and block size.
        // In case totalFileAllocatedSize is unavailable we use the fallback value (excluding
        // meta data and compression) This value should always be available.
        return UInt64(resourceValues.totalFileAllocatedSize ?? resourceValues.fileAllocatedSize ?? 0)
    }
}
