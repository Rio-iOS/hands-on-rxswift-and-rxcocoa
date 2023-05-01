import RxSwift
import RxCocoa

@main
public struct chapter05 {
    public private(set) var text = "Hello, World!"

    public static func main() {
        /*
         RxSwiftとRxCocoaのエラー処理とデバッグ
         - エラー処理の実装
         - デバッグ演算子
         - メモリリークのデバッグ
         */
        
        /*
         【Individual error handling】
         subscribe(onError:)
            - handling errors directly
         
         do(onError)
            - handing errors as a side effect
         */
        
        /*
         【Individual error handling】
         catch & retry
         
         catch
            - エラー回復を細かく指定できる様々なオーバーロードがあり、エラー時に何度か操作をやり直すことができる
         
         retry
            - enables retries in case of errored sequence
         */
        
        /*
         【General error handling】
         - デフォルトのエラー処理機構を提供するglobal Hook
            - 独自のonErrorハンドラを提供しない
            - Hooks用のクロージャを実装する必要がある
            - .defaultErrorHandlerを使用して、システムで処理されないエラーに対処する
            - Hooks.defaultErrorHandlerは、DEBUGモードでは受け取ったエラーを表示し、RELEASEでは何もしない
            - コールスタックの詳細なロギングを有効にするには、Hooks.recordCallStackOnErrorにフラグtrueを設定
         */
        
        /*
         Reactive Applicationdでは、デバッグ演算子を利用
         - デバッグオペレーターは、全てのイベントを標準出力に出力
         - また、ラベルを追加することも可能
         - .debug("completable")
         */
        let disposeBag = DisposeBag()
        Completable.empty()
            .debug("completable")
            .subscribe(
                onCompleted: {
                    print("completed")
                },
                onError: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        /*
         メモリリークのトラブルシューティング
         1. enable Debug Mode
            - add TRACE_RESOURCES to the RxSwift target build settings under Other Swift Flags
         */
        
        /*
        let myObservable = Observable.just("Debug memory leaks")
        let myObserver = myObservable.subscribe(
            onNext: { element in
                print("Resource count \(RxSwift.Resources.total)")
            },
            onCompleted: {
                print("completed")
            }
        )
         */
    }
}

extension ObservableType {
    public func myDebug(identifier: String) -> Observable<Self.Element> {
        return Observable.create { observer in
            print("subscribed \(identifier)")
            let subscription = self.subscribe { e in
                print("event \(identifier) \(e)")
                switch e {
                case .next(let value): observer.on(.next(value))
                case .error(let error): observer.on(.error(error))
                case .completed: observer.on(.completed)
                }
            }
            return Disposables.create {
                print("disposing \(identifier)")
                subscription.dispose()
            }
        }
    }
}
