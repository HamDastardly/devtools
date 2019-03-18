" Template copied from bundle/tabular/after/plugin/TabularMaps.vim

if !exists(':Tabularize') || get(g:, 'no_default_tabular_maps', 0)
  finish " Tabular.vim wasn't loaded or the default maps are unwanted
endif

let s:save_cpo = &cpo
set cpo&vim

AddTabularPattern! comment /\/\//l1
AddTabularPattern! doxygen_comment /\/\/\/</l1
AddTabularPattern! csv /,\zs\s/l0l0
AddTabularPattern! curlies /\({\|}\)/l1l1
AddTabularPattern! params1 /\vparam\[(in|out|in,out)\]\s+\zs\w+\ze/l1l1
AddTabularPattern! params2 /\vparam\[(in|out|in,out)\]\s+\w+\zs\s\ze/l0l1
AddTabularPattern! commas  /,/l0l1

let &cpo = s:save_cpo
unlet s:save_cpo
