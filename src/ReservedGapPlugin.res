let make = (): Manager.pluginFactory => {
  () => {
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
}
