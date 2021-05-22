
type t = {locks: ScrollLockController_Helpers.LocksSet.t, isLocked: ScrollLockController_Helpers.TrackedValue.t<bool>}

let make: (
  ~onBodyScrollLock: (unit => unit)=?,
  ~onBodyScrollUnlock: (unit => unit)=?,
  unit,
) => t

let lock: (t, Dom.element) => unit

let unlock: (t, Dom.element) => unit