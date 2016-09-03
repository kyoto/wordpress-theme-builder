module.exports =
  out: (value) ->
    process.stdout.write(util.inspect(value))
    process.stdout.write("\n")
