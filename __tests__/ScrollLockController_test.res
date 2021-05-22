open Jest

JestJs.mock("body-scroll-lock")

describe("ScrollLockController", () => {
  open Expect

  test("Locks are empty after create", () => {
    let scrollLockController = ScrollLockController.make()

    expect(scrollLockController.locks->ScrollLockController.LocksSet.isEmpty)->toBe(true, _)
  })

  test("Locks aren't empty after lock", () => {
    open Webapi.Dom

    let div = Document.createElement("div", document)
    let scrollLockController = ScrollLockController.make()

    scrollLockController->ScrollLockController.lock(div)

    expect(scrollLockController.locks->ScrollLockController.LocksSet.isEmpty)->toBe(false, _)
  })

  test("Locks are empty after lock and unlock", () => {
    open Webapi.Dom

    let div = Document.createElement("div", document)
    let scrollLockController = ScrollLockController.make()

    scrollLockController->ScrollLockController.lock(div)
    scrollLockController->ScrollLockController.unlock(div)

    expect(scrollLockController.locks->ScrollLockController.LocksSet.isEmpty)->toBe(true, _)
  })
})
