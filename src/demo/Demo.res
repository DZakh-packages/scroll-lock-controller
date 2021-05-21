%%raw(`import './style.css';`)

open Webapi.Dom

let enableLockButton = lockButtonEl => {
  let scrollableNodeList = document |> Document.querySelectorAll(".js-modal-with-scroll")

  let onLockButtonClick = _ => {
    scrollableNodeList |> NodeList.forEach((scrollableNode, _idx) => {
      switch ScrollLockController_helpers.convertNodeToElement(scrollableNode) {
      | Some(scrollableEl) => ScrollLockController.lock(scrollableEl)
      | None => ()
      }
    })
  }

  EventTarget.addEventListener("click", onLockButtonClick, Element.asEventTarget(lockButtonEl))
}

let enableUnlockButton = unlockButtonEl => {
  let scrollableNodeList = document |> Document.querySelectorAll(".js-modal-with-scroll")

  let onUnlockButtonClick = _ => {
    scrollableNodeList |> NodeList.forEach((scrollableNode, _idx) => {
      switch ScrollLockController_helpers.convertNodeToElement(scrollableNode) {
      | Some(scrollableEl) => ScrollLockController.unlock(scrollableEl)
      | None => ()
      }
    })
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
