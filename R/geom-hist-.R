#' @title More general histogram
#' @name geom_hist_
#' @description More general histogram (\code{geom_histogram}) or bar plot (\code{geom_bar}).
#' Both \code{x} and \code{y} could be accommodated. See details
#'
#' @inheritParams geom_density_
#' @inheritParams ggplot2::geom_histogram
#' @inheritParams ggplot2::geom_bar
#' @param geom,stat Use to override the default connection between geom_hist_()/geom_histogram_()/geom_bar_() and
#' stat_hist_()/stat_bin_()/stat_count_().
#' @param position Position adjustment, either as a string, or the result of a call to a position adjustment function.
#' Function \code{geom_hist_} and \code{geom_histogram_} understand \code{stack_} (stacks bars on top of each other),
#' or \code{dodge_} and \code{dodge2_} (overlapping objects side-to-side) instead of \code{stack}, \code{dodge} or \code{dodge2}
#' @eval rd_orientation()
#' @seealso \code{\link{geom_histogram}}, \code{\link{geom_density_}}
#' @export
#' @importFrom tidyr pivot_longer
#' @details
#' \code{x} (or \code{y}) is a group variable and \code{y} (or \code{x}) a target variable to be plotted.
#' The result is a different histogram of \code{y} (\code{x}) for each value of \code{x} (\code{y}).
#' If only one of \code{x} or \code{y} is provided, it will be the target variable (no grouping) and
#' the standard \code{geom_histogram()} will be executed. Several things should be noticed:
#'
#' 1. If both \code{x} and \code{y} are given, they can be one discrete one continuous or
#' two discrete. But they cannot be two continuous variables (which one will be considered as a group variable?).
#'
#' 2. \code{geom_hist_} is a wrapper of \code{geom_histogram_} and \code{geom_count_}. In other words, suppose the \code{y} is our interest,
#' \code{geom_hist_()} can accommodate both continuous or discrete "y" but \code{geom_histogram_()} is only for the continuous \code{y} and
#' \code{geom_bar_()} is only for the discrete \code{y}.
#'
#' 3. There are four combinations of \code{scale.y} and \code{as.mix}
#' \describe{
#'   \item{\code{scale.y} = "variable" and \code{as.mix} = FALSE}{The density estimates area of each group under the same variable
#'   is the same and scaled to maximum of 1.}
#'   \item{\code{scale.y} = "variable" and \code{as.mix} = TRUE}{The density estimates area of each group under the same variable
#'   is proportional to its own counts (over this variable).}
#'   \item{\code{scale.y} = "data" and \code{as.mix} = FALSE}{The sum of density estimates area of all group is scaled to maximum of 1.
#'   The sum of the density area for each variable is proportional to the its counts (over the whole dataset).
#'   Under each variable, the area of each group is the same.}
#'   \item{\code{scale.y} = "data" and \code{as.mix} = TRUE}{The sum of density estimates area of all group is scaled to maximum of 1
#'   and the area of each group is proportional to its own count.}
#' }
#' Note that, if it is a grouped bar chart (both \code{x} and \code{y} are categorical),
#' parameter `as.mix` is useless.
#'
#' @examples
#' if(require(dplyr) && require(tidyr)) {
#'
#'   # histogram
#'   p0 <- mpg %>%
#'     dplyr::filter(manufacturer %in% c("dodge", "ford", "toyota", "volkswagen")) %>%
#'     ggplot(mapping = aes(x = manufacturer, y = cty))
#'   p0 + geom_hist_()
#'
#'   ## set position
#'   #### default is "stack_"
#'   p0 + geom_hist_(mapping = aes(fill = fl))
#'   #### "dodge_"
#'   p0 + geom_hist_(position = "dodge_",
#'                   mapping = aes(fill = fl))
#'   #### "dodge2_"
#'   p0 + geom_hist_(position = "dodge2_",
#'                   mapping = aes(fill = fl))
#'
#'   # bar chart
#'   mpg %>%
#'     ggplot(mapping = aes(x = drv, y = class)) +
#'     geom_hist_(orientation = "y")
#'
#'   # scale.y as "variable"
#'   p <- iris %>%
#'     tidyr::pivot_longer(cols = -Species,
#'                         names_to = "Outer sterile whorls",
#'                         values_to = "x") %>%
#'     ggplot(mapping = aes(x = `Outer sterile whorls`,
#'                          y = x, fill = Species)) +
#'     stat_hist_(scale.y = "variable",
#'                adjust = 0.6,
#'                alpha = 0.5)
#'   p
#'   # with density on the left
#'   p + stat_density_(scale.y = "variable",
#'                     adjust = 0.6,
#'                     alpha = 0.5,
#'                     positive = FALSE)
#'
#'   ########### only `x` or `y` is provided ###########
#'   # that would be equivalent to call function
#'   # `geom_histogram()` or `geom_bar()`
#'   ### histogram
#'   diamonds %>%
#'     dplyr::sample_n(500) %>%
#'     ggplot(mapping = aes(x = price)) +
#'     geom_hist_()
#'   ### bar chart
#'   diamonds %>%
#'     dplyr::sample_n(500) %>%
#'     ggplot(mapping = aes(x = cut)) +
#'     geom_hist_()
#' }
geom_hist_ <- function(mapping = NULL, data = NULL, stat = "hist_",
                       position = "stack_", ...,
                       scale.x = NULL, scale.y = c("data", "variable"), as.mix = FALSE,
                       binwidth = NULL, bins = NULL, positive = TRUE,
                       adjust = 0.9, na.rm = FALSE, orientation = NA,
                       show.legend = NA, inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBar_,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    check.aes = TRUE,
    params = list(
      scale.x = scale.x,
      scale.y = match.arg(scale.y),
      as.mix = as.mix,
      positive = positive,
      adjust = adjust,
      binwidth = binwidth,
      bins = bins,
      na.rm = na.rm,
      orientation = orientation,
      ...
    )
  )
}

#' @rdname geom_hist_
#' @export
#'
geom_histogram_ <- function(mapping = NULL, data = NULL, stat = "bin_",
                            position = "stack_", ...,
                            scale.x = NULL, scale.y = c("data", "variable"), as.mix = FALSE,
                            positive = TRUE, adjust = 0.9,
                            binwidth = NULL, bins = NULL, na.rm = FALSE, orientation = NA,
                            show.legend = NA, inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBar_,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    check.aes = TRUE,
    params = list(
      positive = positive,
      scale.x = scale.x,
      scale.y = match.arg(scale.y),
      adjust = adjust,
      binwidth = binwidth,
      bins = bins,
      as.mix = as.mix,
      na.rm = na.rm,
      orientation = orientation,
      ...
    )
  )
}

#' @rdname geom_hist_
#' @export
#'
geom_bar_ <- function(mapping = NULL, data = NULL, stat = "count_",
                      position = "stack_", ...,
                      scale.x = NULL, scale.y = c("data", "variable"),
                      positive = TRUE, adjust = 0.9,
                      na.rm = FALSE, orientation = NA,
                      show.legend = NA, inherit.aes = TRUE) {

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomBar_,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    check.aes = TRUE,
    params = list(
      positive = positive,
      scale.x = scale.x,
      scale.y = match.arg(scale.y),
      adjust = adjust,
      na.rm = na.rm,
      orientation = orientation,
      ...
    )
  )
}

#' @rdname Geom-ggproto
#' @export
GeomBar_ <- ggplot2::ggproto(
  "GeomBar_",
  ggplot2::GeomBar,
  setup_params = function(data, params) {

    params$flipped_aes <- has_flipped_aes(data, params, range_is_orthogonal = TRUE)

    params$positive <- params$positive %||% TRUE
    params$adjust <- params$adjust %||% 0.9

    params$scale.y <- params$scale.y %||% "data"
    params$as.mix <- params$as.mix %||% FALSE
    if(!is.null(params$scale.x)) {
      if(!all(is.numeric(params$scale.x)))
        stop("`scale.x` must be numerical, but it is ", class(params$scale.x),
             call. = FALSE)
      if(length(params$scale.x) != 2)
        stop("`scale.x` should be a length 2 vector, but it has length ", length(params$scale.x),
             call. = FALSE)
    }

    params
  },
  setup_data = function(self, data, params) {

    acceptBoth <- na.omit(data$acceptBoth)[1L]

    data <- data %>%
      dplyr::filter(count > 0) %>%
      dplyr::mutate(positive = params$positive) %>%
      ggplot2::flip_data(params$flipped_aes)

    data$width <- data$width %||% params$width %||%
      (resolution(data$x, FALSE) * params$adjust)

    if(!acceptBoth) {
      data <- ggplot2::flip_data(data, params$flipped_aes)
      return(
        ggplot2::ggproto_parent(
          ggplot2::GeomBar,
          self)$setup_data(data, params)
      )
    }

    if(!is.null(params$scale.x)) {

      ranges <- data %>%
        dplyr::group_by(location) %>%
        dplyr::summarise(range = diff(range(x, na.rm = TRUE)))
      max_range <- max(ranges$range, na.rm = TRUE)

      # y is location so far
      data <- data %>%
        dplyr::group_by(location) %>%
        dplyr::mutate(width = width/(max_range),
                      x = rescale(x, params$scale.x)) %>%
        dplyr::ungroup()
    }

    y <- data$count

    if(params$as.mix) {

      area <- data %>%
        dplyr::group_by(location) %>%
        dplyr::summarise(area = sum(count * width)) %>%
        dplyr::right_join(data, by = "location")

      y <- y/area$area

    } else {
      # bar chart would not work here (if so, all bars would be the same length)
      # only histogram can produce the density
      if(!is.null(data$density)) {
        y <- data$density
      }
    }

    data$y <- y

    data %>%
      compute_scales("histogram", params) %>%
      dplyr::mutate(ymin = pmin(y, 0),
                    ymax = pmax(y, 0),
                    xmin = x - width / 2,
                    xmax = x + width / 2) %>%
      ggplot2::flip_data(params$flipped_aes)
  },

  draw_panel = function(self, data, panel_params, coord, scale.y = c("data", "variable"),
                        scale.x = NULL, as.mix = FALSE, positive = TRUE, width = NULL,
                        adjust = 0.9, na.rm = FALSE) {

    # Hack to ensure that width, positive, scale.y, scale.x, adjust and as.mix are detected as parameters
    ggplot2::ggproto_parent(ggplot2::GeomBar, self)$draw_panel(data, panel_params, coord)
  }
)
