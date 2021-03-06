% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_path.R
\name{read_path}
\alias{read_path}
\title{Read path coordinates from raw data formats.}
\usage{
read_path(
  filename,
  arena,
  id = NULL,
  track.format = "none",
  track.index = NULL,
  interpolate = FALSE,
  time.bounds = c(NA, NA)
)
}
\arguments{
\item{filename}{A raw data file containing path coordinates. See details for supported
formats.}

\item{arena}{The \code{arena} object associated with this track. This is required to
calibrate the track coordinates to the coordinate space of the arena.}

\item{id}{An optional name for the experiment. Default is to generate this from the
filename provided.}

\item{track.format}{The format of the raw file.}

\item{track.index}{Only for formats where multiple tracks are stored in one file
(ignored otherwise). This parameter indicates which section of the file corresponds
to the track to be read. The exact usage depends on the format being read.}

\item{interpolate}{Should missing data points be interpolated. Default is \code{FALSE}.
Interpolation is performed at evenly-spaced intervals after removing outliers.}

\item{time.bounds}{A vector of length 2 specifying the bounds on the measurement times
(see Details).}
}
\value{
An \code{rtrack_path} object containing the extracted swim path. This is a list
  comprised of the components \code{raw.t} (timestamp), \code{raw.x} (x coordinates),
  \code{raw.y} (y coordinates),\code{t}, \code{x} and \code{y} (normalised, cleaned and
  possibly interpolated coordinates).
}
\description{
The user will normally not need to call this directly. Use
\code{\link{read_experiment}} instead.
}
\details{
Raw data from several sources can be read in directly. The formats currently supported
are 'ethovision.xt.excel' (for swim paths exported from the latest Ethovision
software), 'ethovision.3.csv' (for data exported from the older Ethovision version 3)
and 'raw.csv'. The 'raw.csv' format is a simple comma-delimited text file containing
three columns 'Time', 'X' and 'Y'. The timestamp values in 'Time' should be in seconds
from the start of the trial recording and coordinates should be in real-world units
(e.g. cm, in).

If \code{interpolate} is set to \code{TRUE}, then the raw data will be cleaned to
remove outlier points and ensure that time points are evenly spaced. The following
procedures are used: 1. any points with missing coordinate data are removed; 2. any
points lying outside the arena are removed: 3. any points with excessive inter-point
distances (outliers) are removed by first removing points that are more than 1 SD from
the mean distance, then recalculating the mean and SD and repeating this step - this is
typically sufficient to remove noise from video tracking (such as reflections from a
water maze pool); 4. new time intervals are calculated from the first non-missing data
point to the last using the sampling rate of the raw data; 5. interpolation of x and y
values is performed at the new time points using the 'constant' interpolation method
from \code{\link[stats]{approx}}.

The raw path recordings can be truncated if necessary by specifying the
\code{time.bounds} parameter. This is a vector of length 2 containing the earliest and
latest time points that should be retained for analysis (any points outside these
bounds will be discarded). A value of \code{NA} indicates that the path should not be
truncated at that end (default is \code{c(NA, NA)} meaning that the path will extend to
the start and end of the recorded values). The units used must match the time units in
the track files. This option should not normally need to be set, but may be useful if
data acquisition begins before, or ends after, the actual experimental trial (e.g. if
recording was running during entry and exit from the arena).
}
\examples{
require(Rtrack)
track_file <- system.file("extdata", "Track_1.csv", package = "Rtrack")
arena_description <- system.file("extdata", "Arena_SW.txt", package = "Rtrack")
arena <- read_arena(arena_description)
path <- read_path(track_file, arena, track.format = "ethovision.3.csv")

}
\seealso{
\code{\link{read_arena}}, \code{\link{identify_track_format}} to identify the
  format code for your raw data, and also \code{\link{read_experiment}} for processing
  many tracks at once.
}
