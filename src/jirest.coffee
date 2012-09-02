fs = require 'fs'
uri = require 'url'
JSON = require '../node_modules/json3'
_ = require '../node_modules/underscore'
colors = require '../node_modules/colors'
request = require '../node_modules/request'
eco = require '../node_modules/eco'
open = require '../node_modules/open'
relative = require '../node_modules/relative-date'

myself = JSON.parse fs.readFileSync __dirname + '/../package.json', 'utf8'

getUserHome = () ->
  if process.platform is 'win32'
    return process.env.USERPROFILE
  else
    return process.env.HOME

self = module.exports
config_filename = getUserHome() + '/.jirest/config.json'
config = {
  debug: false
  URI: undefined
  restURI: undefined
  user: undefined
  pass: undefined
  tpl:
    issue: __dirname + '/../.jirest/issue.tpl'
}
if fs.existsSync config_filename
  config_file = JSON.parse fs.readFileSync config_filename, 'utf8'
  _.extend config, config_file
for tpl of config.tpl
  config.tpl[tpl] = fs.readFileSync config.tpl[tpl], 'utf8'
tpl = config.tpl

colors.setTheme
  silly: 'rainbow'
  input: 'grey'
  verbose: 'cyan'
  prompt: 'grey'
  info: 'green'
  data: 'grey'
  help: 'cyan'
  warn: 'yellow'
  debug: 'blue'
  error: 'red'

available_scopes = [
  'auth'
  'issue'
  'user'
]


#
self.myself = myself


#
dispatch = exports.dispatch = {}


#
exports.printVersion = () ->
  console.log self.myself.version


#
exports.log = (args...) ->
  console.log.apply console, args  if config.debug


#
exports.request = (options, callback) ->
  options.uri = config.restURI + options.uri
  options.uri = uri.parse options.uri
  options.uri.auth = config.user + ':' + config.pass

  options.headers ?= {}
  options.headers.accept = 'application/json'
  if options.body
    options.headers['content-type'] = 'application/json'

  callbackWrapper = (error, response, body) ->
    if error
      console.log JSON.stringify(error, null, 2).error
      process.exit 1

    try
      body = JSON.parse body  if body
    catch e
    callback error, response, body

  request options, callbackWrapper


#
exports.exec = (commands, args, opts) ->

  config.debug = args.debug?
  config.restURI = config.URI + '/rest/api/latest'

  commands.unshift 'issue'  if /[A-Za-z]+\-\d+/.test commands[0]

  unless commands.length
    self.printVersion()
    process.exit 0

  scope = commands[0]
  if scope in available_scopes
    exports.dispatch[scope] commands.slice(1)
  else
    console.log 'unknown scope'
    opts.usage()
    process.exit 1

#
dispatch.issue = (commands) ->
  issues_scopes = [
    'search'
  ]
  issue_scopes = [
    'open'
    'read'
    'branch'
    'comment'
    'comments'
    'assignme'
  ]
  if (command = commands[0]) in issues_scopes
    commands.splice 0, 1
    dispatch.issue[command] commands
  else
    key = commands[0]
    command = commands[1]
    command = 'read'  unless command in issue_scopes
    dispatch.issue[command] key, commands


#
dispatch.issue.branch = (key, commands) ->
  self.request {
    method: 'GET',
    uri: '/issue/' + key
  }, (error, response, body) ->
    process.exit 1  unless response.statusCode is 200
    branchName = body.key + ' ' + body.fields.summary
    branchName = branchName.toLowerCase()
    branchName = branchName.replace /[^A-Za-z0-9]+/g, '-'
    console.log branchName


#
dispatch.issue.read = (key, commands) ->
  self.request {
    method: 'GET',
    uri: '/issue/' + key
    commands: commands
  }, (error, response, body) ->
    process.exit 1  unless response.statusCode is 200
    # FIXME
    body.fields.key = body.key
    body.fields.self = body.self
    console.log eco.render tpl.issue, {
      opts: {}
      issue: body.fields
      _relative: relative
    }

#
dispatch.issue.open = (key, commands) ->
  open config.URI + '/browse/' + key
