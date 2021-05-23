let {test, describe, beforeEach, fail} = module(Jest)
let {mock} = module(Jest.JestJs)
let {expect} = module(Jest.Expect)

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
        expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(0, _)
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
          scrollLockController->ScrollLockController.lock([targetElement1])

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(1, _)
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
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(1, _)
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
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])
          scrollLockController->ScrollLockController.lock([targetElement1])

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(2, _)
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

          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.lock([targetElement2])

          expect(mockOnBodyScrollLock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })
  })

  describe("Test onBodyScrollUnlock callback", () => {
    let mockOnBodyScrollUnlockRef = ref(None)
    let scrollLockControllerRef = ref(None)
    let targetElement1Ref = ref(None)

    beforeEach(() => {
      let mockOnBodyScrollUnlock = Jest.JestJs.fn(() => ())

      mockOnBodyScrollUnlockRef := Some(mockOnBodyScrollUnlock)
      scrollLockControllerRef :=
        Some(
          ScrollLockController.make(~onBodyScrollUnlock=mockOnBodyScrollUnlock->Jest.MockJs.fn, ()),
        )
      targetElement1Ref := Some(Webapi.Dom.Document.createElement("div", Webapi.Dom.document))
    })

    test("Isn't called right after creation", () => {
      switch (mockOnBodyScrollUnlockRef.contents, scrollLockControllerRef.contents) {
      | (Some(mockOnBodyScrollUnlock), Some(_)) =>
        expect(mockOnBodyScrollUnlock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(0, _)
      | (_, _) => fail("Prepare stage failed")
      }
    })

    test("Isn't called after lock", () => {
      switch (
        mockOnBodyScrollUnlockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollUnlock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])

          expect(mockOnBodyScrollUnlock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            0,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called after unlock", () => {
      switch (
        mockOnBodyScrollUnlockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollUnlock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])

          expect(mockOnBodyScrollUnlock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            1,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called once again after second unlock", () => {
      switch (
        mockOnBodyScrollUnlockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollUnlock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])

          expect(mockOnBodyScrollUnlock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            2,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Isn't called after locking multiple elements and unlocking some of them", () => {
      switch (
        mockOnBodyScrollUnlockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollUnlock), Some(scrollLockController), Some(targetElement1)) => {
          let targetElement2 = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.lock([targetElement2])
          scrollLockController->ScrollLockController.unlock([targetElement2])

          expect(mockOnBodyScrollUnlock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            0,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })
  })
})
