# Inspired from notificationFx.js (http://www.codrops.com)
(($, window) ->
  class App.Notification
    defaults:
      wrapper  : 'body'
      message  : 'yo!'
      type     : 'error'
      ttl      : 4000
      closeBtn : false

    animationEndEventNames:
      WebkitAnimation : 'webkitAnimationEnd',
      MozAnimation    : 'animationend',
      OAnimation      : 'oAnimationEnd oanimationend',
      animation       : 'animationend'

    animationIterationEventNames:
      WebkitAnimation : 'webkitAnimationIteration',
      MozAnimation    : 'animationiteration',
      OAnimation      : 'oAnimationIteration oanimationiteration',
      animation       : 'animationiteration'

    constructor: (options) ->
      @options          = $.extend({}, @defaults, options)
      @$target          = $(this.template())

      #if @options['closeBtn']
      #  $('<span class="ns-close"></span></div>').appendTo(@$target)

      p = Modernizr.prefixed('animation')
      @animEndEventName       = @animationEndEventNames[p]
      @animIterationEventName = @animationIterationEventNames[p]

      @$target.prependTo(@options['wrapper'])

      @$target.on('click', '.ns-close', => this.dismiss())
      @$target.on('click', '.ns-close', => this.dismiss())

      this.load()

    template: ->
      """
      <div class="ns-box ns-other ns-effect-boxspinner ns-type-#{@options['type']}" >
        <div class="ns-box-inner">
          <div class="ns-message">#{@options['message']}</div>
          #{if @options['closeBtn'] then '<span class="ns-close"></span></div>' else ''}
        </div>
      </div>
      """

    message:(message) ->
      @$target.children('.ns-message').html(message)

    load: ->
      @active = true
      @$target.removeClass('ns-hide ns-show').addClass('ns-load')

    show: ->
      @active = true
      @$target.on(@animIterationEventName, =>
        @$target.off(@animIterationEventName)
        @$target.addClass('ns-show').removeClass('ns-hide ns-load')
      )

      @dismissTtl = this.delay(@options['ttl'], => this.dismiss() if @active)

    dismiss: ->
      @active = false
      clearTimeout(@dismissTtl)
      if @$target.hasClass('ns-load')
        @$target.on(@animIterationEventName, =>
          @$target.off(@animIterationEventName)
          @$target.addClass('ns-hide-loading').removeClass('ns-show ns-load')
          this.delay(25, => @$target.addClass('ns-hide'))
          this.scheduleRemove()
        )
      else
        @$target.removeClass('ns-show')
        this.delay(25, => @$target.addClass('ns-hide'))
        this.scheduleRemove()

    scheduleRemove: ->
      @$target.on(@animEndEventName, =>
        @$target.off(@animEndEventName)
        @$target.remove()
      )

    delay: (ms, func) -> setTimeout func, ms
) window.jQuery, window