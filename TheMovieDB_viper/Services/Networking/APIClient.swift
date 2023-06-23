//
//  APIClient.swift
//  TheMovieDB_viper
//
//  Created by Stanisław Stryjewski on 20/06/2023.
//

import Foundation

protocol APIClient {
    func getData(endpoint: Endpoint) async throws -> Data
    func get<Response: Decodable>(endpoint: Endpoint) async throws -> Response
}

final class TMDBClient: APIClient {
    private let session: URLSession
    private let serializer: Serializer
    private let tokenProvider: TokenProviderProtocol

    init(session: URLSession, serializer: Serializer, tokenProvider: TokenProviderProtocol) {
        self.session = session
        self.serializer = serializer
        self.tokenProvider = tokenProvider
    }

    func getData(endpoint: Endpoint) async throws -> Data {
        let data: Data
        let response: URLResponse

        let request = try await authenticate(endpoint.asURLRequest())

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw TMDbError.network(error)
        }
        let validatedData = try await validate(data: data, response: response)

        return validatedData
    }

    func get<Response: Decodable>(endpoint: Endpoint) async throws -> Response  {
        let data = try await getData(endpoint: endpoint)
        do {
            return try serializer.serialize(Response.self, from: data)
        } catch {
            throw TMDbError.decode(error)
        }
    }

    private func validate(data: Data, response: URLResponse) async throws -> Data {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

        guard (200..<300).contains(statusCode) else {
            // TODO: decode error to get more data
            throw TMDbError.badReponse(statusCode)
        }
        return data
    }

    private func authenticate(_ urlRequest: URLRequest) async throws -> URLRequest {
        guard let token = tokenProvider.token else {
            throw TMDbError.unauthorized
        }
        var urlRequest = urlRequest

        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
