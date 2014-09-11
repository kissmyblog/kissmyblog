(($, window) ->
  class App.Toolbar
    constructor: (target) ->
      @$toolbar    = $(target)
      @speed       = 1000
      @$bookBlock  = $('.bb-bookblock')
      @md_editor   = window.cm_md
      @yaml_editor = window.cm_yaml

      @$bookBlock.bookblock({
        speed : @speed,
        shadowSides : 0.8,
        shadowFlip : 0.4,
        onEndFlip : (previous, current, isLimit) => @yaml_editor.refresh()
      })

      #,
      #onEndFlip : (previous, current, isLimit) => this.updateNav(current)

      @bb = @$bookBlock.data('bookblock')

      # Initializing Bookblock hides the editor, so let's refresh it
      @md_editor.refresh()
      @yaml_editor.refresh()

      @$toolbar.on('click', 'a', (e) => e.preventDefault())
      @$toolbar.on('click', 'a.toolbar-bold', => this.bold())
      @$toolbar.on('click', 'a.toolbar-italic', => this.italic())
      @$toolbar.on('click', 'a.toolbar-h1', => this.h1())
      @$toolbar.on('click', 'a.toolbar-h2', => this.h2())
      @$toolbar.on('click', 'a.toolbar-h3', => this.h3())
      @$toolbar.on('click', 'a.file', => this.showFile())
      @$toolbar.on('click', 'a.meta-data', => this.showMetaData())
      @$toolbar.on('click', 'a.save', => this.save())

    updateNav: (current) ->
      if current == 0
        @$toolbar.find('a.file').addClass('active')
        @$toolbar.find('a.meta-data').removeClass('active')
      else
        @$toolbar.find('a.meta-data').addClass('active')
        @$toolbar.find('a.file').removeClass('active')

    showFile: ->
      this.endAnimation()
      format_style = {
        opacity: 1,
        transition: 'opacity ' + @speed / 2 + 'ms ' + 'linear' + ' ' + @speed / 2 + 'ms'
      }
      @$toolbar.find('.format').css(format_style)
      @bb.first()
      @$toolbar.find('a.file').addClass('active')
      @$toolbar.find('a.meta-data').removeClass('active')

    showMetaData: ->
      this.endAnimation()
      format_style = {
        opacity: 0,
        transition: 'opacity ' + @speed / 2 + 'ms ' + 'linear' + ' ' + @speed / 2 + 'ms'
      }
      @$toolbar.find('.format').css(format_style)
      @bb.last()
      @$toolbar.find('a.meta-data').addClass('active')
      @$toolbar.find('a.file').removeClass('active')

    endAnimation: ->
      @$bookBlock.find( '.bb-page' ).remove()
      @bb.$nextItem?.show()
      @bb.end = false
      @bb.isAnimating = false

    bold: ->
      s = @md_editor.getSelection()
      if s.charAt(0) == '*' && s.charAt(s.length - 1 == '*')
        @md_editor.replaceSelection(s.replace(/\*/g, ''), 'around')
      else
        @md_editor.replaceSelection('**' + s.replace(/\*/g, '') + '**', 'around')

    italic: ->
      s = @md_editor.getSelection()
      if s.charAt(0) == '_' && s.charAt(s.length - 1 == '_')
        @md_editor.replaceSelection(s.replace(/_/g, '', 'around'))
      else
        @md_editor.replaceSelection('_' + s.replace(/_/g, '') + '_', 'around')

    h1: ->
      s = @md_editor.getSelection()
      if s.charAt(0) == '#' && s.charAt(1) != '#'
        @md_editor.replaceSelection(this.lTrim(s.replace(/#/g, '')), 'around')
      else
        @md_editor.replaceSelection('# ' + s.replace(/#/g, ''), 'around')

    h2: ->
      s = @md_editor.getSelection()
      if s.charAt(0) == '#' && s.charAt(1) == '#' && s.charAt(2) != '#'
        @md_editor.replaceSelection(this.lTrim(s.replace(/#/g, '')), 'around')
      else
        @md_editor.replaceSelection('## ' + s.replace(/#/g, ''), 'around')

    h3: ->
      s = @md_editor.getSelection()
      if s.charAt(0) == '#' && s.charAt(1) == '#' && s.charAt(2) == '#' && s.charAt(3) != '#'
        @md_editor.replaceSelection(this.lTrim(s.replace(/#/g, '')), 'around')
      else
        @md_editor.replaceSelection('### ' + s.replace(/#/g, ''), 'around')

    lTrim: (str) ->
      return str.replace(/^\s\s*/, '')

    save: ->
      $('#post_form').submit()
      #n = new App.Notification(message: 'File saved')
      #n.show()
) window.jQuery, window