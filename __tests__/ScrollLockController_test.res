let {test, describe, beforeEach, fail} = module(Jest)
let {mock} = module(Jest.JestJs)
let {expect} = module(Jest.Expect)
module JExp = Jest.Expect

mock("body-scroll-lock")

describe("ScrollLockController", () => {
  describe("Test onBodyScrollLock callback", () => {
    let mockOnBodyScrollLockRef = ref(None)
    let scrollLockControllerRef = ref(None)
    let targetElement1Ref = ref(None)

    beforeEach(() => {
      let mockOnBodyScrollLock = Jest.JestJs.fn(() => ())

      mockOnBodyScrollLockRef := Some(mockOnBodyScrollLock)
      scrollLockControllerRef :=
        Some(ScrollLockController.make(~onBodyScrollLock=mockOnBodyScrollLock->Jest.MockJs.fn, ()))
      targetElement1Ref := Some(Webapi.Dom.Document.createElement("div", Webapi.Dom.document))
    })

    test("Isn't called right after creation", () => {
      switch (mockOnBodyScrollLockRef.contents, scrollLockControllerRef.contents) {
      | (Some(mockOnBodyScrollLock), Some(_)) =>
        expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(0, _)
      | (_, _) => fail("Prepare stage failed")
      }
    })

    test("Is called after first lock", () => {
      switch (
        mockOnBodyScrollLockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollLock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock(targetElement1)

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Isn't called once again after unlock", () => {
      switch (
        mockOnBodyScrollLockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollLock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock(targetElement1)
          scrollLockController->ScrollLockController.unlock(targetElement1)

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called once again after second lock", () => {
      switch (
        mockOnBodyScrollLockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollLock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock(targetElement1)
          scrollLockController->ScrollLockController.unlock(targetElement1)
          scrollLockController->ScrollLockController.lock(targetElement1)

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(2, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Isn't called multiple times after locking multiple elements", () => {
      switch (
        mockOnBodyScrollLockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollLock), Some(scrollLockController), Some(targetElement1)) => {
          let targetElement2 = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

          scrollLockController->ScrollLockController.lock(targetElement1)
          scrollLockController->ScrollLockController.lock(targetElement2)

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->JExp.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })
  })
})
