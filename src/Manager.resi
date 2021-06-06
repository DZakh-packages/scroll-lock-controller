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

let make: (~config: config=?, unit) => t

let lock: (t, targetElements) => unit

let unlock: (t, targetElements) => unit

let clear: t => unit
