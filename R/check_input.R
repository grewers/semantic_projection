# check/cleaning function for tvectors -----------------------------------------

makeMatrix <- function(tvectors = tvectors){
  
  if(is.data.frame(tvectors)){
    tvectors <- as.matrix(tvectors)
  }else if(inherits(tvectors,"textmatrix")){
    tvectors <- matrix(tvectors,
                       nrow=nrow(tvectors),ncol=ncol(tvectors),
                       dimnames=list(as.character(rownames(tvectors)),colnames(tvectors)))
  }
  checkmate::assert_matrix(tvectors)
  return(tvectors)
}

### adding assert messages/functions -------------------------------------------

#' `check_word`
#' checks if something is a character or vector, including length

check_word = function(x, len = NULL){
  if(!(checkmate::test_character(x) | checkmate::test_factor(x))){
    return(paste0("Must be of type 'character' or 'factor', not '", typeof(x), "'"))
  } else if (!(checkmate::test_character(x, len = len) | checkmate::test_factor(x, len = len))){
    return(paste0("Must have length ", len, " but has length ", length(x)))
  } else
    return(TRUE)
} 
# Create the respective assert function
assert_word = makeAssertionFunction(check_word)
# and expect function
expect_word = makeExpectationFunction(check_word)


#' `deleting words` if they're not in tvectors

assert_subset_delete_extras <- function(words, tvectors){
  if(!(checkmate::test_subset(words, choices = rownames(tvectors)))){
    # identify which words are not in the subset
    miss <- setdiff(words, rownames(tvectors))
    # delete them from words
    words <- words[!words %in% miss]
    # write warning which words couldn't be found and were deleted
    miss <- paste(miss, collapse = ", ")
    message(paste0("The following words couldn't be found in your semantic space '", deparse(substitute(tvectors)), "' and were deleted from 'words': ", miss))
  } else {
    checkmate::assert_subset(words, choices = rownames(tvectors))
  }
  return(words)
}


