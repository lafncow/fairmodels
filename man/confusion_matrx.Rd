% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/confusion_matrix.R
\name{confusion_matrix}
\alias{confusion_matrix}
\title{Confusion matrix}
\usage{
confusion_matrix(probs, observed, cutoff)
}
\arguments{
\item{probs}{probabilities given by model}

\item{observed}{actual values from outcome}

\item{cutoff}{cutoff}
}
\value{
list that creates confusion matrix, of class \code{confussion_matrix}
}
\description{
Calculates confusion matrix for given cutoff
}
\examples{

probs    <- rnorm(20, 0.4,0.1)
observed <- round(runif(20))

confusion_matrix(probs, observed, 0.5)

}
