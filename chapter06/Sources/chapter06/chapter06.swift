import RxSwift
import RxCocoa

@main
public struct chapter06 {
    public static func main() {
        /*
         RxSwiftとRxCocoaで利用可能なスケジューラについて
         - main topics：Built-in schedulers, subscribeOn & observeOn operators, Custom schedulers
         */
        
        /*
         RxSwiftでは、全て同じスレッドで行われる
         - スレッドを手動で変更することはなく、全て現在のスレッドで行われる
         
         Scedulers
         - Serial
            - CurrentThreadScheduler：現在のスレッドでスケジュールする。また、デフォルトのスケジューラー
            - MainScheduler：メインスレッドでスケジューリングする。UI作業が行われる
            - SerialDispatchQueueScheduler：特定の条件でスケジュールする
         
         - Concurent
            - ConcurrentDispatchQueueScheduler：スケジュールを特定のキューに入れる
            - OperationQueueScheduler：特定のキューでスケジュールすることが可能
         */
     
        let disposeBag = DisposeBag()
        Observable.of("a1", "b1", "a2")
            .filter({ element in
                element.starts(with: "a")
            })
            // subscribe(on: )：Observableが動作するSchedulerを指定
            // つまり、SubscribeOnは、Observableを購読するSchedulerを記述
            // subscribe(on:)は、ほとんどバックグラウンドのスレッドでsubscribeされる
            // observableを待つ間、UIスレッドをブロックしたくない
            .subscribe(on: SerialDispatchQueueScheduler(qos: .background))
            // オブザーバーがObservableを観察するためのSchedulerを指定
            // つまり、Observe(on:)は、結果を観察するスケジューラを表現
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        /*
         独自のスケジューラを作成
         1. ImmediateSchedulerプロトコルを実装する必要がある
         public protocol ImmediateScheduler {
            func schedule<StateType>(state: StateType, action: (StateType) -> RxResult<Diposable>) -> RxResult<Disposable>
         }
         
         2. 作成したいスケジューラの種類を選択し、「スケジューラ」のいずれかを実装
         
         public protocol Scheduler: ImmediateScheduler {
            associatedtype TimeInterval
            associatedtype Time
            var now: Time {
                get
            }
            func scheduleRelative<StateType>(state: StateType, dueTime: TimeInterval, action: (StateType) -> RxResult<Disposable>) -> RxResult<Disposable>
         }
         
         public protocol PeriodicScheduler: Scheduler {
            func schedulePeriodic<StateType>(state: StateType, startAfter: TimeInterval, period: TimeInterval, action: (StateType) -> StateType) -> RxResult<Disposable>
         }
         */
        
    }
}
