library(shiny)
library(officer)
library(flextable)
library(tidyverse)


ui <- fluidPage(
  
    column(
      titlePanel("Markdown to Powerpoint"),
        width = 12,
        align = "center",
        tableOutput("data"),
        br(),
        fileInput("file1","Upload R markdown file", accept = ".Rmd"),
        br(),
      textOutput("file_head"),
      br(),
        downloadButton("download_powerpoint", "Download Data to PowerPoint")
    )
)

server <- function(input, output) {
  
  output$file_head <- renderText({
    report <- input$file1 
    
    req(report)
    
    f <- str_split(read_file(report),"\r\n")
    print(f[[1]][1])
  })
    
   
  
  output$download_powerpoint <- downloadHandler(
        filename = function() {  
            "employee_data.pptx"
        },
        content = function(file) {
            flextable_prep <- flextable(my_table) %>% 
                colformat_num(col_keys = c("Age", "Income"), digits = 0) %>% 
                width(width = 1.25) %>% 
                height_all(height = 0.35) %>% 
                theme_zebra() %>% 
                align(align = "center", part = "all")
            
            example_pp <- read_pptx() %>% 
                add_slide(layout = "Title Slide", master = "Office Theme") %>% 
                add_slide(layout = "Title and Content", master = "Office Theme") 
                
            
            print(example_pp, target = file)
        }
    )
}

shinyApp(ui, server)