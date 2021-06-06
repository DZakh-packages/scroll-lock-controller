type targetElements = array<Dom.element>
type pluginHooks = {
  onBodyScrollLock: option<unit => unit>,
  onBodyScrollUnlock: option<unit => unit>,
  onLockTargetsAdd: option<targetElements => unit>,
  onLockTargetsRemove: option<targetElements => unit>,
}
type pluginFactory = unit => pluginHooks

type t
type config = {plugins: array<pluginFactory>}

@genType
let make: (~config: config=?, unit) => t

@genType
let lock: (t, targetElements) => unit

@genType
let unlock: (t, targetElements) => unit

@genType
let clear: t => unit
