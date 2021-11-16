#' Quick boxplot and summary statistics
#'
#' 'box_and_stats()' returns a boxplot and summary statistics (max, min, mean,
#'    median, standard deviation) for a dataset which contains categorical
#'    treatment groups and a measured numeric variable. This function was made
#'    to assess the body size of insects (or any measured numeric variable) from
#'    different experimental growth treatments.
#'
#' @param data a tidy data set. The data must be 'tidy' for this function to
#'    work, so each column must be a variable, each row must be a unique
#'    observation, and each cell must contain a single value.
#' @param x a column which contains different categorical treatments, and can be
#'    characters or factors. These are the treatments groups the measured
#'    variable will be divided into for analyses. The presence of NA values is
#'    not permitted.
#' @param y a column which contains the measured numeric variable. This is
#'    dependent variable the summary statistics will be calculated from. The
#'    presence of NA values is permitted, however they will be removed for analyses.
#' @return This function will return two items. The first item being a boxplot
#'    displaying the data from the numeric measured variable grouped by the
#'    identified treatments. The second item is a tibble containing 6 columns:
#'    1 column containing the different treatments, and 5 columns for the
#'    minimum, maximum, mean, median, and standard deviation for the measured
#'    variable from each treatment.
#' @examples
#'    box_and_stats(iris, Species, Sepal.Width)
#' @export

box_and_stats <- function(data, x, y) {

  x_data_check <- dplyr::summarise(data,
                                   is_character_x = is.character({{x}}) | is.factor({{x}}),
                                   class_x = class({{x}}))
  if(!x_data_check$is_character_x) {
    stop("Selected x-column is not character or factor, column is:", x_data_check$class_x)}

  y_data_check <- dplyr::summarise(data,
                                   is_numeric_y = is.numeric({{y}}),
                                   class_y = class({{y}}))
  if(!y_data_check$is_numeric_y) {
    stop("Selected y-column is not numeric, column is:", y_data_check$class_y)}

  data_to_analyze <- data %>%
    dplyr::mutate(fun_treatment = as.factor({{x}})) %>%
    dplyr::mutate(fun_bodysize = {{y}}) %>%
    dplyr::filter(fun_treatment != "NA") %>%
    dplyr::filter(fun_bodysize != "NA")

  quick_boxplot <- data_to_analyze %>%
    ggplot2::ggplot(mapping = ggplot2::aes(x=fun_treatment, y=fun_bodysize))+
    ggplot2::geom_boxplot(mapping = ggplot2::aes(x=fun_treatment,y=fun_bodysize),width=0.5)+
    ggplot2::geom_jitter(mapping = ggplot2::aes(x=fun_treatment, y=fun_bodysize), width = 0.1, alpha = 0.6)+
    ggplot2::theme_minimal()+
    ggplot2::ylab("Body size measure") +
    ggplot2::xlab("Treatment")

  quick_stats <- data_to_analyze %>%
    dplyr::group_by(fun_treatment) %>%
    dplyr::summarize(min = min(fun_bodysize),
                     max = max(fun_bodysize),
                     mean = mean(fun_bodysize),
                     median = median(fun_bodysize),
                     SD = sd(fun_bodysize))

  quick_results <- list(quick_boxplot, quick_stats)

  return(quick_results)

}

