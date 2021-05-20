%%raw(`import './style.css';`)

open Webapi.Dom

let enableLockButton = lockButtonEl => {
  let onLockButtonClick = _ => {
    Index.lock()
  }

  EventTarget.addEventListener("click", onLockButtonClick, Element.asEventTarget(lockButtonEl))
}

let enableUnlockButton = unlockButtonEl => {
  let onUnlockButtonClick = _ => {
    Index.unlock()
  }

  EventTarget.addEventListener("click", onUnlockButtonClick, Element.asEventTarget(unlockButtonEl))
}

switch document |> Document.querySelector(".js-lock-button") {
| Some(lockButtonEl) => enableLockButton(lockButtonEl)
| None => () // do nothing
}

switch document |> Document.querySelector(".js-unlock-button") {
| Some(unlockButtonEl) => enableUnlockButton(unlockButtonEl)
| None => () // do nothing
}
