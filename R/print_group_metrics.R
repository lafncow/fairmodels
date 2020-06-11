#' Print group metric
#'
#' @param x \code{group_metric} object
#' @param ... other print parameters
#'
#' @export
#' @rdname print_group_metri
#'
#' @examples
#'
#' library(DALEX)
#' library(ranger)
#' data("compas")
#' y_numeric <- as.numeric(compas$Two_yr_Recidivism)-1
#'
#' rf_1 <- ranger(Two_yr_Recidivism ~., data = compas, probability = TRUE)
#' lr_1 <- glm(Two_yr_Recidivism~., data=compas, family=binomial(link="logit"))
#'
#' explainer_1 <- explain(rf_1, data = compas, y = y_numeric)
#' explainer_2 <- explain(lr_1, data = compas, y = y_numeric)
#'
#' fo <- create_fairness_object(explainer_1, explainer_2,  outcome = "Two_yr_Recidivism", group = "Ethnicity", base = "Caucasian"  )
#'
#' group_metric(fo, fairness_metric = "FPR", performance_metric = "auc")

print.group_metric <- function(x, ...){

  list_of_objects    <- get_objects(list(x, ...), "group_metric")
  data_list          <- lapply(list_of_objects, function(x) x$fairness_data)
  fairness_data      <- do.call("rbind", data_list)
  data_list          <- lapply(list_of_objects, function(x) x$performance_data)
  performance_data   <- do.call("rbind", data_list)



  cat("Fairness data top rows for", x$y_label, "\n")
  print(head(fairness_data))
  cat("\n")

  cat("Performance data for", x$performance_metric, ":")

  perf_df <- performance_data
  colnames(perf_df) <- NULL
  print(perf_df)

  cat("\n")
  return(invisible(NULL))
}