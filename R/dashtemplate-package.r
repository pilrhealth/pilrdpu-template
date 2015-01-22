#' @export

test_job <- function(data, params) {

    df <- data.frame(Var1 = rnorm(10),
                     Var2 = letters[1:10])
    df$pt <- unique(params$params$participant)
    df$id <- uuid::UUIDgenerate()
    df$timestamp <- format(Sys.time(), format = "%Y-%m-%dT%H:%M:%SZ")

    datasets <- list(test_dataset = df)

    base64_rep <- test_report(data, params)
    files    <- list(test_report  = jsonlite::unbox(base64_rep))
    
    list(datasets = datasets, files = files)
}

test_report <- function(data, params) {
  test_template <- system.file("Rnw", "test_report.rnw",
                                package = params$package,
                                lib.loc = params$lib)
  texfile <- knitr::knit(test_template)
  tools::texi2pdf(texfile)

  pdf_filename <- paste0(getwd(), "/test_report.pdf")
  base64enc::base64encode(pdf_filename)
}

