let {test, describe, beforeEach, fail} = module(Jest)
let {mock} = module(Jest.JestJs)
let {expect} = module(Jest.Expect)

mock("body-scroll-lock")

describe("Test ScrollLockController", () => {
  describe("When the onBodyScrollLock callback is passed", () => {
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

  describe("When the onBodyScrollUnlock callback is passed", () => {
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

    test("Isn't called after unlocking while body scroll isn't locked", () => {
      switch (
        mockOnBodyScrollUnlockRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnBodyScrollUnlock), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.unlock([targetElement1])

          expect(mockOnBodyScrollUnlock->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            0,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })
  })

  describe("When the onLockTargetsAdd callback is passed", () => {
    let mockOnLockTargetsAddRef = ref(None)
    let scrollLockControllerRef = ref(None)
    let targetElement1Ref = ref(None)

    beforeEach(() => {
      let mockOnLockTargetsAdd = Jest.JestJs.fn(_ => ())

      mockOnLockTargetsAddRef := Some(mockOnLockTargetsAdd)
      scrollLockControllerRef :=
        Some(ScrollLockController.make(~onLockTargetsAdd=mockOnLockTargetsAdd->Jest.MockJs.fn, ()))
      targetElement1Ref := Some(Webapi.Dom.Document.createElement("div", Webapi.Dom.document))
    })

    test("Isn't called right after creation", () => {
      switch (mockOnLockTargetsAddRef.contents, scrollLockControllerRef.contents) {
      | (Some(mockOnLockTargetsAdd), Some(_)) =>
        expect(mockOnLockTargetsAdd->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(0, _)
      | (_, _) => fail("Prepare stage failed")
      }
    })

    test("Is called once after lock call", () => {
      switch (
        mockOnLockTargetsAddRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsAdd), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])

          expect(mockOnLockTargetsAdd->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called once after lock call with multiple targetElements", () => {
      switch (
        mockOnLockTargetsAddRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsAdd), Some(scrollLockController), Some(targetElement1)) => {
          let targetElement2 = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

          scrollLockController->ScrollLockController.lock([targetElement1, targetElement2])

          expect(mockOnLockTargetsAdd->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called with provided targetElements", () => {
      switch (
        mockOnLockTargetsAddRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsAdd), Some(scrollLockController), Some(targetElement1)) => {
          let targetElement2 = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

          scrollLockController->ScrollLockController.lock([targetElement1, targetElement2])

          expect((mockOnLockTargetsAdd->Jest.MockJs.calls)[0])->Jest.Expect.toEqual(
            [targetElement1, targetElement2],
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test(
      "Is called with the only instance of targetElement if there are multiple same instances in the lock function",
      () => {
        switch (
          mockOnLockTargetsAddRef.contents,
          scrollLockControllerRef.contents,
          targetElement1Ref.contents,
        ) {
        | (Some(mockOnLockTargetsAdd), Some(scrollLockController), Some(targetElement1)) => {
            scrollLockController->ScrollLockController.lock([targetElement1, targetElement1])

            expect((mockOnLockTargetsAdd->Jest.MockJs.calls)[0])->Jest.Expect.toEqual(
              [targetElement1],
              _,
            )
          }
        | (_, _, _) => fail("Prepare stage failed")
        }
      },
    )

    test("Isn't called the second time if the targetElement is already locked", () => {
      switch (
        mockOnLockTargetsAddRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsAdd), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.lock([targetElement1])

          expect(mockOnLockTargetsAdd->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(1, _)
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })
  })

  describe("When the onLockTargetsRemove callback is passed", () => {
    let mockOnLockTargetsRemoveRef = ref(None)
    let scrollLockControllerRef = ref(None)
    let targetElement1Ref = ref(None)

    beforeEach(() => {
      let mockOnLockTargetsRemove = Jest.JestJs.fn(_ => ())

      mockOnLockTargetsRemoveRef := Some(mockOnLockTargetsRemove)
      scrollLockControllerRef :=
        Some(
          ScrollLockController.make(
            ~onLockTargetsRemove=mockOnLockTargetsRemove->Jest.MockJs.fn,
            (),
          ),
        )
      targetElement1Ref := Some(Webapi.Dom.Document.createElement("div", Webapi.Dom.document))
    })

    test("Isn't called right after creation", () => {
      switch (mockOnLockTargetsRemoveRef.contents, scrollLockControllerRef.contents) {
      | (Some(mockOnLockTargetsRemove), Some(_)) =>
        expect(mockOnLockTargetsRemove->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(0, _)
      | (_, _) => fail("Prepare stage failed")
      }
    })

    test("Is called once after unlock call", () => {
      switch (
        mockOnLockTargetsRemoveRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsRemove), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])

          expect(mockOnLockTargetsRemove->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            1,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called once after unlock call with multiple targetElements", () => {
      switch (
        mockOnLockTargetsRemoveRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsRemove), Some(scrollLockController), Some(targetElement1)) => {
          let targetElement2 = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

          scrollLockController->ScrollLockController.lock([targetElement1, targetElement2])
          scrollLockController->ScrollLockController.unlock([targetElement1, targetElement2])

          expect(mockOnLockTargetsRemove->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            1,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test("Is called with provided targetElements", () => {
      switch (
        mockOnLockTargetsRemoveRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsRemove), Some(scrollLockController), Some(targetElement1)) => {
          let targetElement2 = Webapi.Dom.Document.createElement("div", Webapi.Dom.document)

          scrollLockController->ScrollLockController.lock([targetElement1, targetElement2])
          scrollLockController->ScrollLockController.unlock([targetElement1, targetElement2])

          expect((mockOnLockTargetsRemove->Jest.MockJs.calls)[0])->Jest.Expect.toEqual(
            [targetElement1, targetElement2],
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })

    test(
      "Is called with the only instance of targetElement if there are multiple same instances in the unlock function",
      () => {
        switch (
          mockOnLockTargetsRemoveRef.contents,
          scrollLockControllerRef.contents,
          targetElement1Ref.contents,
        ) {
        | (Some(mockOnLockTargetsRemove), Some(scrollLockController), Some(targetElement1)) => {
            scrollLockController->ScrollLockController.lock([targetElement1])
            scrollLockController->ScrollLockController.unlock([targetElement1, targetElement1])

            expect((mockOnLockTargetsRemove->Jest.MockJs.calls)[0])->Jest.Expect.toEqual(
              [targetElement1],
              _,
            )
          }
        | (_, _, _) => fail("Prepare stage failed")
        }
      },
    )

    test("Isn't called the second time if the targetElement is already unlocked", () => {
      switch (
        mockOnLockTargetsRemoveRef.contents,
        scrollLockControllerRef.contents,
        targetElement1Ref.contents,
      ) {
      | (Some(mockOnLockTargetsRemove), Some(scrollLockController), Some(targetElement1)) => {
          scrollLockController->ScrollLockController.lock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])
          scrollLockController->ScrollLockController.unlock([targetElement1])

          expect(mockOnLockTargetsRemove->Jest.MockJs.calls->Js.Array2.length)->Jest.Expect.toBe(
            1,
            _,
          )
        }
      | (_, _, _) => fail("Prepare stage failed")
      }
    })
  })
})
