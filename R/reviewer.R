
#' mypackageDependencies
#' load Javascript and css assets required
#'
#'
#' @return An object that can be included in a list of dependencies passed to
#' attachDependencies.
#'
#' @keywords internal
mypackageDependencies <- function() {
            htmltools::htmlDependency(name = "mypackage-assets", version = "0.1",
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
#' @param wordDoc character path to Word .docx file
#'
#' @return character path to markdown file
#' @export
#'
#' @examples reviewer()
reviewer <- function(wordDoc = NULL ) {


    template <- system.file("extdata", "template.html", package = "reviewer")

    ui <- miniUI::miniPage(
        mypackageDependencies(),
        # tags$head(tags$link(rel="stylesheet", href="jquery-ui.css")),
        # tags$head(tags$link(rel="stylesheet", href="jquery-ui.structure.css")),
        # tags$head(tags$link(rel="stylesheet", href="jquery-ui.theme.css")),
        # tags$head(tags$script(src="jquery-3.3.1.js")),
        # tags$head(tags$script(src="jquery-ui.js")),
        # tags$head(tags$script(src="reviewer.js")),
        miniUI::gadgetTitleBar("Accept or reject changes"),

        miniUI::miniButtonBlock(
          shiny::fileInput("docx", label = NULL, placeholder =  "Choose .docx to review",
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


            shiny::includeHTML(template)



        )
    )

    server <- function(input, output, session) {

      shiny::observeEvent(input$docx,{
        pandoc(input$docx$datapath)
       # print(input$docx)
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

    shiny::runGadget(ui, server, viewer = shiny::dialogViewer("review changes"))

}


#' Call pandoc
#'
#' @param input length one character vector  path to input file
#' @param from length one character vector format to convert from
#' @param to length one character vector format to convert to
#'
#' @return length one character vector of converted document

#' @keywords  internal
#' @examples pandoc("test.docx","docx", "html")
pandoc <-  function(input, from, to) {

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

  args <- c(from, to , input, track)
  cmd = paste(c(pandoc,args) , collapse =' ')

  message('executing ', cmd)
  system2(pandoc, args, stdout = TRUE)

}
