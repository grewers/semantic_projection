\name{semantic_projection}
\alias{semantic_projection}
\title{Calculate Semantic Projection}
\encoding{latin1}

\description{
Calculate the semantic projection from any set of \code{words} from you lsa semantic space onto a new one dimensional scale called "semantic differential". 

The semantic differential can be used to differentiate attributes (like size) between the given set of \code{words}. 
It is created with two words (\code{lower} and \code{upper}) which have to be in your semantic space, too. You calculate a new vector with these two words onto which you orthogonally project the set of \code{words} you specified.
}

\usage{
semantic_projection(lower, upper, words, tvectors=tvectors)
}

\arguments{
  \item{lower}{A \code{string} containing the lower end of the semantic differential.}
  \item{upper}{A \code{string} containing the upper end of the semantic differential.}
  \item{words}{A \code{character} vector containing any words you want to project.}
  \item{tvectors}{A \code{numeric matrix} representing the semantic space or word embedding, each row represents the vector of a word.}
}

\details{
The function returns a \code{list} with 2 objects: 

A \code{matrix} "x$intercepts" that contains the coordinates of the intercepts: 
\itemize{
\item Each row is a vector indicating where a word intercepts the given semantic differential (calculated from \code{lower} and \code{upper}) of the semantic space. 
}
And a \code{data.frame} "x$distances" with five columns containing information about where each word intercepts the semantic differential:
\itemize{
\item \code{distance_to_lower}: Absolute distances between the intercepts and the vector \code{lower}, the name is adjusted to contain the given string. 
\item \code{distance_to_upper}: Absolute distances between the intercepts and the vector \code{upper}, the name is adjusted to contain the given string. 
\item \code{distance_lower_upper}: Absolute distance between the two vectors \code{lower} and \code{upper}, the name is adjusted to contain the given strings. 
\item \code{sum_distances}: Sum of \code{distance_to_lower} and \code{distance_to_upper}. If they are larger than \code{distance_lower_upper} that means the intercept for that particular word is not between the two vectors, but outside of it. For instance, if the semantic differential is "small-large" an object might be smaller than small, or larger than large, according to your semantic space. 
\item \code{scale_value_normed}: Normed scale value for interpretable distances. A value between \code{0-1} indicates the intercept is between the two vectors given for the semantic differential, a number \code{x < 0} indicates the intercept is outside the vectors on the \code{lower} side (e.g. smaller than "small"), a number \code{x > 1} indicates the intercept is outside the vectors on the \code{upper} side (e.g. larger than "large").
}

Be mindful that the words you choose for the semantic differential a part of a larger concept, for instance, you could create the scale "size" with the words "small" and "large". But any combination of words is possible, as long as they are part of your semantic space.
}

\value{Prints a \code{named vector} to the console with the normed scale value of the intercepts. 

Creates a \code{list} object with a \code{matrix} containing the vectors of the intercepts on the semantic differential for each valid word given, and a \code{data.frame} with the absolute distances, as well as a normed scale value indicating where each word intercepts the semantic differential.} 

\author{
Edna Grewers
}

\references{Grand, G., Blank, I. A., Pereira, F., & Fedorenko, E. (2022). Semantic projection recovers rich human knowledge of multiple object features from word embeddings. \emph{Nature Human Behaviour, 6}(7), 975-987.

\url{https://doi.org/10.1038/s41562-022-01316-8}
}

\note{}

\examples{library(LSAfun)
data(wonderland)
semDiff <- semantic_projection(lower = "easy", upper = "difficult", words = c("alice", "aluce", "rabbit", "hedgehogs", "elephant", "hatter"), tvectors=wonderland)
semDiff
semDiff$intercepts
semDiff$distances}