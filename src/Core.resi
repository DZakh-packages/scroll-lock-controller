type t
type targetElements = array<Dom.element>

let make: (
  ~onBodyScrollLock: unit => unit=?,
  ~onBodyScrollUnlock: unit => unit=?,
  ~onLockTargetsAdd: targetElements => unit=?,
  ~onLockTargetsRemove: targetElements => unit=?,
  unit,
) => t

let lock: (t, targetElements) => unit

let unlock: (t, targetElements) => unit

let clear: t => unit
