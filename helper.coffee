module.exports =

  # Display help information
  help: () ->
    # TODO: Look for a standardized way to render the help information

    this.out ""
    this.out "Usage: wptb <task>"
    this.out ""
    this.out "where <task> is one of:"
    this.out this.tasks()
    this.out ""
    this.out "wptb                   runs the default task"
    this.out "wptb help              displays this help screen"
    this.out "wptb init              initializes the project and WordPress"
    this.out "wptb watch             runs the default task and watches"
    this.out "wptb -e <environment>  runs the default task in the chosen environment"
    this.out ""
    this.out ""


  # Output values to the console
  out: (value) ->
    # Convert the array or object into a string
    value = if typeof value == "string" then value else util.inspect(value)

    process.stdout.write("#{value}\n")


  # Lists all the available tasks
  tasks: () ->
    tasks = "      "
    lineLength = 0

    for key,task of gulp.tasks
      tasks += "#{task.name}, "
      lineLength += task.name.length

      if lineLength > 50
        lineLength = 0
        tasks += "\n      "
    tasks = tasks.substring(0, tasks.length-2)
