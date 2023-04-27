import RxSwift

@main
public struct chapter01 {
    public private(set) var text = "Hello, World!"

    public static func main() {
        let myObservable = Observable.just("Hello, RxSwift")
        let myObserver = myObservable.subscribe(
            onNext: { element in
                print(element)
            },
            onCompleted: {
                print("Completed")
            }
        )
        
        let os1 = Observable.just("Hi there!")
        let sub1 = os1.subscribe(
            onNext: { event in
                print(event)
            },
            onError: {
                print($0)
            },
            onCompleted: {
                print("completed.")
            },
            onDisposed: {
               print("disposed")
            }
        )
        // sub1.dispose()
        
        let disposeBag = DisposeBag()
        sub1.disposed(by: disposeBag)
        
        let os2 = Observable.from([1, 2, 3])
        let _ = os2
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of("apple", "pears", "bananas")
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
    }
}
