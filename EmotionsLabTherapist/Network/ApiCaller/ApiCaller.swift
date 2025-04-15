//
//  ApiCaller.swift
//  EmotionsLabTherapist
//
//  Created by ahmed on 09/04/2025.
//

import Foundation


class ApiCaller{
    
    
    private var baseUrl: String = "http://127.0.0.1:8000/"
    
    func callApiNoToken(endpoint: String, method: Method, body: [String: String]? = nil, params: [String: String]? = nil) async throws ->  Data{
        do{
            let request = try prepareURLReqeestNoToken(endpoint: endpoint, method: method, body: body, params: params)
            let (data, response) = try await URLSession.shared.data(for: request)

            
            if let httpResponse = response as? HTTPURLResponse,
                  !(200...299).contains(httpResponse.statusCode)  {
                throw ApiCallingErrorDetails(statusCode: httpResponse.statusCode, message: httpResponse.description)
                
            }
            return data
            
        } catch{
            throw error
        }
    }
        
    func callApiWithToken(endpoint: String,
                          method: Method,
                          token: String,
                          body: [String: Any]? = nil,
                          params: [String: String]? = nil)
    async throws -> Data {
        do {
            var request = try prepareURLReqeestNoToken(endpoint: endpoint, method: method, body: body, params: params)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                // Add this to see the response body that contains error details
                let responseString = String(data: data, encoding: .utf8) ?? "Unable to parse response"
                print("Response body: \(responseString)")
                throw ApiCallingErrorDetails(statusCode: httpResponse.statusCode, message: httpResponse.description)
            }
            
            return data
        } catch {
            throw error
        }
    }
    
    private func prepareURLReqeestNoToken(endpoint: String, method: Method, body: [String: Any]? = nil, params: [String: String]?) throws -> URLRequest{
            let completeUrl = self.baseUrl + endpoint
            guard var urlComponents = URLComponents(string: completeUrl) else{
                throw ApiCallerErrors.invalidEndpoint
            }
            // add query param
            if let params = params {
                urlComponents.queryItems = params.map{
                    URLQueryItem(name: $0.key, value: $0.value)
                }
            }
            // Ensure a value exists before continuing. Exit early if it doesn't.
            guard let url = urlComponents.url else {
                throw ApiCallerErrors.invalidEndpoint
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            // Execute code only if unwrapping succeeds.
            if let body = body, !body.isEmpty{
                do {
                   request.httpBody = try JSONSerialization.data(withJSONObject: body)
                   request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    return request
               } catch {
                   throw ApiCallerErrors.serializationError
               }
            }
            return request
        }
}
