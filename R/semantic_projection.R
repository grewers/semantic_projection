## Function: semantic projection

# Print Method -----------------------------------------------------------------

print.SemDiff <- function(x, ...){
  # print a named vector
  out <- setNames(x$distances$scale_value_normed,
                  rownames(x$distances))
  print(out)
  invisible(x)
}
# function ---------------------------------------------------------------------

semantic_projection <- function(lower, upper, words, tvectors=tvectors){
  
  ### input validation
  # data type
  tvectors <- makeMatrix(tvectors)
  assert_word(lower, len = 1)
  assert_word(upper, len = 1)
  assert_word(words)
  lower <- as.character(lower)
  upper <- as.character(upper)
  words <- as.character(words)
  # chr in tvectors
  checkmate::assert_subset(lower, choices = rownames(tvectors))
  checkmate::assert_subset(upper, choices = rownames(tvectors))
  words <- assert_subset_delete_extras(words, tvectors)
  # lower != upper
  checkmate::assert_disjunct(lower, upper)
  
  ### get the vectors from tvectors
  upper_vector <- tvectors[upper,]
  lower_vector <- tvectors[lower,]
  word_vectors  <- tvectors[words,]
  
  ### orthogonal projection
  # find intercepts between points (word_vectors) and semantic differential from the orthogonal projection
  orthogonal_intercept <- StereoMorph::orthogonalProjectionToLine(word_vectors, l1 = lower_vector, l2 = upper_vector)
  rownames(orthogonal_intercept) <- words

  ### calculate distances to interpret semantic differential
  distance_lower <- StereoMorph::distancePointToPoint(lower_vector, orthogonal_intercept)
  distance_upper <- StereoMorph::distancePointToPoint(upper_vector, orthogonal_intercept)
  distance_scale <- StereoMorph::distancePointToPoint(lower_vector, upper_vector)
  
  distances <- data.frame(distance_to_lower = distance_lower,
                          distance_to_upper = distance_upper,
                          sum_distances = distance_lower + distance_upper, row.names = words)
  distances$distance_scale <- distance_scale

  ### calculate normed scale values
  scale_value <- numeric()
  for(i in 1:nrow(distances)){
    # between lower/upper
    if(distances$sum_distances[i] == distance_scale){
      scale_value[i] <- distance_lower[i]/distance_scale
    } # larger than upper
    else if ((distance_lower[i] > distance_scale) & (distance_lower[i] > distance_upper[i])){
      scale_value[i] <- distance_lower[i]/distance_scale
    } # smaller than lower 
    else if((distance_upper[i] > distance_scale) & (distance_lower[i] < distance_upper[i])){
      scale_value[i] <- -distance_lower[i]/distance_scale
    }
  }
  distances$scale_value <- scale_value

  colnames(distances) <- c(paste0("distance_to_", lower), paste0("distance_to_", upper),
                           "sum_distances", paste0("distance_", lower, "_", upper),
                           "scale_value_normed")
  
  ### output
  output <- list("intercepts" = orthogonal_intercept,
                 "distances" = distances)
  
  class(output) <- "SemDiff"
  return(output)
}



