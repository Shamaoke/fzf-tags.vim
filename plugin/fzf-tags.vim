vim9script
##                ##
# ::: Fzf Tags ::: #
##                ##

import 'fzf-run.vim' as Fzf

var spec = {
  'set_fzf_data': (data) =>
    readfile('tags')
      ->filter((_, v) => v !~ '^!')
      ->map((_, v) => v->split('\t'))
      ->map((_, v) => $"{v[3]->split(':')[1]}\t{v[0]}\t{v[1]}\t{v[4]->split(':')[1]}")
      ->sort()
      ->writefile(data),

  'set_tmp_file': ( ) => tempname(),
  'set_tmp_data': ( ) => tempname(),

  'geometry': {
    'width': 0.8,
    'height': 0.8
  },

  'commands': {
    'enter':  (entry) => $"edit +{entry->split('\t')->get(3)->trim()} {entry->split('\t')->get(2)}",
    'ctrl-t': (entry) => $"tabedit +{entry->split('\t')->get(3)->trim()} {entry->split('\t')->get(2)}",
    'ctrl-s': (entry) => $"split +{entry->split('\t')->get(3)->trim()} {entry->split('\t')->get(2)}",
    'ctrl-v': (entry) => $"vsplit +{entry->split('\t')->get(3)->trim()} {entry->split('\t')->get(2)}"
  },

  'term_command': [
    'fzf',
    '--no-multi',
    '--preview-window=border-left:+{4}-/2',
    '--preview=bat --color=always --style=numbers --highlight-line={4} {3} 2>/dev/null || echo ""',
    '--ansi',
    '--delimiter=\t',
    '--tabstop=1',
    '--nth=1,2,3',
    '--bind=ctrl-h:first,ctrl-e:last,alt-h:preview-top,alt-e:preview-bottom,alt-j:preview-down,alt-k:preview-up,alt-p:toggle-preview,alt-x:change-preview-window(right,90%|right,50%)',
    '--expect=enter,ctrl-t,ctrl-s,ctrl-v'
  ],

  'set_term_command_options': (data) =>
    [ $"--bind=start:reload^cat {data} | column --table --separator='\t' --output-separator='\t' --table-right=4^" ],

  'term_options': {
    'hidden': true,
    'out_io': 'file'
  },

  'popup_options': {
    'title': '─ ::: Fzf Tags ::: (ctags --recurse --excmd=number --fields=Kzn) ─',
    'border': [1, 1, 1, 1],
    'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└']
  }
}

command FzfTT Fzf.Run(spec)

# vim: set textwidth=80 colorcolumn=80:
