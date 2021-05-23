%%raw(`import './style.css';`)

open Webapi.Dom

let scrollLockController = ScrollLockController.make()

let enableLockButton = lockButtonEl => {
  let scrollableNodeList = document->Document.querySelectorAll(".js-modal-with-scroll", _)

  let onLockButtonClick = _ => {
    scrollableNodeList->NodeList.forEach((scrollableNode, _idx) => {
      switch ScrollLockController_Helpers.convertNodeToElement(scrollableNode) {
      | Some(scrollableEl) => scrollLockController->ScrollLockController.lock([scrollableEl])
      | None => ()
      }
    }, _)
  }

  EventTarget.addEventListener("click", onLockButtonClick, Element.asEventTarget(lockButtonEl))
}

let enableUnlockButton = unlockButtonEl => {
  let scrollableNodeList = document->Document.querySelectorAll(".js-modal-with-scroll", _)

  let onUnlockButtonClick = _ => {
    scrollableNodeList->NodeList.forEach((scrollableNode, _idx) => {
      switch ScrollLockController_Helpers.convertNodeToElement(scrollableNode) {
      | Some(scrollableEl) => scrollLockController->ScrollLockController.unlock(scrollableEl)
      | None => ()
      }
    }, _)
  }

  EventTarget.addEventListener("click", onUnlockButtonClick, Element.asEventTarget(unlockButtonEl))
}

switch document->Document.querySelector(".js-lock-button", _) {
| Some(lockButtonEl) => enableLockButton(lockButtonEl)
| None => () // do nothing
}

switch document->Document.querySelector(".js-unlock-button", _) {
| Some(unlockButtonEl) => enableUnlockButton(unlockButtonEl)
| None => () // do nothing
}
