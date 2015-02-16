# What's this?

A very small library to deal with NSError "returning" functions from Objective-C.


# How does it work?

It's basically a helper function that allows you to easily convert `NSError`
"returning" functions into functions returning `Result<T>`.

This is the code:

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

# Example?

This example turns the two `NSFileManager` functions `copyItemAtPath:error:` and
`contentsOfDirectoryAtPath:error:` into functions that return a `Result<T>`
which is either an actual value _or_ an `NSError`.

    func copyItemAtPath(srcPath:String, toPath:String) -> Result<()> {
        return resultifyNSErrorReturningFunction { (outError:NSErrorPointer) in
            return NSFileManager.defaultManager().copyItemAtPath(srcPath, toPath: toPath, error:outError) ? () : nil
        }
    }
    
    func contentsOfDirectoryAtPath(dir:String) -> Result<[String]> {
        return resultifyNSErrorReturningFunction { (outError:NSErrorPointer) -> [String]? in
            switch NSFileManager.defaultManager().contentsOfDirectoryAtPath(dir, error:outError)?.map({ $0 as? String }) {
                case .Some(let files):
                    return catOptionals(files)
                case .None:
                    return nil
            }
        }
    }
    
# How to build?

    make

# How to run the demo?

    make && ./main

# Swift Version?

1.2, might run on 1.1 as well.

