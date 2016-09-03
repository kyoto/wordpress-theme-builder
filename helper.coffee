module.exports =

  # Output values to the console
  out: (value) ->
    # Convert the array or object into a string
    value = if typeof value == "string" then value else util.inspect(value)

    process.stdout.write("#{value}\n")
