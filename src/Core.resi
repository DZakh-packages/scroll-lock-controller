type t
type targetElements = array<Dom.element>
type hooks = {
  onBodyScrollLock: option<unit => unit>,
  onBodyScrollUnlock: option<unit => unit>,
  onLockTargetsAdd: option<targetElements => unit>,
  onLockTargetsRemove: option<targetElements => unit>,
}

let make: hooks => t

let lock: (t, targetElements) => unit

let unlock: (t, targetElements) => unit

let clear: t => unit
