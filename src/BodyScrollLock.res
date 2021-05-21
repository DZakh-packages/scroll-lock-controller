@deriving(abstract)
type bodyScrollOptions = {
  @optional reserveScrollBarGap: bool,
  @optional allowTouchMove: Dom.element => bool,
}

@module("body-scroll-lock")
external disableBodyScroll: (Dom.element, ~options: bodyScrollOptions=?, unit) => unit =
  "disableBodyScroll"
@module("body-scroll-lock")
external enableBodyScroll: Dom.element => unit = "enableBodyScroll"
@module("body-scroll-lock")
external clearAllBodyScrollLocks: unit => unit = "clearAllBodyScrollLocks"
