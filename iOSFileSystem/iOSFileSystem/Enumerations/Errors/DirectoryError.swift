//
//  DirectoryError.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/9/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

/// Errors that can be thrown when working with an object that conforms to the `Directory` protocol
///
/// - noURL: There wa no URL for the directory
/// - noPath: There was no path for the directory
public enum  DirectoryError: Error {
    case noURL
    case noPath
}
