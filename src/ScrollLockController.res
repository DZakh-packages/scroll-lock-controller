let lock = el => {
  BodyScrollLock.disableBodyScroll(
    el,
    ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
    (),
  )
}

let unlock = el => {
  BodyScrollLock.enableBodyScroll(el)
}

type handlers = {
  lock: Dom.element => unit,
  unlock: (Dom.element, ~options: BodyScrollLock.bodyScrollOptions=?, unit) => unit,
  clearLocks: unit => unit,
  isEmpty: unit => bool,
}

module DomElementsCmp = Belt.Id.MakeComparable({
  type t = Dom.element
  let cmp = (el1, el2) => {
    switch el1 === el2 {
    | true => 0
    | false => 1
    }
  }
})

let create = (): handlers => {
  let locksSet = ref(Belt.Set.make(~id=module(DomElementsCmp)))

  let lock = targetElement => {
    locksSet.contents = locksSet.contents->Belt.Set.add(targetElement)
    BodyScrollLock.enableBodyScroll(targetElement)
  }
  let unlock = targetElement => {
    locksSet.contents = locksSet.contents->Belt.Set.remove(targetElement)
    BodyScrollLock.disableBodyScroll(targetElement)
  }
  let clearLocks = BodyScrollLock.clearAllBodyScrollLocks
  let isEmpty = () => {
    locksSet.contents->Belt.Set.isEmpty
  }

  {
    lock: lock,
    unlock: unlock,
    clearLocks: clearLocks,
    isEmpty: isEmpty,
  }
}
