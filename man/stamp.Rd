% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stamp.R
\name{stamp}
\alias{stamp}
\title{Stamp an object with a datastamp}
\usage{
stamp(
  object,
  origin_files = NULL,
  script = NULL,
  time = NULL,
  system = NULL,
  session = NULL
)
}
\arguments{
\item{object}{An R object to set a datastamp to.}

\item{origin_files}{A \code{character} vector of file paths.}

\item{script}{A \code{logical} to include the likely script of origin (default:
\code{TRUE}).}

\item{time}{A \code{logical} to include a timestamp in the datastamp (default:
\code{TRUE}).}

\item{system}{A \code{logical} to include system information (default: \code{TRUE}).}

\item{session}{A \code{logical} to include session information (default: \code{TRUE})}
}
\value{
The \code{object} input with a \code{datastamp} object in the attributes or
metadata.
}
\description{
A datastamp can contain relevant metadata about the circumstances an object
was created in. This function generates a datastamp and attaches it to an
object.
}
\details{
For Bioconductor objects in the S4Vectors framework, the datastamp
is stored in the \code{metadata} slot instead of the attributes.
}
\examples{
stamp(1:5)
}
\seealso{
The \link[=set_stamp]{setters} and \link[=get_stamp]{getters} for
datastamps. How to retrieve \link[=info_stamp]{specific information} from
datastamped objects.
}
