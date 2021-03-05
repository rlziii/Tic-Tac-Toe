import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Game: Codable, Identifiable {

    // Private Type Properties

    private static let collectionName = "Game"

    // Public Properties

    @DocumentID var id: String?
    let boardArray: [BoardSpace]
    let xPlayer: PlayerType
    let oPlayer: PlayerType
    #warning("Update to be a real player model with UID, names, et cetera.")
    let currentPlayer: PlayerType

    // Public Methods

    func gameBoard() -> GameBoard {
        GameBoard(boardArray: boardArray.map { $0.playerToken() },
                  currentPlayer: currentPlayer.playerToken())
    }

    // Public Type Methods

    static func addListener(for id: String, completion: @escaping (Result<Self, FirebaseError>) -> Void) -> ListenerRegistration {
        Firestore.firestore().collection(Self.collectionName).document(id).addSnapshotListener { snapshot, error in
            let result: Result<Self, FirebaseError>

            if let error = error {
                result = .failure(.firebaseError(error))
            } else if let snapshot = snapshot {
                do {
                    let game = try snapshot.data(as: Self.self)

                    if let game = game {
                        result = .success(game)
                    } else {
                        result = .failure(.decodeError(Self.self))
                    }
                } catch {
                    result = .failure(.firebaseError(error))
                }
            } else {
                result = .failure(.unknownError())
            }

            completion(result)
        }
    }

    static func update(for id: String, game: Game, completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        let reference = Firestore.firestore().collection(Self.collectionName).document(id)

        Firestore.firestore().runTransaction { transaction, errorPointer in
            let document: DocumentSnapshot

            do {
                try document = transaction.getDocument(reference)
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }

            // Check for a valid change to the game board.
            if let oldGame = try? document.data(as: Self.self) {
                if !isValidGameBoardChange(oldBoard: oldGame.boardArray, newBoard: game.boardArray) {
                    errorPointer?.pointee = transactionError(with: "Not a valid game board change.")
                    return nil
                }
            } else {
                errorPointer?.pointee = transactionError(with: "Unable to decode \(Self.self) from snapshot: \(document)")
                return nil
            }

            do {
                try transaction.setData(from: game, forDocument: reference)
                return nil
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            }
        } completion: { object, error in
            let result: Result<Void, FirebaseError>

            if let error = error {
                result = .failure(.firebaseError(error))
            } else {
                result = .success(())
            }

            completion(result)
        }
    }

    // Private Type Methods
    
    private static func isValidGameBoardChange(oldBoard: [BoardSpace], newBoard: [BoardSpace]) -> Bool {
        guard oldBoard.count == newBoard.count else {
            return false
        }

        var numberOfChanges = 0

        for index in oldBoard.indices {
            if oldBoard[index] != newBoard[index] {
                numberOfChanges += 1
            }
        }

        return numberOfChanges == 1
    }

    private static func transactionError(with description: String) -> NSError {
        NSError(domain: "AppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
