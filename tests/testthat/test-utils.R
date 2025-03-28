test_that("reveal options are passed as pandoc variables", {
  expect_equal(process_reveal_option("a", "b"), pandoc_variable_arg("a", "b"))
})

test_that("reveal options with boolean are transformed to JS bool", {
  expect_equal(
    process_reveal_option("a", TRUE),
    pandoc_variable_arg("a", "true")
  )
  expect_equal(
    process_reveal_option("a", FALSE),
    pandoc_variable_arg("a", "false")
  )
})

test_that("reveal options slideNumbers is treated specifically", {
  expect_equal(
    process_reveal_option("slideNumber", "c/t"),
    pandoc_variable_arg("slideNumber", "'c/t'")
  )
  expect_equal(
    process_reveal_option("slideNumber", TRUE),
    pandoc_variable_arg("slideNumber", "true")
  )
})

test_that("reveal options width / heigh in % are quoted", {
  expect_equal(
    process_reveal_option("width", "50%"),
    pandoc_variable_arg("width", "'50%'")
  )
  expect_equal(
    process_reveal_option("height", "50%"),
    pandoc_variable_arg("height", "'50%'")
  )
  expect_equal(
    process_reveal_option("width", 5),
    pandoc_variable_arg("width", "5")
  )
  expect_equal(
    process_reveal_option("height", 5),
    pandoc_variable_arg("height", "5")
  )
})

test_that("reveal options for chalkboard plugins special handling", {
  expect_equal(
    process_reveal_option("chalkboard-background", "rgba(255,255,255,0.5)"),
    pandoc_variable_arg("chalkboard-background", "['rgba(255,255,255,0.5)']")
  )
  expect_equal(
    process_reveal_option(
      "chalkboard-background",
      "['rgba(127,127,127,.1)', path + 'img/blackboard.png' ]"
    ),
    pandoc_variable_arg(
      "chalkboard-background",
      "['rgba(127,127,127,.1)', path + 'img/blackboard.png' ]"
    )
  )
  expect_equal(
    process_reveal_option("chalkboard-draw", c("a", "b")),
    pandoc_variable_arg("chalkboard-draw", "['a', 'b']")
  )
  expect_equal(
    process_reveal_option("chalkboard-other", "dummy"),
    pandoc_variable_arg("chalkboard-other", "dummy")
  )
})

test_that("reveal options for autoAnimateStyles handling", {
  expect_equal(
    process_reveal_option("autoAnimateStyles", "padding"),
    pandoc_variable_arg("autoAnimateStyles", "['padding']")
  )
  expect_equal(
    process_reveal_option("autoAnimateStyles", c("color", "padding")),
    pandoc_variable_arg("autoAnimateStyles", "['color', 'padding']")
  )
})

test_that("revealjs lib path is found in package", {
  expect_match(revealjs_lib_path(), "revealjs/(inst/)?reveal\\.js-")
  expect_true(dir.exists(revealjs_lib_path()))
})

test_that("Version of revealjs can be retrieved", {
  expect_s3_class(revealjs_version(), "numeric_version")
})
