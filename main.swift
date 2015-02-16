import Foundation

func catOptionals<T>(xs:[T?]) -> [T] {
    var ys : [T] = []
    for mx in xs {
        if let x = mx {
            ys.append(x)
        }
    }
    return ys
}

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

println("--> This should succeed:")
println(contentsOfDirectoryAtPath("/tmp"))
println()
println("--> This should fail:")
println(contentsOfDirectoryAtPath("/dev/null/this/does/not/exist"))
