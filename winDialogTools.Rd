\name{winDialogTools}
\alias{winDialogTools}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Tools of windows dialogs(Help Exist)}
\description{
Function to create dialog.
}
\usage{
winDialogTools(initials = NULL, types = NULL, labels = NULL, 
               message = "Message", title = "WinDialogTools()", 
               message.font = tkfont.create(size = 11, weight = "normal", slant = "roman"), 
               tools.font = tkfont.create(size = 10, weight = "normal", slant = "roman"), 
               labels.sep = "", 
               entry.width = 20, 
               max.tools = 20)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{initials}{
Initial value or element of widget. (list)
}
  \item{types}{
Widget type. (vector)
}
  \item{labels}{
The label displayed to the left of the widget. (vector)
}
  \item{message}{
Dialog message.
}
  \item{title}{
Title of the dialog.
}
  \item{message.font}{
Font setting of dialog message. (tkfont.create)
}
  \item{tools.font}{
Font setting of the label displayed on the left of the widget. (tkfont.create)
}
  \item{labels.sep}{
Characters to put between the widget and the label to the left of it.
}
  \item{entry.width}{
Width of input box.
}
  \item{max.tools}{
Maximum number of widgets in one tab.
}
}
\details{
The list of available widgets is as follows.\cr
Numeric: Numerical value input box\cr
Character: Character string input box\cr
Logical: TRUE or FALSE\cr
Checkbox: Check box (multiple selections allowed)\cr
Combobox: Combo box (single selection)\cr
Radiobutton: Radio button (singular selection)\cr
Label: Label (mainly delimited)\cr
Openfile_m: File selection box (multiple selection)\cr
Openfile_s: File selection box (singular selection)\cr
Choosedir: Directory selection box (single selection)\cr
Savefile: Save file setting box\cr
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
#set initials
ini <- list()
ini[[1]] <- 1
ini[[2]] <- "initials"
ini[[3]] <- T
ini[[4]] <- c("a", "b", "c", "d")
ini[[5]] <- c("a", "b", "c", "d")
ini[[6]] <- c("a", "b", "c", "d")
ini[[7]] <- "---Label---"
ini[[8]] <- "a"
ini[[9]] <- "a"
ini[[10]] <- "a"
ini[[11]] <- "a"
#set types
typ <- c("numeric", "character", "logical", "checkbox", "combobox", "radiobutton", "label", "openfile_m", "openfile_s", "choosedir", "savefile")
#set labels
lab <- c("numeric", "character", "logical", "checkbox", "combobox", "radiobutton", "label", "openfile_m", "openfile_s", "choosedir", "savefile")
#Run!
winDialogTools(initials = ini, types = typ, labels = lab, message = "Input", title = "Test")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
