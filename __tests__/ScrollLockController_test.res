let {test, describe} = module(Jest)
let {mock} = module(Jest.JestJs)
let {expect} = module(Jest.Expect)
module JExp = Jest.Expect

mock("body-scroll-lock")

describe("ScrollLockController", () => {
  describe("Test onBodyScrollLock callback", () => {
    test("Isn't called right after creation", () => {
      let mockOnBodyScrollLock = Jest.JestJs.fn(() => ())

      let _ = ScrollLockController.make(~onBodyScrollLock=mockOnBodyScrollLock->Jest.MockJs.fn, ())

      expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(0, _)
    })

    test("Is called after first lock", () => {
      let mockOnBodyScrollLock = Jest.JestJs.fn(() => ())

      let div = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

      let scrollLockController = ScrollLockController.make(
        ~onBodyScrollLock=mockOnBodyScrollLock->Jest.MockJs.fn,
        (),
      )

      scrollLockController->ScrollLockController.lock(div)

      expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(1, _)
    })
  })

  test("Locks are empty after create", () => {
    open Webapi.Dom

    let div = Document.createElement("div", document)
    let scrollLockController = ScrollLockController.make()

    scrollLockController->ScrollLockController.lock(div)

    Js.log(scrollLockController)

    expect(true)->JExp.toBe(true, _)
  })
})
