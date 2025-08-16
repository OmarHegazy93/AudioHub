//
//  ParsingError.swift
//  AudioHub
//
//  Created by Omar Hegazy on 16/08/2025.
//

import Foundation

/// Enum representing possible parsing errors
public enum ParsingError: Error {
    /// Error indicating invalid data with the associated underlying error
    case invalidData(Error)
}
