
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

reviewer <- function() {

    ui <- miniUI::miniPage(
        mypackageDependencies(),
        # tags$head(tags$link(rel="stylesheet", href="jquery-ui.css")),
        # tags$head(tags$link(rel="stylesheet", href="jquery-ui.structure.css")),
        # tags$head(tags$link(rel="stylesheet", href="jquery-ui.theme.css")),
        # tags$head(tags$script(src="jquery-3.3.1.js")),
        # tags$head(tags$script(src="jquery-ui.js")),
        # tags$head(tags$script(src="reviewer.js")),
        miniUI::gadgetTitleBar("Accept or reject changes"),
        miniUI::miniContentPanel(

            shiny::includeHTML("template.html"),
            reviewed <- NULL


        )
    )

    server <- function(input, output, session) {




        # Handle the Done button being pressed.

        shiny::observeEvent(input$done, {

            shiny::stopApp()
        })
    }

    shiny::runGadget(ui, server, viewer = shiny::browserViewer())
}
