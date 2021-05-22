module LocksSet = {
  type t = ref<array<Dom.element>>

  let make = (): t => {
    ref([])
  }

  let isEmpty = value => {
    value.contents->Js.Array2.length === 0
  }

  let add = (value, lock) => {
    value.contents = value.contents->Js.Array2.concat([lock])
  }

  let remove = (value: t, lock) => {
    value.contents =
      value.contents->Js.Array2.filter(existingLock => {
        existingLock !== lock
      })
  }
}

type t = {locks: LocksSet.t}

let make = () => {
  {
    locks: LocksSet.make(),
  }
}

let lock = (value, targetElement) => {
  value.locks->LocksSet.add(targetElement)
  BodyScrollLock.disableBodyScroll(
    targetElement,
    ~options=BodyScrollLock.bodyScrollOptions(~reserveScrollBarGap=true, ()),
    (),
  )
}

let unlock = (value, targetElement) => {
  value.locks->LocksSet.remove(targetElement)
  BodyScrollLock.enableBodyScroll(targetElement)
}
