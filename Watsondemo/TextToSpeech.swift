//
//  TextToSpeech.swift
//  WF_CVA
//
//  Created by Etay Luz on 7/5/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import Foundation
import UIKit

@objc class SpeechtoText: NSObject {
  /**
   Repair the WAV header for a WAV-formatted audio file produced by Watson Text to Speech.
   
   - parameter data: The WAV-formatted audio file produced by Watson Text to Speech. The
   byte data will be analyzed and repaired in-place.
   */
  func repairWAVHeader(data: NSMutableData) {
    
    // resources for WAV header format:
    // [1] http://unusedino.de/ec64/technical/formats/wav.html
    // [2] http://soundfile.sapp.org/doc/WaveFormat/
    
    // update RIFF chunk size
    let fileLength = data.length
    var riffChunkSize = UInt32(fileLength - 8)
    let riffChunkSizeRange = NSMakeRange(4, 4)
    data.replaceBytesInRange(riffChunkSizeRange, withBytes: &riffChunkSize)
    
    // find data subchunk
    var subchunkID: String?
    var subchunkSize = 0
    var fieldOffset = 12
    let fieldSize = 4
    while true {
      // prevent running off the end of the byte buffer
      if fieldOffset + 2*fieldSize >= data.length {
        return
      }
      
      // read subchunk ID
      subchunkID = dataToUTF8String(data, offset: fieldOffset, length: fieldSize)
      fieldOffset += fieldSize
      if subchunkID == "data" {
        break
      }
      
      // read subchunk size
      subchunkSize = dataToUInt32(data, offset: fieldOffset)
      fieldOffset += fieldSize + subchunkSize
    }
    
    // compute data subchunk size (excludes id and size fields)
    var dataSubchunkSize = UInt32(data.length - fieldOffset - fieldSize)
    
    // update data subchunk size
    let dataSubchunkSizeRange = NSMakeRange(fieldOffset, fieldSize)
    data.replaceBytesInRange(dataSubchunkSizeRange, withBytes: &dataSubchunkSize)
  }

  // MARK: - Internal methods

  /**
   Convert a big-endian byte buffer to a UTF-8 encoded string.
   
   - parameter data: The byte buffer that contains a big-endian UTF-8 encoded string.
   - parameter offset: The location within the byte buffer where the string begins.
   - parameter length: The length of the string (without a null-terminating character).
   
   - returns: A String initialized by converting the given big-endian byte buffer into
   Unicode characters using a UTF-8 encoding.
   */
  private func dataToUTF8String(data: NSData, offset: Int, length: Int) -> String? {
    let range = NSMakeRange(offset, length)
    let subdata = data.subdataWithRange(range)
    return String(data: subdata, encoding: NSUTF8StringEncoding)
  }

  /**
   Convert a little-endian byte buffer to a UInt32 integer.
   
   - parameter data: The byte buffer that contains a little-endian 32-bit unsigned integer.
   - parameter offset: The location within the byte buffer where the integer begins.
   
   - returns: An Int initialized by converting the given little-endian byte buffer into
   an unsigned 32-bit integer.
   */
  private func dataToUInt32(data: NSData, offset: Int) -> Int {
    var num: UInt32 = 0
    let length = 4
    let range = NSMakeRange(offset, length)
    data.getBytes(&num, range: range)
    return Int(num)
  }

}