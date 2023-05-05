import UIKit
import RxSwift
import RxCocoa
import RxRelay

/*
 Observable [sequence] - emits events [notifications of change] asyncronously
 Observer - subscribes to Observable in order to receive events
 
 Subject = Obseravable + Observer
    - PublishSubject - only emits new elements to subscribers
    - BehaviorSubject - emits the last element to new subscribers
    - ReplaySubject - emits a buffer size of elements to new subscribers
    - AsyncSubject - emits only the last next event in the sequence, and only when the subject receives a completed event.
 
 Relays = Wrappers around Subjects that never complete。つまり、次のイベントを発するだけ
    - 完了イベントやエラーイベントを発生させないことが保証されるため、UI関連の作業に最適
    - PublishRelay
    - BehaviorRelay
 */

// Publish Subject
let publishSubject = PublishSubject<String>()
publishSubject.onNext("pub event1")

// event1は表示されない
let ob1 = publishSubject.subscribe(
    onNext: { element in
        print(element)
    }
)

// event2は表示される
publishSubject.onNext("pub event2")

// Behavior Subject
let behaviorSubject = BehaviorSubject<String>(value: "behavior event1")
// 初期値（behavior event1）も購読される
let ob2 = behaviorSubject.subscribe(
    onNext: { element in
        print(element)
    }
)

behaviorSubject.onNext("behavior event2")

// Replay Subject
let replaySubject = ReplaySubject<Int>.create(bufferSize: 3)
replaySubject.onNext(1)
replaySubject.onNext(2)
replaySubject.onNext(3)

// map operatorの利用
replaySubject
    .map({ element in
        element + 2
    })
    .subscribe(
        onNext: { element in
            print(element)
        }
    )

// Async Subject
let asyncSubject = AsyncSubject<String>()
asyncSubject.onNext("async event1")
asyncSubject.onNext("async event2")

// AsyncSubjectは、.onCompleted()が呼ばれると購読される
asyncSubject.onCompleted()

asyncSubject.subscribe(
    onNext: { element in
        print(element)
    }
)

// Relayは、.onCompleted()や.onError()がない
// Publish Relay
let publishRelay = PublishRelay<String>()
publishRelay.accept("publish relay event1")

publishRelay.subscribe(
    onNext: { element in
        print(element)
    }
)

publishRelay.accept("publish relay event2")

// Behavior Relay
let behaviorRelay = BehaviorRelay<String>(value: "behavior relay event1")

behaviorRelay.subscribe(
    onNext: { element in
        print(element)
    }
)

behaviorRelay.accept("behavior relay event2")
