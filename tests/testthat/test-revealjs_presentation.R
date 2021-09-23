test_that("toc argument works", {
  skip_if_not_pandoc()
  skip_if_not_installed("xml2")
  rmd <- local_temp_draft()
  html <- .render_and_read(
    rmd,
    output_options = list(
      toc = TRUE,
      pandoc_args = c(pandoc_variable_arg("toc-title", "TOC"))
    )
  )
  toc <- xml2::xml_find_all(html, "//section[@id='TOC']")
  expect_length(toc, 1)
  expect_equal(
    xml2::xml_text(
      xml2::xml_find_all(toc, "./nav/*[contains(@id, 'toc-title')]")
    ),
    "TOC"
  )
})
