#' Choose metric
#'
#' @description Choose metric creates \code{chosen_metric} object. It extract metric from metric data from fairness object.
#' It allows to visualize and compare chosen metric values across all models.
#'
#' @param x \code{fairness_object}
#' @param fairness_metric \code{char}, name of fairness metric, one of metrics:
#'
#' \itemize{
#'
#' \item TPR_parity_loss - parity loss of True Positive Rate (Sensitivity, Recall, Equal Odds)
#' \item TNR_parity_loss - parity loss of True Negative Rate (Specificity)
#' \item PPV_parity_loss - parity loss of Positive Predictive Value (Precision)
#' \item NPV_parity_loss - parity loss of Negative Predictive Value
#' \item FNR_parity_loss - parity loss of False Negative Rate
#' \item FPR_parity_loss - parity loss of False Positive Rate
#' \item FDR_parity_loss - parity loss of False Discovery Rate
#' \item FOR_parity_loss - parity loss of False Omission Rate
#' \item TS_parity_loss  - parity loss of Threat Score
#' \item ACC_parity_loss - parity loss of Accuracy
#' \item F1_parity_loss  - parity loss of F1 Score
#' \item MCC_parity_loss - parity loss of Matthews correlation coefficient
#' }
#'
#' @details some of metrics give same parity loss as others (for example TPR and FNR and that is because TPR = 1 - FNR)
#'
#' @return choose_metric object
#' @export choose_metric
#'
#' @examples
#'
#' data("german")
#'
#' y_numeric <- as.numeric(german$Risk) -1
#'
#' lm_model <- glm(Risk~.,
#'                 data = german,
#'                 family=binomial(link="logit"))
#'
#' rf_model <- ranger::ranger(Risk ~.,
#'                            data = german,
#'                            probability = TRUE,
#'                            num.trees = 200)
#'
#' explainer_lm <- DALEX::explain(lm_model, data = german[,-1], y = y_numeric)
#' explainer_rf <- DALEX::explain(rf_model, data = german[,-1], y = y_numeric)
#'
#' fobject <- fairness_check(explainer_lm, explainer_rf,
#'                           protected = german$Sex,
#'                           privileged = "male")
#'
#' cm <- choose_metric(fobject, "TPR")
#' plot(cm)
#'


choose_metric <- function(x, fairness_metric = "FPR"){

  stopifnot(class(x) == "fairness_object")
  assert_parity_metrics(fairness_metric)

  data                       <- cbind(x$parity_loss_metric_data[,fairness_metric], x$label)
  data                       <- as.data.frame(data)
  colnames(data)             <- c("parity_loss_metric", "label")
  data$parity_loss_metric    <- as.numeric(data$parity_loss_metric)


  choosen_metric <- list(parity_loss_metric_data = data,
                         metric = fairness_metric,
                         label  = x$label)

  class(choosen_metric) <- "chosen_metric"

  return(choosen_metric)
}













