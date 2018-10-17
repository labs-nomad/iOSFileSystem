//
//  ByteFormatters.swift
//  iOSFileSystem
//
//  Created by Nomad Company on 10/17/18.
//  Copyright © 2018 Nomad Company. All rights reserved.
//

import Foundation

/// Struct that vends different `ByteCountFormatter` configured to format bytes into different human readable formats (GB, MB, KB)
public struct ByteFormatters {
    
    /// The `ByteCountFormatter` that will format bytes as MB
    public let mbFormatter: ByteCountFormatter
    /// The `ByteCountFormatter` that will format bytes as GB
    public let gbFormatter: ByteCountFormatter
    /// The `ByteCountFormatter` that will format bytes as KB
    public let kbFormatter: ByteCountFormatter
    
    /// Initalizer that sets up all the different formatters.
    public init() {
        //Make the mb formatter
        self.mbFormatter = ByteCountFormatter()
        self.mbFormatter.allowedUnits = .useMB
        self.mbFormatter.countStyle = .file
        self.mbFormatter.includesUnit = true
        
        //Make the gb formatter
        self.gbFormatter = ByteCountFormatter()
        self.gbFormatter.allowedUnits = .useGB
        self.gbFormatter.countStyle = .file
        self.gbFormatter.includesUnit = true
        
        //Make the kb formatter
        self.kbFormatter = ByteCountFormatter()
        self.kbFormatter.allowedUnits = .useKB
        self.kbFormatter.countStyle = .file
        self.kbFormatter.includesUnit = true
        
    }
    
    
}
