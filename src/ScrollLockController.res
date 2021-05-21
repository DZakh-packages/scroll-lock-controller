let lock = el => {
  BodyScrollLock.disableBodyScroll(
    el,
    ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
    (),
  )
}

let unlock = el => {
  BodyScrollLock.enableBodyScroll(el)
}
