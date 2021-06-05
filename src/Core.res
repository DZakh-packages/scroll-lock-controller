type targetElements = Scrollok__Helpers.LocksSet.locks

type onLockTargetsAdd = targetElements => unit
type onLockTargetsRemove = targetElements => unit

type t = {
  locks: Scrollok__Helpers.LocksSet.t,
  isLocked: Scrollok__Helpers.TrackedValue.t<bool>,
  onLockTargetsAdd: option<onLockTargetsAdd>,
  onLockTargetsRemove: option<onLockTargetsRemove>,
}

let make = (
  ~onBodyScrollLock=?,
  ~onBodyScrollUnlock=?,
  ~onLockTargetsAdd=?,
  ~onLockTargetsRemove=?,
  (),
): t => {
  let locks = Scrollok__Helpers.LocksSet.make()

  let isLocked = Scrollok__Helpers.TrackedValue.make(~onChage=newIsLocked => {
    switch (newIsLocked, onBodyScrollLock, onBodyScrollUnlock) {
    | (true, Some(onBodyScrollLockCb), _) => onBodyScrollLockCb()
    | (false, _, Some(onBodyScrollUnlockCb)) => onBodyScrollUnlockCb()
    | (_, _, _) => ()
    }
  }, ~defaultValue=false)

  {
    locks: locks,
    isLocked: isLocked,
    onLockTargetsAdd: onLockTargetsAdd,
    onLockTargetsRemove: onLockTargetsRemove,
  }
}

let isBodyScrollLocked = (it: t) => {
  !(it.locks->Scrollok__Helpers.LocksSet.isEmpty)
}

let lock = (it: t, targetElements) => {
  let added = it.locks->Scrollok__Helpers.LocksSet.add(targetElements)
  let hasAddedTargetElements = added->Js.Array2.length > 0

  added->Js.Array2.forEach(targetElement => {
    targetElement->BodyScrollLock.disableBodyScroll(
      ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
      (),
    )
  })

  it.isLocked->Scrollok__Helpers.TrackedValue.set((. _) => it->isBodyScrollLocked)

  switch (it.onLockTargetsAdd, hasAddedTargetElements) {
  | (Some(onLockTargetsAdd), true) => onLockTargetsAdd(added)
  | (_, _) => ()
  }
}

let unlock = (it: t, targetElements) => {
  let removed = it.locks->Scrollok__Helpers.LocksSet.remove(targetElements)
  let hasRemovedTargetElements = removed->Js.Array2.length > 0

  removed->Js.Array2.forEach(targetElement => {
    targetElement->BodyScrollLock.enableBodyScroll
  })

  it.isLocked->Scrollok__Helpers.TrackedValue.set((. _) => it->isBodyScrollLocked)

  switch (it.onLockTargetsRemove, hasRemovedTargetElements) {
  | (Some(onLockTargetsRemove), true) => onLockTargetsRemove(removed)
  | (_, _) => ()
  }
}

let clear = (it: t) => {
  it->unlock(it.locks->Scrollok__Helpers.LocksSet.getCurrentLocks)
}
