## test check functions setup
library(checkmate)
library(LSAfun)
data(wonderland)
lower <- "easy"
upper <- "difficult"
words <- c("alice", "aluce", "rabbit", "hedgehogs", "elephant", "hatter")

### tests: assert_subset_delete_extras -----------------------------------------

test_that("words that are not in tvectors are deleted + message",{
  out <- assert_subset_delete_extras(words, tvectors = wonderland)
  
  expect_equal(out, c("alice", "rabbit", "hedgehogs", "hatter"))
  expect_message(assert_subset_delete_extras(words, tvectors = wonderland),
                 "The following words couldn't be found in your semantic space 'wonderland' and were deleted from 'words': aluce, elephant")
})

### tests: assert_word ---------------------------------------------------------

test_that("check_word works with factor and character input",{
  # data type
  expect_word("small")
  expect_word(as.factor("small"))
  expect_word((c("small", "large")))
  expect_word((c(factor("small"), factor("large"))))
  expect_equal(check_word(2), "Must be of type 'character' or 'factor', not 'double'")
  
  # length
  expect_true(check_word("small", len = 1))
  expect_equal(check_word("small", len = 2), "Must have length 2 but has length 1")
})

test_that("assert_word error messages are correct",{
  # data type
  expect_error(assert_word(2), "Must be of type 'character' or 'factor', not 'double'")
  
  # length
  expect_error(assert_word("small", len = 2), "Must have length 2 but has length 1")
})

