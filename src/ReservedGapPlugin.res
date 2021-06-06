@genType
let make = () => {
  let pluginFactory: Manager.pluginFactory = () => {
    {
      onBodyScrollLock: Some(
        () => {
          Js.log("lock")
        },
      ),
      onBodyScrollUnlock: Some(
        () => {
          Js.log("unlock")
        },
      ),
      onLockTargetsAdd: None,
      onLockTargetsRemove: None,
    }
  }
  pluginFactory
}
