import Foundation

enum AppError: Error {
    case network
    case decoding
    case notFound
    case validation(String)
    case unknown

    var userMessage: String {
        switch self {
        case .network:
            return "Unable to connect. Please check your internet connection."
        case .decoding:
            return "Something went wrong while loading data."
        case .notFound:
            return "The requested item could not be found."
        case .validation(let message):
            return message
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }

    static func map(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        if error is DecodingError {
            return .decoding
        }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotConnectToHost, .cannotFindHost:
                return .network
            default:
                return .unknown
            }
        }
        return .unknown
    }
}
