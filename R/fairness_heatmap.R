#' Fairness heatmap
#'
#' @description  Create fairness_heatmap object to compare both models and metrics. If parameter \code{scale} is set to \code{TRUE} metrics will be scaled to median = 0 and sd = 1.
#' If NA's appear heatmap will still plot, but with gray area where NA's were.
#'
#' @param x \code{fairness_object}
#' @param scale logical, if code{TRUE} metrics will be scaled to mean 0 and sd 1. Default \code{FALSE}
#'
#' @return \code{fairness_heatmap} object
#' @export
#' @rdname fairness_heatmap
#'
#' @examples
#'
#' library(ranger)
#' library(DALEX)
#' data(compas)
#'
#' # models
#' y_numeric <- as.numeric(compas$Two_yr_Recidivism)-1
#'
#' rf_compas_1 <- ranger(Two_yr_Recidivism ~Number_of_Priors+Age_Below_TwentyFive, data = compas, probability = TRUE)
#' model_compas_lr <- glm(Two_yr_Recidivism~., data=compas, family=binomial(link="logit"))
#' rf_compas_5 <- ranger(Two_yr_Recidivism ~., data = compas, probability = TRUE)
#' rf_compas_6 <- ranger(Two_yr_Recidivism ~ Age_Above_FourtyFive+Misdemeanor, data = compas, probability = TRUE)
#' rf_compas_7 <- ranger(Two_yr_Recidivism ~., data = compas, probability = TRUE)
#' rf_compas_8 <- ranger(Two_yr_Recidivism ~ Sex+Age_Above_FourtyFive+Misdemeanor+Ethnicity, data = compas, probability = TRUE)
#'
#' # explainers
#' explainer_1 <- explain(rf_compas_1, data = compas, y = y_numeric)
#' explainer_4 <- explain(model_compas_lr, data = compas, y = y_numeric)
#' explainer_5 <- explain(rf_compas_5, data = compas, y = y_numeric)
#' explainer_6 <- explain(rf_compas_6, data = compas, y = y_numeric)
#' explainer_7 <- explain(rf_compas_7, data = compas, y = y_numeric)
#'
#' # different labels
#' explainer_4$label <- "glm"
#' explainer_5$label <- "rf5"
#' explainer_6$label <- "rf6"
#' explainer_7$label <- "rf7"
#'
#'
#' fobject <- create_fairness_object(explainer_1,explainer_4,explainer_5,explainer_6,explainer_7,
#'                                   outcome = "Two_yr_Recidivism",
#'                                   group  = "Ethnicity",
#'                                   base   = "Caucasian",
#'                                   cutoff = 0.5)
#'
#' fheatmap <- fairness_heatmap(fobject)
#'
#' plot(fheatmap)


fairness_heatmap <- function(x, scale = FALSE){

  stopifnot(class(x) == "fairness_object")
  if (length(x$explainers) < 2 ) stop("Number of explainers must be more than 1")

  # expanding data to fir geom_tile convention
  data <- expand_fairness_object(x, scale = scale)
  data <- as.data.frame(data)

  colnames(data) <- c("metric","model","score")

  data$metric <- as.factor(data$metric)
  data$model  <- as.factor(data$model)
  data$score  <- round(as.numeric(data$score),2)

  # getting numerical data and if scale, scaling it
  matrix_model            <- as.matrix(x$metric_data)
  if (scale) matrix_model <- scale(matrix_model)

  rownames(matrix_model)  <- x$label

  fairness_heatmap <- list(data    = data,
                           matrix_model    = matrix_model,
                           scale           = scale,
                           label = x$label)

  class(fairness_heatmap) <- "fairness_heatmap"
  return(fairness_heatmap)
}






