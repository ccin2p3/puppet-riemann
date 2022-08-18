#
define riemann::let (
  $content = $title,
  $streams = 'default',
)
{
  if (is_array($content)) {
    $content_string = join(flatten($content), ' ')
  } elsif (is_hash($content)) {
    $content_string = join(sort(join_keys_to_values($content, ' ')),' ')
  } else {
    $content_string = $content
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
