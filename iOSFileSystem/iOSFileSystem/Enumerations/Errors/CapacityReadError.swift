//
//  CapacityReadError.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/17/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

import Foundation


/// Error enumeration that can be throws when reading various disk sizes from the `DeviceStorage` Struct
///
/// - noAttribute: Either the `FileAttributeKey.systemSize` key did not return a value or it could not be cast as an `Int64`
public enum CapacityReadError: Error {
    case noAttribute
}
