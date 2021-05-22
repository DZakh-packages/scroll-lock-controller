type t = {
  locks: ScrollLockController_Helpers.LocksSet.t,
  isLocked: ScrollLockController_Helpers.TrackedValue.t<bool>,
}

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

let lock = (entity, targetElement) => {
  entity.locks->ScrollLockController_Helpers.LocksSet.add(targetElement)
  entity.isLocked->ScrollLockController_Helpers.TrackedValue.set((. _) => true)
  BodyScrollLock.disableBodyScroll(
    targetElement,
    ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
    (),
  )
}

let unlock = (entity, targetElement) => {
  entity.locks->ScrollLockController_Helpers.LocksSet.remove(targetElement)
  entity.isLocked->ScrollLockController_Helpers.TrackedValue.set((. _) => false)
  BodyScrollLock.enableBodyScroll(targetElement)
}
