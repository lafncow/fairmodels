
#' Print ceteris paribus cutoff
#'
#' @param x ceteris_paribus_cutoff object
#' @param ... other print parameters
#'
#' @return
#' @export
#'
#' @examples
#'
#' library(DALEX)
#' library(ranger)
#'
#' data("compas")
#'
#' rf_compas  <- ranger(Two_yr_Recidivism ~., data = compas, probability = TRUE)
#' glm_compas <- glm(Two_yr_Recidivism~., data=compas, family=binomial(link="logit"))
#'
#' y_numeric <- as.numeric(compas$Two_yr_Recidivism)-1
#'
#' explainer_rf  <- explain(rf_compas, data = compas, y = y_numeric)
#' explainer_glm <- explain(glm_compas, data = compas, y = y_numeric)
#'
#' fobject <-create_fairness_object(explainer_glm, explainer_rf,
#'                                  outcome = "Two_yr_Recidivism",
#'                                  group = "Ethnicity",
#'                                  base = "Caucasian",
#'                                  cutoff = 0.5)
#'
#' ceteris_paribus_cutoff(fobject, "Asian")


print.ceteris_paribus_cutoff<- function(x, ...){

  list_of_objects   <- get_objects(list(x, ...), "ceteris_paribus_cutoff")
  data              <- extract_data(list_of_objects, "data")

  assert_different_label(list_of_objects)

  assert_equal_parameters(list_of_objects, "subgroup")
  assert_equal_parameters(list_of_objects, "cumulated")

  cat("\nCeteribus paribus cutoff for model:", x$subgroup, "\n")
  cat("\nFirst rows from data: \n")
  print(head(data))

  cat("\n")
  return(invisible(NULL))
}