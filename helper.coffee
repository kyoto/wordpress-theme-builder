module.exports =

  # Display help information
  outputHelp: () ->
    # TODO: Look for a standardized way to render the help information

    this.out ""
    this.out "Usage: wptb <task>"
    this.out ""
    this.out "where <task> is one of:"
    this.out this.getTasks()
    this.out ""
    this.out "wptb                   runs the default task"
    this.out "wptb help              displays this help screen"
    this.out "wptb init              initializes the project and WordPress"
    this.out "wptb watch             runs the default task and watches"
    this.out "wptb -e <environment>  runs the default task in the chosen environment"
    this.out ""
    this.out ""

  # Wrapper for outputHelp
  help: () ->
    this.outputHelp()

  # Output values to the console
  standardOutput: (value) ->
    # Convert the array or object into a string
    value = if typeof value == "string" then value else util.inspect(value)

    process.stdout.write("#{value}\n")

  # Wrapper for standardOutput
  out: (value) ->
    this.standardOutput(value)


  # Lists all the available tasks
  getTasks: () ->
    tasks = "      "
    lineLength = 0

    for key,task of gulp.tasks
      tasks += "#{task.name}, "
      lineLength += task.name.length

      if lineLength > 50
        lineLength = 0
        tasks += "\n      "
    tasks = tasks.substring(0, tasks.length-2)



