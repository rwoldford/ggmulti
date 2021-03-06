#' @title Histogram for "widens" data under serial axes coordinate
#' @name geom_serialaxes_hist
#' @description Computes and draws histogram on serial axes coordinate for each non-aesthetics component
#' defined in the mapping \code{aes()}.
#' @inheritParams geom_serialaxes
#' @inheritParams geom_hist_
#' @export
#' @seealso \code{\link{geom_hist_}}, \code{\link{geom_serialaxes}},
#' \code{\link{geom_serialaxes_quantile}}, \code{\link{geom_serialaxes_density}}
#' @examples
#' p <- ggplot(iris, mapping = aes(Sepal.Length = Sepal.Length,
#'                                 Sepal.Width = Sepal.Width,
#'                                 Petal.Length = Petal.Length,
#'                                 Petal.Width = Petal.Width,
#'                                 colour = Species,
#'                                 fill = Species)) +
#'             geom_serialaxes(alpha = 0.2) +
#'             geom_serialaxes_hist(alpha = 0.5) +
#'             scale_x_continuous(breaks = 1:4,
#'                                labels = colnames(iris)[-5]) +
#'             scale_y_continuous(labels = NULL) +
#'             xlab("variable") +
#'             ylab("") +
#'             theme(axis.text.x = element_text(angle = 45, vjust = 0.5))
#' p
geom_serialaxes_hist <- function(mapping = NULL, data = NULL, stat = "serialaxes_hist",
                                 position = "stack_", ...,
                                 axes.sequence = character(0L),
                                 axes.position = NULL, merge = TRUE,
                                 scale.y = c("data", "variable"), as.mix = TRUE,
                                 positive = TRUE,
                                 adjust = 0.9, na.rm = FALSE, orientation = NA,
                                 show.legend = NA, inherit.aes = TRUE) {

  if (merge) {
    axes.sequence_aes <- suppressWarnings(
      ggplot2::aes_all(axes.sequence)
    )
    axes.sequence_names <- names(axes.sequence)

    if(!is.null(axes.sequence_names)) {
      names(axes.sequence_aes) <- axes.sequence_names
    }

    mapping <- suppressWarnings(
      mbind(
        axes.sequence_aes,
        mapping
      )
    )
  }

  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomSerialaxesHist,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    check.aes = FALSE,
    params = list(
      axes.sequence = axes.sequence,
      axes.position = axes.position,
      positive = positive,
      as.mix = as.mix,
      adjust = adjust,
      scale.y = match.arg(scale.y),
      na.rm = na.rm,
      orientation = orientation,
      ...
    )
  )
}

#' @rdname Geom-ggproto
#' @export
GeomSerialaxesHist <- ggplot2::ggproto(
  "GeomSerialaxesHist",
  GeomBar_,
  setup_data = function(self, data, params) {

    # Fix the Hack
    # Check function `serilaxes_compute_group`
    data <- data %>%
      dplyr::mutate(x = .x,
                    y = .y) %>%
      dplyr::select(-c(.x, .y))

    ggplot2::ggproto_parent(GeomBar_, self)$setup_data(data, params)
  }
)
