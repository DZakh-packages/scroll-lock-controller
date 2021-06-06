type targetElements = array<Dom.element>
type pluginHooks = {
  onBodyScrollLock: option<unit => unit>,
  onBodyScrollUnlock: option<unit => unit>,
  onLockTargetsAdd: option<targetElements => unit>,
  onLockTargetsRemove: option<targetElements => unit>,
}
type groupedPluginsHooks = {
  onBodyScrollLock: array<unit => unit>,
  onBodyScrollUnlock: array<unit => unit>,
  onLockTargetsAdd: array<targetElements => unit>,
  onLockTargetsRemove: array<targetElements => unit>,
}
type pluginFactory = unit => pluginHooks

type t = {core: Core.t}
type config = {plugins: array<pluginFactory>}

let preparePluginsHooks = (pluginFactories: array<pluginFactory>): groupedPluginsHooks => {
  let groupedPluginsHooks = {
    onBodyScrollLock: [],
    onBodyScrollUnlock: [],
    onLockTargetsAdd: [],
    onLockTargetsRemove: [],
  }

  pluginFactories->Js.Array2.forEach(pluginFactory => {
    let pluginHooks = pluginFactory()

    switch pluginHooks.onBodyScrollLock {
    | Some(onBodyScrollLock) => {
        let _ = groupedPluginsHooks.onBodyScrollLock->Js.Array2.push(onBodyScrollLock)
      }
    | None => ()
    }
    switch pluginHooks.onBodyScrollUnlock {
    | Some(onBodyScrollUnlock) => {
        let _ = groupedPluginsHooks.onBodyScrollUnlock->Js.Array2.push(onBodyScrollUnlock)
      }
    | None => ()
    }
    switch pluginHooks.onLockTargetsAdd {
    | Some(onLockTargetsAdd) => {
        let _ = groupedPluginsHooks.onLockTargetsAdd->Js.Array2.push(onLockTargetsAdd)
      }
    | None => ()
    }
    switch pluginHooks.onLockTargetsRemove {
    | Some(onLockTargetsRemove) => {
        let _ = groupedPluginsHooks.onLockTargetsRemove->Js.Array2.push(onLockTargetsRemove)
      }
    | None => ()
    }
  })

  groupedPluginsHooks
}

let make = (~config: option<config>=?, ()) => {
  let pluginFactories = switch config {
  | Some(someConfig) => someConfig.plugins
  | None => []
  }

  let groupedPluginsHooks = preparePluginsHooks(pluginFactories)

  let onBodyScrollLock = switch groupedPluginsHooks.onBodyScrollLock->Scrollok__Helpers.isEmptyArray {
  | false =>
    Some(
      () => {
        groupedPluginsHooks.onBodyScrollLock->Js.Array2.forEach(cb => {
          cb()
        })
      },
    )
  | true => None
  }

  let onBodyScrollUnlock = switch groupedPluginsHooks.onBodyScrollUnlock->Scrollok__Helpers.isEmptyArray {
  | false =>
    Some(
      () => {
        groupedPluginsHooks.onBodyScrollUnlock->Js.Array2.forEach(cb => {
          cb()
        })
      },
    )
  | true => None
  }

  let onLockTargetsAdd = switch groupedPluginsHooks.onLockTargetsAdd->Scrollok__Helpers.isEmptyArray {
  | false =>
    Some(
      targetElements => {
        groupedPluginsHooks.onLockTargetsAdd->Js.Array2.forEach(cb => {
          cb(targetElements)
        })
      },
    )
  | true => None
  }

  let onLockTargetsRemove = switch groupedPluginsHooks.onLockTargetsRemove->Scrollok__Helpers.isEmptyArray {
  | false =>
    Some(
      targetElements => {
        groupedPluginsHooks.onLockTargetsRemove->Js.Array2.forEach(cb => {
          cb(targetElements)
        })
      },
    )
  | true => None
  }

  {
    core: Core.make({
      onBodyScrollLock: onBodyScrollLock,
      onBodyScrollUnlock: onBodyScrollUnlock,
      onLockTargetsAdd: onLockTargetsAdd,
      onLockTargetsRemove: onLockTargetsRemove,
    }),
  }
}

let lock = (it: t, targetElements) => {
  it.core->Core.lock(targetElements)
}

let unlock = (it: t, targetElements) => {
  it.core->Core.unlock(targetElements)
}

let clear = (it: t) => {
  it.core->Core.clear
}
