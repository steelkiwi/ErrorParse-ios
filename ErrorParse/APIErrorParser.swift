//
//  APIErrorParser.swift
//  ErrorParse
//
//  Created by Viktor Olesenko on 07.03.17.
//  Copyright © 2017 Viktor Olesenko. All rights reserved.
//

import Foundation

private typealias JSON     = Dictionary<String, Any>
public  typealias APIError = (field: String?, error: Error)

private enum APIParseError: Error, LocalizedError {
    case serializationFailed
    case wrongFormat
    case parsingFailed
    case custom(text: String)
    
    var errorDescription: String? {
        switch self {
        case .serializationFailed: return "Cannot serialize data"
        case .wrongFormat:         return "Wrong response format"
        case .parsingFailed:       return "Cannot parse error text"
        case .custom(let text):    return text
        }
    }
}

class APIErrorParser {
    
    /// Parse server response data to JSON and retrieve error field and text
    ///
    /// - Parameter errorData: Data from request response
    /// - Returns: APIError with error key (may be nil in case of parsing error) and error text
    public class func parse(_ errorData: Data) -> APIError {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: errorData, options: .allowFragments) else {
            return APIError(nil, APIParseError.serializationFailed)
        }
        
        if let jsonDict = jsonObject as? JSON {
            if let apiError = parseJSON(jsonDict) {
                return apiError
            }
            
            return APIError(nil, APIParseError.parsingFailed)
        }
        
        if let jsonArray = jsonObject as? Array<JSON> {
            if let apiError = parseJSON(jsonArray) {
                return apiError
            }
            
            return APIError(nil, APIParseError.parsingFailed)
        }
        
        return APIError(nil, APIParseError.wrongFormat)
    }
    
    private class func parseJSON(_ jsonArray: Array<JSON>) -> APIError? {
        for jsonDict in jsonArray where !jsonDict.keys.isEmpty {
            if let apiError = parseJSON(jsonDict) {
                return apiError
            }
        }
        
        return nil
    }
    
    private class func parseJSON(_ json: JSON) -> APIError? {
        
        for key in json.keys {
            
            if let valueString = json[key] as? String,
                !valueString.isEmpty {
                let errorText = valueString
                return APIError(key, APIParseError.custom(text: errorText))
            }
            
            if let valueArray = json[key] as? Array<String>,
                let errorText = valueArray.filter({ !$0.isEmpty }).first {
                return APIError(key, APIParseError.custom(text: errorText))
            }
            
            if let valueDict = json[key] as? JSON,
                let error = parseJSON(valueDict) {
                return error
            }
            
            if let valueDictArray = json[key] as? Array<JSON>,
                let error = parseJSON(valueDictArray) {
                return error
            }
        }
        
        return nil
    }
}
