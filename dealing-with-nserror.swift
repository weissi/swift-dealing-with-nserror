import Foundation

public class Box<T> {
    let unbox : T
    init(_ value: T) {
        self.unbox = value
    }
}

public enum Result<T> : Printable {
    case Failure(NSError)
    case Success(Box<T>)

    init(Success value:T) {
        self = .Success(Box(value))
    }

    init(Failure error:NSError) {
        self = .Failure(error)
    }

    public var description: String {
        get {
            switch self {
            case .Success(let s):
                return "Result.Success(\(s.unbox))"
            case .Failure(let e):
                return "Result.Failure(\(e))"
            }
        }
    }
}

func resultifyNSErrorReturningFunction<T>(brackedBlock:(NSErrorPointer) -> T?) -> Result<T> {
    var e : NSError? = nil
    if let v = brackedBlock(&e) {
        return Result(Success: v)
    } else {
        if let error = e {
            return Result(Failure: error)
        } else {
            fatalError("programmer error, not successful & error nil")
        }
    }
}
