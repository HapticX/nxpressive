#[
  Provides all private templates
]#

template defaultNode*(node_type: untyped): untyped =
  ## Initializes default fields
  result = `node_type`(
    children: @[],
    tag: tag,
    is_ready: false,
    on_ready: default_event_handler,
    on_destroy: default_event_handler,
    on_enter: default_event_handler,
    on_exit: default_event_handler,
    on_process: default_event_handler,
    parent: nil,
    pause_behavior: PauseBehavior.Inherit
  )
