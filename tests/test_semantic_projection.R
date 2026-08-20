## tests for semantic_projection()

## setup -----------------------------------------------------------------------
library(LSAfun)
data(wonderland)
lower <- "easy"
upper <- "difficult"
words <- c("alice", "aluce", "rabbit", "hedgehogs", "elephant", "hatter")

### test type/structure of the output object -----------------------------------

test_that("default prints a named vector", { 
  out <- semantic_projection(lower, upper, words, tvectors = wonderland)
  out_print <- setNames(out$distances$scale_value_normed,
                  rownames(out$distances))
  
  expect_named(out_print, c("alice", "rabbit", "hedgehogs", "hatter"))
  expect_equal(round(out_print, 7), setNames(c(0.5516814, 0.2664333, 0.4221557, 0.4241784), c("alice", "rabbit", "hedgehogs", "hatter")))
  expect_equal(capture_output(out, print = TRUE), "    alice    rabbit hedgehogs    hatter \n0.5516814 0.2664333 0.4221557 0.4241784 ")
})

test_that("creates a list: [1] intercepts (matrix), [2] distances (data.frame)", {
  out <- semantic_projection(lower, upper, words, tvectors = wonderland)
  
  checkmate::expect_class(out, "SemDiff")
  checkmate::expect_list(out, len = 2)
  expect_named(out, c("intercepts", "distances"))
  checkmate::expect_matrix(out$intercepts)
  checkmate::expect_data_frame(out$distances)
})

### test content of list entries -----------------------------------------------

test_that("test output of distances", {
  out <- semantic_projection(lower, upper, words, tvectors = wonderland)
  
  expect_equal(rownames(out$distances), c("alice", "rabbit", "hedgehogs", "hatter"))
  expect_equal(colnames(out$distances), c("distance_to_easy", "distance_to_difficult", "sum_distances", "distance_easy_difficult", "scale_value_normed"))
  expect_equal(out$distances[,"distance_to_easy"], c(0.13206367, 0.06377987, 0.10105731, 0.10154151))
  expect_equal(round(out$distances[,"distance_to_difficult"], 7), c(0.1073203, 0.1756041, 0.1383267, 0.1378425))
  expect_equal(round(out$distances[,"sum_distances"], 6), c(0.239384, 0.239384, 0.239384, 0.239384))
  expect_equal(round(out$distances[1,"distance_easy_difficult"], 6), 0.239384)
  expect_equal(round(out$distances[,"scale_value_normed"], 7), c(0.5516814, 0.2664333, 0.4221557, 0.4241784))
})

test_that("test output of intercepts", {
  out <- semantic_projection(lower, upper, words, tvectors = wonderland)
  
  expect_equal(rownames(out$intercepts), c("alice", "rabbit", "hedgehogs", "hatter"))
  expect_type(out$intercepts, "double")
})

test_that("works with factor input", {
  lower_factor <- as.factor(lower)
  upper_factor <- as.factor(upper)
  words_factor <- factor(x = words, levels = words)
  
  out <- semantic_projection(lower_factor, upper_factor, words_factor, tvectors = wonderland)
  
  expect_equal(rownames(out$distances), c("alice", "rabbit", "hedgehogs", "hatter"))
  expect_equal(colnames(out$distances), c("distance_to_easy", "distance_to_difficult", "sum_distances", "distance_easy_difficult", "scale_value_normed"))
  expect_equal(out$distances[,"distance_to_easy"], c(0.13206367, 0.06377987, 0.10105731, 0.10154151))
  expect_equal(round(out$distances[,"distance_to_difficult"], 7), c(0.1073203, 0.1756041, 0.1383267, 0.1378425))
  expect_equal(round(out$distances[,"sum_distances"], 6), c(0.239384, 0.239384, 0.239384, 0.239384))
  expect_equal(round(out$distances[1,"distance_easy_difficult"], 6), 0.239384)
  expect_equal(round(out$distances[,"scale_value_normed"], 7), c(0.5516814, 0.2664333, 0.4221557, 0.4241784))
})

### test orthogonal projection -------------------------------------------------

test_that("projected vectors are orthogonal to the semantic differential",{
  upper_vector <- wonderland[upper,]
  lower_vector <- wonderland[lower,]
  word_vectors  <- wonderland[c("alice", "rabbit", "hedgehogs", "hatter"),]
  sem_differential <- upper_vector - lower_vector
  # order of the points of the line doesn't matter
  orthogonal_intercept <- StereoMorph::orthogonalProjectionToLine(word_vectors, l1 = lower_vector, l2 = upper_vector)
  rownames(orthogonal_intercept) <- c("alice", "rabbit", "hedgehogs", "hatter")
  
  expect_equal(rownames(orthogonal_intercept), c("alice", "rabbit", "hedgehogs", "hatter"))
  
  # create vector lines
  orthogonal_vectors <- orthogonal_intercept - word_vectors
  expect_equal(rownames(orthogonal_vectors), c("alice", "rabbit", "hedgehogs", "hatter"))
  
  # test if they're orthogonal to the semantic differential
  result <- numeric(nrow(orthogonal_intercept))
  for(i in 1:length(result)){
    result[i] <- sem_differential %*% orthogonal_vectors[i,]
  }
  expect_equal(result, c(0, 0, 0, 0))
})
