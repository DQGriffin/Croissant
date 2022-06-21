//
//  XMLReader.swift
//  Croissant
//
//  Created by Dquavius Griffin on 6/16/22.
//

import Foundation
import XMLCoder

struct XMLReader {
    var ivr: MultiLevelIVR
    
    init(path: URL) {
        do {
            let xmlData = try String(contentsOfFile: path.path)
            ivr = try! XMLDecoder().decode(MultiLevelIVR.self, from: Data(xmlData.utf8))
            
            let filename = path.lastPathComponent.replacingOccurrences(of: ".xml", with: ".csv")
            
            let auditWriter = AuditWriter(multiLevelIVR: ivr)
            auditWriter.writeIVR(filename: filename)
            
        }
        catch {
            print("Failed to read XML File")
            print(error)
            ivr = MultiLevelIVR()
        }
    }
}
