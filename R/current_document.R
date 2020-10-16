#' Guess the current document
#'
#' `get_current_document()` makes a guess at what the path to the current
#' document is. Returns the character `"console"` when it can't find the
#' document. This is a decent proxy for finding the document this function was
#' run in.
#'
#' @return A \code{character} with the path to the document
#' @export
#'
#' @details When executed interactively within RStudio, it reports the currently
#'   opened document at the time of execution. If the active document is
#'   switched between queuing this function and execution, the document of
#'   origin might be misreported.
#'
#' @examples
#' doc <- get_current_document()
get_current_document <- function() {
  
  if (interactive()) {
    
    if (rstudioapi::isAvailable()) {
      
      script <- rstudioapi::getActiveDocumentContext()
      
      if (nchar(script$path) == 0) {
        script <- script$id
      } else {
        script <- script$path
      }
      
    } else {
      
      script <- "#console"
      
    }
    
    script <- gsub("^#console$", "console", script)
    
  } else {
    
    script <- as.character(sys.call(1))[2]
    
  }
  
  return(script)
}
