//
//  Compressor.swift
//  Solar
//
//  Created by Andrei Marincas on 1/31/18.
//  Copyright © 2018 Andrei Marincas. All rights reserved.
//

import Foundation
import Compression
import UIKit

class Compressor {
    
    func decode(dataAtURL url: URL, bytesCount expectedBytesCountAfterDecode: Int) -> Data? {
        guard let inputData = try? Data(contentsOf: url) else {
            NSLog("Error: Couldn't read compressed data at path: " + url.path)
            return nil
        }
        let originalBytesCount = expectedBytesCountAfterDecode
        let dstBuffer = malloc(originalBytesCount * MemoryLayout<UInt8>.stride)
        guard let dstBufferPtr = dstBuffer?.bindMemory(to: UInt8.self, capacity: originalBytesCount) else {
            NSLog("Error: Couldn't allocate destination buffer for decode.")
            return nil
        }
        NSLog("Ready to decode: " + url.path)
        let result = inputData.withUnsafeBytes { (inputDataPtr: UnsafePointer<UInt8>) -> Data? in
            NSLog("Decoding...")
            let decompressedSize = compression_decode_buffer(dstBufferPtr, originalBytesCount, inputDataPtr, inputData.count, nil, COMPRESSION_LZFSE)
            if decompressedSize == originalBytesCount {
                let decompressedData = Data(bytesNoCopy: dstBuffer!, count: decompressedSize, deallocator: .free)
                NSLog("Decode completed successfully!")
                return decompressedData
            }
            NSLog("Error: Failed to decode! decompressed_size: \(decompressedSize), expected: \(originalBytesCount) bytes")
            return nil
        }
        return result
    }
    
    func split(_ data: Data, usingMapAtURL mapURL: URL) -> [UIImage]? {
        guard let mapFile = try? String(contentsOf: mapURL, encoding: .utf8) else {
            NSLog("Error: Couldn't read map data at path: " + mapURL.path)
            return nil
        }
        var inputData = data
        let mapData: [String] = mapFile.components(separatedBy: .newlines)
        NSLog("Trying to split \(inputData.count) bytes from the input data into \(mapData.count) blocks.")
        let result = inputData.withUnsafeMutableBytes { (inputDataPtr: UnsafeMutablePointer<UInt8>) -> [UIImage]? in
            var ptr = UnsafeMutableRawPointer(inputDataPtr)
            var images = [UIImage]()
            for i in 0..<mapData.count {
                let blockStr = mapData[i]
                guard let blockSize = Int(blockStr), blockSize > 0 else {
                    NSLog("Error: Found corrupt block size in concat map data! Line:\(i), Block: \(blockStr)")
                    return nil
                }
//                let block = Data(bytesNoCopy: ptr, count: blockSize, deallocator: .none)
                let block = Data(bytes: ptr, count: blockSize)
                let name = String(format: "Frame_%05d", i)
                if let img = UIImage(data: block) {
//                    NSLog("[\(name)] Appending block of \(blockSize) bytes...")
                    images.append(img)
                } else {
                    NSLog("Error: Failed to create image at block: \(name)")
                }
                ptr = ptr.advanced(by: blockSize * MemoryLayout<UInt8>.stride)
            }
            NSLog("Split operation completed successfully!")
            return images
        }
        return result
    }
}
