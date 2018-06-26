
#' mypackageDependencies
#' load Javascript and css assets required
#'
#'
#' @return An object that can be included in a list of dependencies passed to
#' attachDependencies.
#'
#' @keywords internal
mypackageDependencies <- function() {
            htmltools::htmlDependency(
                                  name = "mypackage-assets",
                                  version = "0.1",
                                  package = "reviewer",
                                  src = "assets",
                                  script = c("scripts/jquery-3.3.1.js",
                                              "scripts/jquery-ui.js",
                                              "scripts/reviewer.js"),

                                  stylesheet = c("css/jquery-ui.css",
                                                  "css/jquery-ui.structure.css",
                                                  "css/jquery-ui.theme.css",
                                                  "css/reviewer.css")
    )
}

#' Launch addin to review changes
#' Launches and addin to review, accept or rect changes in a
#' Microsoft Word .docx file and then convert the reult to a markdown file
#' @param viewer type of viewer to open
#'
#' @return character path to markdown file
#' @export
#'
#' @examples
#' \dontrun{
#' reviewer()
#' }
reviewer <- function(viewer = shiny::dialogViewer("review changes")) {


    template <- system.file("extdata", "template.html", package = "reviewer")

    ui <- miniUI::miniPage(
        mypackageDependencies(),
        miniUI::gadgetTitleBar("Accept or reject changes"),

        miniUI::miniButtonBlock(
          shiny::fileInput("docx",
                           label = NULL,
                           placeholder =  "Choose .docx to review",
                           accept = c(
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                             ".docx")
          ),
          # shiny::actionButton("next", "Next change"),
          # shiny::actionButton("previous", "Previous change"),
          # shiny::actionButton("accept_all", "Accept all changes"),
          # shiny::actionButton("reject_all", "Reject all changes"),
          shiny::actionButton("complete", "Generate markdown"),
          border = "bottom"
        ),

        miniUI::miniContentPanel(


            shiny::includeHTML(template),
            shiny::tags$div(id="placeholder")



        )
    )

    server <- function(input, output, session) {

      shiny::observeEvent(input$docx,{
        doc <- pandoc(input$docx$datapath,"docx","html")
        shiny::insertUI(
          selector = '#placeholder',
          ui =  shiny::HTML( doc)
        )
      })

      shiny::observeEvent(input$complete,{
         session$sendCustomMessage(type = 'complete' ,
                                   message = 'generate')
      })



        shiny::observeEvent(input$reviewed,{
        })

        # Handle the Done button being pressed.

        shiny::observeEvent(input$done, {

            shiny::stopApp(input$reviewed)
        })

    }


    shiny::runGadget(ui, server, viewer = viewer)
}


#' Call pandoc
#'
#' @param file length one character vector  path to input file
#' @param from length one character vector format to convert from
#' @param to length one character vector format to convert to
#' @param input character vector to be pased as stdin to pandoc
#'
#' @return length one character vector of converted document

#' @keywords  internal
pandoc <-  function(file = NULL, from, to, input = NULL) {

  pandoc_dir <- Sys.getenv("RSTUDIO_PANDOC")

  from <- c('-f', from)
  to <- c('-t', to)
  track <- c('--track-changes=all')
  #pandoc_dir <- '%ProgramFiles%/Rstudio/bin/pandoc'
  pandoc <-  file.path(pandoc_dir, 'pandoc')

    if (pandoc_dir == '') {
            pandoc_dir <- Sys.which('pandoc')
             if (pandoc_dir == '') {
               stop('Please install pandoc first: http://pandoc.org')
               }
    }

  args <- c(from, to , file, track)
  cmd <-  paste(c(pandoc,args) , collapse =' ')

  message('executing ', cmd)
  system2(pandoc, args, stdout = TRUE, input = input )

}
