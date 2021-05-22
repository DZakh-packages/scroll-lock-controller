type t = {locks: ScrollLockController_Helpers.LocksSet.t, isLocked: ScrollLockController_Helpers.TrackedValue.t<bool>}

let make = (~onBodyScrollLock=?, ~onBodyScrollUnlock=?, ()) => {
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
  }
}

let lock = (value, targetElement) => {
  value.locks->ScrollLockController_Helpers.LocksSet.add(targetElement)
  BodyScrollLock.disableBodyScroll(
    targetElement,
    ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
    (),
  )
}

let unlock = (value, targetElement) => {
  value.locks->ScrollLockController_Helpers.LocksSet.remove(targetElement)
  BodyScrollLock.enableBodyScroll(targetElement)
}
