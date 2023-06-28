#
define riemann::let (
  Variant[Array[String[1]],Hash[String[1], String[1]],String[1]] $content = $title,
  String[1] $streams = 'default',
)
{
  $content_string = $content ? {
    Array   => join(flatten($content), ' '),
    Hash    => join(sort(join_keys_to_values($content, ' ')),' '),
    String  => $content,
  }
  include riemann
  if !defined(Riemann::Streams[$streams]) {
    riemann::streams { $streams: }
  }

  @riemann::config::fragment { "let ${title}":
    section    => "let streams ${streams}",
    subscriber => 'local',
    content    => "      ${content_string}",
  }
}
