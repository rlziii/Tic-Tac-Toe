import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Test: Codable, Identifiable {
    static let collectionName = "Test"

    @DocumentID var id: String?
    let number: Int

    static func addListener(for id: String, completion: @escaping (Result<Test, FirebaseError>) -> Void) -> ListenerRegistration {
        Firestore.firestore().collection(Self.collectionName).document(id).addSnapshotListener { snapshot, error in
            let result: Result<Test, FirebaseError>

            if let error = error {
                result = .failure(.firebaseError(error))
            } else if let snapshot = snapshot {
                do {
                    let test = try snapshot.data(as: Test.self)

                    if let test = test {
                        result = .success(test)
                    } else {
                        result = .failure(.decodeError(Test.self))
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
}
