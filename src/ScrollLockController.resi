type t = {
  locks: ScrollLockController_Helpers.LocksSet.t,
  isLocked: ScrollLockController_Helpers.TrackedValue.t<bool>,
}

let make: (~onBodyScrollLock: unit => unit=?, ~onBodyScrollUnlock: unit => unit=?, unit) => t

let lock: (t, array<Dom.element>) => unit

let unlock: (t, array<Dom.element>) => unit
