import Foundation

enum FirebaseError: LocalizedError {
    case firebaseError(Error, function: String = #function)
    case decodeError(Any.Type, function: String = #function)
    case documentDoesNotExist(String = "Document does not exist.", function: String = #function)
    case unknownError(String = "Unknown Firebase error.", function: String = #function)

    var errorDescription: String? {
        let body: String
        let functionName: String

        switch self {
        case let .firebaseError(error, function):
            body = error.localizedDescription
            functionName = function
        case let .decodeError(type, function):
            body = "Could not decode data to expected type \(type)."
            functionName = function
        case let .documentDoesNotExist(description, function):
            body = description
            functionName = function
        case let .unknownError(description, function):
            body = description
            functionName = function
        }

        return "FIREBASE ERROR (\(functionName)): \(body)"
    }
}
