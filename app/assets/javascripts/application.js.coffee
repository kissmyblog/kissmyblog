# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require bootstrap-sprockets
#= require jquery_ujs
#= require jquery.bookblock
#= require zeroclipboard
#= require marked
#= require turbolinks
#
#= require codemirror
#= require codemirror/modes/markdown
#= require codemirror/modes/gfm
#= require codemirror/modes/ruby
#= require codemirror/modes/yaml
#
#= require app
#= require notifications
#= require toolbar

ready = ->
  marked.setOptions({
    renderer: new marked.Renderer(),
    gfm: true
    tables: true
    breaks: false
    pedantic: false
    sanitize: true
    smartLists: true
    smartypants: false
  })

  $('textarea.md').each ->
    window.cm_md = CodeMirror.fromTextArea(this, {
      mode: 'markdown',
      lineNumbers: true,
      matchBrackets: true,
      lineWrapping: true,
    })
  $('textarea.yaml').each ->
    window.cm_yaml = CodeMirror.fromTextArea(this, {
      mode: 'yaml'
    })
  $('.toolbar').each ->
    App.toolbar = new App.Toolbar(this)
  $('.marked').each ->
    #console.log(this)
    $this = $(this)
    $this.html(marked($this.data('content')))
  new ZeroClipboard($('.js-zeroclipboard'))
#$(document).ready(ready)
$(document).on('page:update', ready)