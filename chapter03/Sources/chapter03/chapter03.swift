import RxSwift
import RxCocoa

@main
public struct chapter03 {
    public static func main() {
        /*
         Traitsについて
         RxSwiftの特性
         1. Single：1つの要素またはエラーを返す。ネットワークリクエストなどに利用
         2. Maybe：SingleとCompletableの組み合わせ。単一の要素を出すか、完全なまたはエラーイベント。Optionalな結果を返す操作に使用
         3. Completable：GETやPOSTのような結果、値を出さず、CompleteかErrorのイベント」を出す。PUTやDELETEのような結果を返さないネットワークリクエストに利用
         ※ 3つとも副作用を共有しない、つまり、新しい購読者に前の要素を放出しない。
         ※ asObservable()メソッドを使えば、いずれもObservableに戻すことが可能
         ※ asSingle()メソッドを使えば、ObservableからSingleを得ることが可能
         ※ asCompletable()メソッドを使えば、ObservableからCompletableを得ることが可能
         ※ asMaybe()メソッドを使えば、ObservableからMaybeを得ることが可能
         
         RxCocoaの特性
         1. Driver：主にUIレイヤーを駆動するために使用。もしあれば最後に放出される要素を共有
         2. Signal：Driverと似ているが、オブザーバーがサブスクライブした時に最後のイベントを発生させることはない
         3. ControlProperty：プロパティを表す。UIイベントをリアクティブな方法で表す。最後に放出された要素を共有し、UI要素の割り当てが解除された時点で完了
         4. ControlEvent：UIエレメントのイベントを表す。(ex)クリックやタップ。加入時の初期値は送信されない
         ※ RxCocoaに共通しているのは、エラーをアウトしないこと、イベントを発生させること
         ※ メインスケジューラーで実行されるため、UI作業に最適
         ※ asDriver(onErrorJustReturn: "")で、ObservableからDriverを取得
         ※ asSignal(onErrorJustReturn: "")で、ObservableからSignalを取得
         ※ ControlPropertyの例として、textField.rx.textやbutton.rx.tapなど
         */
        
        /*
         Subjectsについて：ObservableとしてもObserverとして機能する
         RxSwift
         1. PublishedSubject：サブスクリプション後にのみ、新しいオブザーバーにイベントを放出。引数なしで初期化可能
         2. BehaviorSubject：新しいObserverに対して、前回放出した最後のイベントから順にイベントを放出
         3. ReplaySubject：サブスクリプションの時間に関係なく、新しいObserverに全てのイベントを放出
         4. AsyncSubject：最後のイベントのみ、完了後にのみイベントを放出
         */
        
        /*
         RxSwift
         1. PublishRelay：
         2. BehaviorRelay：サブジェクトをラップし、次のイベントを受け入れ、発するだけ。完了イベント、エラーイベントを追加することはできない。UIイベントに最適
         */
        
        let os1 = Observable.just("e1")
        let disposeBag = DisposeBag()
        let _ = os1.asSingle()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        // result: e1
        
        let os2 = Observable.of("e1", "e2")
        let _ = os2.asSingle()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
        // result: Sequence contains more than one element.
        
        Completable.empty()
            .subscribe(
                onCompleted: {
                    print("completed")
                },
                onError: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
        
        let os3 = Observable.of("e2")
        os3.asMaybe()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                },
                onCompleted: {
                    print("completed")
                }
            )
            .disposed(by: disposeBag)
        
        let os4 = Observable<Any>.empty()
        os4.asMaybe()
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onError: {
                    print($0)
                },
                onCompleted: {
                    print("completed")
                }
            )
            .disposed(by: disposeBag)
        
        let os5 = Observable.of("e3", "e4")
        os5.asDriver(onErrorJustReturn: "default")
            .drive(
                onNext: {
                    print($0)
                },
                onCompleted: {
                    print("driver completed")
                },
                onDisposed: {
                    print("driver disposed")
                }
            )
            .disposed(by: disposeBag)
    }
}
