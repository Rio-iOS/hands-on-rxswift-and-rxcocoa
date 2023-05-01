import RxSwift
import RxCocoa

@main
public struct chapter04 {
    public static func main() {
        /*
         Operatorは3つのカテゴリに分類
         - フィルタリング演算子
            - filter()
            - skip()
            - skipWhile()
            - skipUntil()
            - takeWhile()
            - takeLast()
            - throttle()
            - elementAt(1)
            - ignoreElements()
            - distinct()
            - distinctUntilChanged()
         - 変換演算子
            - map()
            - concatMap()
            - flatMap()
            - flatMapLatest()
            - pairWise()
            - scan()
         - 結合演算子
            - startWith()
            - concat()
            - merge()
            - reduce()
            - combineLatest()
            - zip()
            - withLatestFrom()
         */
       
        let disposeBag = DisposeBag()
        Observable.of(1, 12, 11)
            .filter({1 < $0})
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(1, 12, 11)
            .skip(2)
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(1, 12, 11)
            .take(while: { $0 < 12 })
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(1, 12, 11)
            .takeLast(1)
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(1, 12, 11)
            .element(at: 1)
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(1, 12, 11)
            .ignoreElements()
            .subscribe(
                onCompleted: {
                    print("completed")
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(11, 1, 1, 12)
            .distinctUntilChanged()
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.of(1, 5, 11)
            .map({ $0 * 2 })
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        // filtering operators
        let os1 = Observable.of("a1", "b1", "a2")
        os1.filter { element in
            element.starts(with: "a")
        }
        .subscribe(
            onNext: {
                print($0)
            }
        )
        .disposed(by: disposeBag)
        
        os1.skip(2)
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        os1.element(at: 1)
            .subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        
        // transforming operators
        let os2 = Observable.of(1, 2, 3, 4)
        os2.scan(Int()) {
            sum, element in
                return sum + element
        }
        .subscribe(
            onNext: {
                print($0)
            }
        )
        .disposed(by: disposeBag)
        
        os1.flatMap({
            element in
            return Observable.of("c", "d")
                .map({ value in
                    "" + element + value
                })
        })
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
        
        print("flatMapLatest")
        os1.flatMapLatest({
            element in
            return Observable.of("c", "d")
                .map({ value in
                    "" + element + value
                })
        })
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
        
        // combining operators
        os2.startWith(0)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        Observable.zip(os1, os2)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        Observable.merge(os1, Observable.of("c", "d"))
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        os2.reduce(Int()) { sum, element in
            return sum + element
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    }
}

