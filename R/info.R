#' @name info_stamp
#' @title Retrieve information from a datastamp
#'
#' @description These are convenience function for extracting information from a
#'   datastamp or object with a datastamp.
#'
#' @param object An object to retrieve information from.
#'
#' @return Either the requested information or `NULL` when the information
#'   couldn't be retrieved.
#'
#' @examples
#' x <- stamp(data.frame(x = 1:5, y = 5:1))
#' 
#' info_script(x)
#' info_time(x)
#' info_session(x)
#' info_system(x)
#' info_user(x)
#' info_version(x)
#' info_files(x)
NULL

#' @rdname info_stamp
#' @export
info_script <- function(object) {
  get_stamp(object)[["script"]]
}

#' @rdname info_stamp
#' @export
info_time <- function(object) {
  get_stamp(object)[["time"]]
}

#' @rdname info_stamp
#' @export
info_session <- function(object) {
  get_stamp(object)[["session"]]
}

#' @rdname info_stamp
#' @export
info_system <- function(object) {
  get_stamp(object)[["system"]]
}

#' @rdname info_stamp
#' @export
info_user <- function(object) {
  info_system(object)[c("user", "effective_user")]
}

#' @rdname info_stamp
#' @export
info_version <- function(object) {
  info_session(object)[["R.version"]]
}

#' @rdname info_stamp
#' @export
info_files <- function(object) {
  get_stamp(object)[["files"]]
}
