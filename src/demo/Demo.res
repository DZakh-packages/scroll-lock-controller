%%raw(`import './style.css';`)

open Webapi.Dom

let enableLockButton = lockButtonEl => {
  let onLockButtonClick = _ => {
    Js.log("Lock click")
  }

  EventTarget.addEventListener("click", onLockButtonClick, Element.asEventTarget(lockButtonEl))
}

let enableUnlockButton = unlockButtonEl => {
  let onUnlockButtonClick = _ => {
    Js.log("Unlock click")
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
