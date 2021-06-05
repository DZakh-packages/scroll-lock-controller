type onLockTargetsAdd = ScrollLockController_Helpers.LocksSet.locks => unit
type onLockTargetsRemove = ScrollLockController_Helpers.LocksSet.locks => unit

type t = {
  locks: ScrollLockController_Helpers.LocksSet.t,
  isLocked: ScrollLockController_Helpers.TrackedValue.t<bool>,
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
  let locks = ScrollLockController_Helpers.LocksSet.make()

  let isLocked = ScrollLockController_Helpers.TrackedValue.make(~onChage=newIsLocked => {
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
  !(it.locks->ScrollLockController_Helpers.LocksSet.isEmpty)
}

let lock = (it: t, targetElements) => {
  let added = it.locks->ScrollLockController_Helpers.LocksSet.add(targetElements)
  let hasAddedTargetElements = added->Js.Array2.length > 0

  added->Js.Array2.forEach(targetElement => {
    targetElement->BodyScrollLock.disableBodyScroll(
      ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
      (),
    )
  })

  it.isLocked->ScrollLockController_Helpers.TrackedValue.set((. _) => it->isBodyScrollLocked)

  switch (it.onLockTargetsAdd, hasAddedTargetElements) {
  | (Some(onLockTargetsAdd), true) => onLockTargetsAdd(added)
  | (_, _) => ()
  }
}

let unlock = (it: t, targetElements) => {
  let removed = it.locks->ScrollLockController_Helpers.LocksSet.remove(targetElements)
  let hasRemovedTargetElements = removed->Js.Array2.length > 0

  removed->Js.Array2.forEach(targetElement => {
    targetElement->BodyScrollLock.enableBodyScroll
  })

  it.isLocked->ScrollLockController_Helpers.TrackedValue.set((. _) => it->isBodyScrollLocked)

  switch (it.onLockTargetsRemove, hasRemovedTargetElements) {
  | (Some(onLockTargetsRemove), true) => onLockTargetsRemove(removed)
  | (_, _) => ()
  }
}

let clear = (it: t) => {
  it->unlock(it.locks->ScrollLockController_Helpers.LocksSet.getCurrentLocks)
}
