#
class Demo

  constructor: () ->
    @client = new Client()

  # Runs the demo
  run: () ->
    @client.connect();

    # Attempt to reconnect when the connection is dropped.
    @client.on 'disconnect', =>
      @client.reconnect()

    # Subscripe to posts and comments when connected.
    @client.on 'connect', =>
      @client.subscribe 'posts'
      @client.subscribe 'comments'

    # Print a comment when it is received.
    @client.on 'comment', (comment) =>
      @print comment

    # Print a post when it is received.
    @client.on 'post', (post) =>
      @print post


  # Pads a string to a target length with whitespace to the right.
  rpad: (string, targetLength) ->
    if string.length <= targetLength
      for _ in [0...targetLength - string.length]
        string += ' '

    return string


  # Pads a string to a target length with whitespace to the left.
  lpad: (string, targetLength) ->
    if string.length <= targetLength
      for _ in [0...targetLength - string.length]
        string = ' ' + string

    return string


  # Prints a model to the console.
  print: (model) ->
    data = model.data

    # Local time of day when the model was created
    time = new Date(data.created_utc * 1000).toTimeString().split(' ')[0]

    if model.kind is 't1'
      type = @rpad('Comment', 7)
      text = data.body.replace(/\s/g, ' ')
      subr = data.subreddit
      user = data.author

    else
      type = @rpad('Post', 7)
      text = data.title
      user = data.author
      subr = if data.subreddit then data.subreddit else '(promoted)'

    length = @lpad("#{text.length}", 5)

    user = 'u/' + @rpad(user, 21).blue.bold
    subr = 'r/' + @rpad(subr, 22).red.bold

    console.log "[#{time}] #{type} by #{user} in #{subr} #{length}".grey


module.exports = new Demo()
