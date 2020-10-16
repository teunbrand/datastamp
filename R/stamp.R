# User function -----------------------------------------------------------

#' Stamp an object with a datastamp
#'
#' A datastamp can contain relevant metadata about the circumstances an object
#' was created in. This function generates a datastamp and attaches it to an
#' object.
#'
#' @param object An R object to set a datastamp to.
#' @param origin_files A `character` vector of file paths.
#' @inheritParams make_stamp
#'
#' @details For Bioconductor objects in the S4Vectors framework, the datastamp
#'   is stored in the `metadata` slot instead of the attributes.
#'
#' @return The `object` input with a `datastamp` object in the attributes or
#'   metadata.
#' @export
#'
#' @seealso The \link[=set_stamp]{setters} and \link[=get_stamp]{getters} for
#'   datastamps. How to retrieve \link[=info_stamp]{specific information} from
#'   datastamped objects.
#'
#' @examples
#' stamp(1:5)
stamp <- function(object, origin_files = NULL,
                  script = NULL,
                  time = NULL,
                  system = NULL,
                  session = NULL) {
  stamp <- make_stamp(script = script, time = time, 
                      system = system, session = session,
                      files = origin_files)
  
  object <- set_stamp(object, stamp)
  return(object)
}

# Constructor -------------------------------------------------------------

#' Build a datastamp
#' 
#' Searches for relevant data to make a datastamp.
#'
#' @param script A `logical` to include the likely script of origin (default:
#'   `TRUE`).
#' @param time A `logical` to include a timestamp in the datastamp (default:
#'   `TRUE`).
#' @param system A `logical` to include system information (default: `TRUE`).
#' @param session A `logical` to include session information (default: `TRUE`)
#' @param files A `character` vector with file paths.
#'
#' @details When the `script`, `time`, `system` or `session` arguments are
#'   `NULL` the global options are searched for `"datastamp.*"` options, wherein
#'   the `*` is replaced by the argument names.
#'
#' @return A `list` of the class `datastamp`.
#' @export
#'
#' @examples
#' # Default stamp
#' stamp <- make_stamp()
#' 
#' # Not including some information:
#' make_stamp(session = FALSE)
#' 
#' # Alternatively:
#' options("datastamp.session" = FALSE)
#' make_stamp()
make_stamp <- function(
  script = NULL,
  time = NULL,
  system = NULL,
  session = NULL,
  files = NULL
) {

  script <-  script  %||% isTRUE(getOption("datastamp.script",  default = TRUE))
  time   <-  time    %||% isTRUE(getOption("datastamp.time",    default = TRUE))
  system <-  system  %||% isTRUE(getOption("datastamp.system",  default = TRUE))
  session <- session %||% isTRUE(getOption("datastamp.session", default = TRUE))
  
  script  <- if (isTRUE(script))  get_current_document() else NULL
  time    <- if (isTRUE(time))    Sys.time() else NULL
  system  <- if (isTRUE(system))  Sys.info() else NULL
  session <- if (isTRUE(session)) utils::sessionInfo() else NULL
  files   <- verify_files(files)
  
  stamp <- list(
    script  = script,
    time    = time,
    system  = system,
    session = session,
    files   = files
  )
  
  stamp <- stamp[lengths(stamp) > 0]
  
  stamp <- structure(
    stamp, class = c("datastamp", "list")
  )
  
  stamp
}

verify_files <- function(files) {
  if (!is.character(files) & !is.null(files)) {
    stop("The `origin_files` argument should be a character vector or `NULL`.",
         call. = FALSE)
  }
  
  exist   <- vapply(files, file.exists, logical(1))
  if (!all(exist)) {
    msg_missing <- glue::glue("Missing file: {files[!exists]}")
    msg_missing <- paste0(msg_missing, collapse = "\n")
    msg_missing <- paste0("Not all `origin_files` could be found.\n",
                          msg_missing)
    rlang::warn(msg_missing, 
                class = "Missing file")
  }
  if (length(files)) {
    normalizePath(files)
  } else {
    NULL
  }
}

# Stamp setters -----------------------------------------------------------

#' Stamp setter
#' 
#' Attaches a datastamp to an object.
#'
#' @param object An R object.
#' @param stamp A `datastamp` object.
#' 
#' @details For Bioconductor objects in the S4Vectors framework, the datastamp
#'   is stored in the `metadata` slot instead of the attributes.
#'
#' @return The `object` with a datastamp attached.
#' @export
#'
#' @examples
#' x <- 1:5
#' y <- make_stamp()
#' 
#' x <- set_stamp(x, y)
set_stamp <- function(object, stamp) {
  UseMethod("set_stamp", object)
}

#' @describeIn set_stamp Attaches `stamp` to `datastamp` attribute.
#' @export
set_stamp.default <- function(object, stamp) {
  stamp <- verify_stamp(stamp)
  attr(object, "datastamp") <- stamp
  object
}

#' @describeIn set_stamp Raises an error.
#' @export
set_stamp.datastamp <- function(object, stamp) {
  rlang::abort("Cannot set a datastamp on a datastamp object.")
}

#' @describeIn set_stamp Attaches `stamp` to list in `metadata` slot.
#' @export
set_stamp.Vector <- function(object, stamp) {
  stamp <- verify_stamp(stamp)
  attr(object, "metadata") <- c(attr(object, "metadata"), 
                                list("datastamp" = stamp))
  return(object)
}

# Stamp getters -----------------------------------------------------------

#' Retrieve stamp
#' 
#' If an object contains a datastamp, returns the datastamp.
#'
#' @param object An object.
#'
#' @return A `datastamp` object.
#' @export
#'
#' @examples
#' x <- stamp(1:5)
#' 
#' get_stamp(x)
get_stamp <- function(object) {
  UseMethod("get_stamp", object)
}

#' @describeIn set_stamp Retrieves the `"datastamp"` attribute.
#' @export
get_stamp.default <- function(object) {
  attr(object, "datastamp")
}

#' @describeIn set_stamp Retrieves the list-item named `"datastamp"` form the
#'   `metadata` slot.
#' @export
get_stamp.Vector <- function(object) {
  attr(object, "metadata")[["datastamp"]]
}

#' @describeIn set_stamp Returns `object` itself.
#' @export
get_stamp.datastamp <- function(object) {
  object
}


# Helpers -----------------------------------------------------------------

#' Type test for datastamp objects.
#' 
#' Test for objects of type `datastamp`.
#'
#' @param object An object.
#'
#' @return A `logical` of length 1.
#' @export
#'
#' @examples
#' obj <- stamp(1:5)
#' 
#' is_stamp(obj) # FALSE
#' 
#' is_stamp(get_stamp(obj)) # TRUE
is_stamp <- function(object) {
  rlang::inherits_all(object, c("datastamp", "list"))
}


verify_stamp <- function(stamp) {
  checknames <- all(names(stamp) %in% c("script", "time", 
                                        "system", "session", "files"))
  if (!checknames) {
    rlang::abort("The stamp has invalid names.", class = "Invalid stamp")
  }
  
  if (!is_stamp(stamp) | !checknames) {
    rlang::abort("The stamp is invalid.", class = "Invalid stamp")
  }
  stamp
}

#' @export
#' @noRd
#' @keywords internal
print.datastamp <- function(x, ...) {
  names <- names(x)
  names <- paste(names, collapse = ", ")
  names <- gsub("^(.*),(.*)$", "\\1 and\\2", names)
  cat(paste0("[datastamp] with ", names))
}
