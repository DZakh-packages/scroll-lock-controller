type targetElements = array<Dom.element>
type pluginHooks = {
  onBodyScrollLock: option<unit => unit>,
  onBodyScrollUnlock: option<unit => unit>,
  onLockTargetsAdd: option<targetElements => unit>,
  onLockTargetsRemove: option<targetElements => unit>,
}
type pluginFactory = unit => pluginHooks

type t

@genType
let make: (~plugins: array<pluginFactory>=?, unit) => t

@genType
let lock: (t, targetElements) => unit

@genType
let unlock: (t, targetElements) => unit

@genType
let clear: t => unit
