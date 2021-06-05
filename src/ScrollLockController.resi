type t = {
  locks: ScrollLockController_Helpers.LocksSet.t,
  isLocked: ScrollLockController_Helpers.TrackedValue.t<bool>,
  onLockTargetsAdd: option<ScrollLockController_Helpers.LocksSet.locks => unit>,
  onLockTargetsRemove: option<ScrollLockController_Helpers.LocksSet.locks => unit>,
}

let make: (
  ~onBodyScrollLock: unit => unit=?,
  ~onBodyScrollUnlock: unit => unit=?,
  ~onLockTargetsAdd: ScrollLockController_Helpers.LocksSet.locks => unit=?,
  ~onLockTargetsRemove: ScrollLockController_Helpers.LocksSet.locks => unit=?,
  unit,
) => t

let lock: (t, array<Dom.element>) => unit

let unlock: (t, array<Dom.element>) => unit
